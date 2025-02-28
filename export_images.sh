#!/bin/bash

# 提示用户确认是否在当前目录中进行容器导出
read -p "是否在当前目录中进行容器导出？(y/n): " confirm
if [[ $confirm != "y" ]]; then
    echo "操作已取消。"
    exit 1
fi

# 获取所有正在运行的容器 ID 和镜像名称
containers=$(docker ps --format "{{.ID}} {{.Image}}")

# 遍历每个容器
while read -r container_id image_name; do
    # 提取镜像名称的最后一部分作为文件名
    image_file_name=$(echo $image_name | awk -F'/' '{print $NF}' | awk -F':' '{print $1}')
    
    # 保存镜像为 tar 文件
    docker save -o ${image_file_name}.tar $image_name
    
    echo "导出镜像 ${image_name} 为 ${image_file_name}.tar"
done <<< "$containers"

# 打印导出完成信息并停五秒钟
echo "所有镜像导出完成。"
sleep 5

# 提示用户是否需要压缩
read -p "是否需要压缩所有镜像文件？(y/n): " compress
if [[ $compress == "y" ]]; then
    # 打印开始压缩信息
    echo "开始压缩所有镜像文件..."
    
    # 打包所有 .tar 文件为一个 .tgz 文件
    tar -czvf all_images_backup.tgz *.tar
    
    echo "所有镜像已打包为 all_images_backup.tgz"
else
    # 打印开始打包信息
    echo "开始打包所有镜像文件..."
    
    # 打包所有 .tar 文件为一个 .tar 文件
    tar -cvf all_images_backup.tar *.tar
    
    echo "所有镜像已打包为 all_images_backup.tar"
fi
