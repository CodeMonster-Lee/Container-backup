#!/bin/bash

# 检查当前目录中是否存在 all_images_backup 文件
if [ -f "all_images_backup.tar" ]; then
    echo "找到 all_images_backup.tar 文件，开始解包..."
    tar -xvf all_images_backup.tar
    echo "解包完成。"
elif [ -f "all_images_backup.tgz" ]; then
    echo "找到 all_images_backup.tgz 文件，开始解压缩..."
    tar -xzvf all_images_backup.tgz
    echo "解压缩完成。"
else
    echo "没有找到 all_images_backup 文件，导出异常。"
    exit 1
fi

# 等待 5 秒钟
sleep 5

# 打印开始导入信息
echo "开始导入所有镜像文件..."

# 获取所有 .tar 文件
images=$(ls *.tar)

# 遍历每个 .tar 文件并导入镜像
for image in $images; do
    docker load -i $image
    echo "导入镜像 $image 完成"
done

echo "所有镜像导入成功。"

# 提示用户是否删除解压出来的 .tar 镜像文件
read -p "是否删除解压出来的 .tar 镜像文件？(y/n): " delete_files
if [ $delete_files == "y" ]; then
    rm *.tar
    echo "解压出来的 .tar 镜像文件已删除。"
else
    echo "操作已完成。"
fi
