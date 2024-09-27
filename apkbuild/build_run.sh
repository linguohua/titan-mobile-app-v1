#!/bin/bash

# 获取当前脚本的路径
script_dir=$(dirname "$0")

# 切换到项目根目录
cd "$script_dir/.."

# 检查 pubspec.yaml 文件是否存在
if [[ ! -f pubspec.yaml ]]; then
  echo "Error: pubspec.yaml file not found!"
  exit 1
fi

# 从 pubspec.yaml 文件中提取应用名称和版本号
app_name=$(sed -n 's/^ *name: *\(.*\)/\1/p' pubspec.yaml | head -n 1)
version=$(sed -n 's/^ *version: *\(.*\)/\1/p' pubspec.yaml | head -n 1)

# 检查是否成功提取应用名称和版本号
if [[ -z "$app_name" || -z "$version" ]]; then
  echo "Error: Failed to extract app name or version from pubspec.yaml!"
  exit 1
fi

# 生成带有年月日时分秒的时间戳
current_date=$(date +"%Y%m%d%H%M%S")

# 拼接应用名称
app_name="${app_name}_${current_date}_v${version}"

# 构建 APK
if ! flutter build apk --release; then
  echo "Error: Flutter build failed!"
  exit 1
fi

# 检查生成的 APK 文件是否存在
apk_path="build/app/outputs/flutter-apk/app-release.apk"
if [[ ! -f "$apk_path" ]]; then
  echo "Error: APK file not found!"
  exit 1
fi

# 创建 apkbuild 文件夹（如果不存在）
mkdir -p apkbuild

# 移动文件到 apkbuild 文件夹
if ! mv "$apk_path" "apkbuild/${app_name}.apk"; then
  echo "Error: Failed to move APK file!"
  exit 1
fi

echo "已生成应用包：apkbuild/${app_name}.apk"
