#!/bin/bash

# Copyright (C) 2020 Xiaoxindada <2245062854@qq.com>

LOCALDIR=$(cd "$(dirname "$0")" && pwd)
cd "$LOCALDIR"
source ./bin.sh

Usage() {
cat <<EOT
Usage:
$0 AB|ab or $0 A|a
EOT
}

case $1 in 
  "AB"|"ab"|"A"|"a")
    ;;
  *)
    Usage
    exit 1
    ;;
esac

echo "环境初始化中 请稍候..."
mkdir -p ./tmp
chmod -R 777 ./
rm -rf ./*.img
./workspace_cleanup.sh > /dev/null 2>&1
echo "初始化环境完成"
read -p "请输入需要解压的zip: " zip
zip=$(echo "$zip" | tr -d '"' | tr -d "'")
echo "解压刷机包中..."

if [ -e ./tmp/"$zip" ];then
  7z x "./tmp/$zip" -o"./tmp/"
elif [ -e "$zip" ];then
  7z x "$zip" -o"./tmp/"
else
  echo "当前zip不存在！"
  exit 1
fi

cd ./tmp
# payload.bin检测
if [ -e './payload.bin' ];then
  mv ./payload.bin ../payload
  echo "解压payload.bin中..."
  cd ../payload
  python3 ./payload.py ./payload.bin ./out
  mv ./payload.bin ../tmp
  echo "移动img至输出目录..."
  for img in product system_ext reserve odm boot vendor_boot; do
    if [ -e "./out/${img}.img" ];then
      mv "./out/${img}.img" ../tmp/
    fi
  done
  mv ./out/system.img ../tmp/
  mv ./out/vendor.img ../tmp/
  rm -rf ./out/*
  cd ../tmp
  mv ./system.img ../
  mv ./vendor.img ../

  for img in product system_ext reserve odm boot vendor_boot; do
    if [ -e "./${img}.img" ];then
      mv "./${img}.img" ../
    fi
  done
  echo "转换完成"
fi

# br检测
if [ -e ./system.new.dat.br ];then
   echo "正在解压system.new.dat.br"
   $bin/brotli -d system.new.dat.br
   python3 $bin/sdat2img.py system.transfer.list system.new.dat ./system.img
   mv ./system.img ../
   rm -rf ./system.new.dat

  for img in vendor product system_ext odm; do
    if [ -e ./${img}.new.dat.br ];then
      echo "正在解压${img}.new.dat.br"
      $bin/brotli -d ${img}.new.dat.br
      python3 $bin/sdat2img.py ${img}.transfer.list ${img}.new.dat ./${img}.img
      mv ./${img}.img ../
      rm -rf ./${img}.new.dat
    fi
  done
fi

# dat检测
if [ -e ./system.new.dat.1 ];then
  echo "检测到分段system.new.dat，正在合并"
  cat ./system.new.dat.{1..999} 2>/dev/null >> ./system.new.dat
  rm -rf ./system.new.dat.{1..999}
  python3 $bin/sdat2img.py system.transfer.list system.new.dat ./system.img
  mv ./system.img ../

  for img in vendor product system_ext odm; do
    if [ -e ./${img}.new.dat.1 ];then
      echo "检测到分段${img}.new.dat，正在合并"
      cat ./${img}.new.dat.{1..999} 2>/dev/null >> ./${img}.new.dat
      rm -rf ./${img}.new.dat.{1..999}
      python3 $bin/sdat2img.py ${img}.transfer.list ${img}.new.dat ./${img}.img
      mv ./${img}.img ../
    fi
  done
else
  for img in system vendor product system_ext odm; do
    if [ -e ./${img}.new.dat ];then
      echo "正在解压${img}.new.dat"
      python3 $bin/sdat2img.py ${img}.transfer.list ${img}.new.dat ./${img}.img
      mv ./${img}.img ../
    fi
  done
fi

#img检测
if [ -e ./system.img ];then
  mv ./*.img ../
fi

cd "$LOCALDIR"

make_type=$1
if [ -e ./system.img ];then
  case $make_type in
    "A"|"a") 
      ./SGSI.sh "A"
      ./workspace_cleanup.sh
      exit 0
#!/bin/bash

# Copyright (C) 2020 Xiaoxindada <2245062854@qq.com>

LOCALDIR=$(cd "$(dirname "$0")" && pwd)
cd "$LOCALDIR"
source ./bin.sh

Usage() {
cat <<EOT
Usage:
$0 AB|ab or $0 A|a
EOT
}

case $1 in 
  "AB"|"ab"|"A"|"a")
    ;;
  *)
    Usage
    exit 1
    ;;
esac

echo "环境初始化中 请稍候..."
mkdir -p ./tmp
chmod -R 777 ./
rm -rf ./*.img
./workspace_cleanup.sh > /dev/null 2>&1
echo "初始化环境完成"
read -p "请输入需要解压的zip: " zip
zip=$(echo "$zip" | tr -d '"' | tr -d "'")
echo "解压刷机包中..."

if [ -e ./tmp/"$zip" ];then
  7z x "./tmp/$zip" -o"./tmp/"
elif [ -e "$zip" ];then
  7z x "$zip" -o"./tmp/"
else
  echo "当前zip不存在！"
  exit 1
fi

cd ./tmp
# payload.bin检测
if [ -e './payload.bin' ];then
  mv ./payload.bin ../payload
  echo "解压payload.bin中..."
  cd ../payload
  python3 ./payload.py ./payload.bin ./out
  mv ./payload.bin ../tmp
  echo "移动img至输出目录..."
  for img in product system_ext reserve odm boot vendor_boot; do
    if [ -e "./out/${img}.img" ];then
      mv "./out/${img}.img" ../tmp/
    fi
  done
  mv ./out/system.img ../tmp/
  mv ./out/vendor.img ../tmp/
  rm -rf ./out/*
  cd ../tmp
  mv ./system.img ../
  mv ./vendor.img ../

  for img in product system_ext reserve odm boot vendor_boot; do
    if [ -e "./${img}.img" ];then
      mv "./${img}.img" ../
    fi
  done
  echo "转换完成"
fi

# br检测
if [ -e ./system.new.dat.br ];then
   echo "正在解压system.new.dat.br"
   $bin/brotli -d system.new.dat.br
   python3 $bin/sdat2img.py system.transfer.list system.new.dat ./system.img
   mv ./system.img ../
   rm -rf ./system.new.dat

  for img in vendor product system_ext odm; do
    if [ -e ./${img}.new.dat.br ];then
      echo "正在解压${img}.new.dat.br"
      $bin/brotli -d ${img}.new.dat.br
      python3 $bin/sdat2img.py ${img}.transfer.list ${img}.new.dat ./${img}.img
      mv ./${img}.img ../
      rm -rf ./${img}.new.dat
    fi
  done
fi

# dat检测
if [ -e ./system.new.dat.1 ];then
  echo "检测到分段system.new.dat，正在合并"
  cat ./system.new.dat.{1..999} 2>/dev/null >> ./system.new.dat
  rm -rf ./system.new.dat.{1..999}
  python3 $bin/sdat2img.py system.transfer.list system.new.dat ./system.img
  mv ./system.img ../

  for img in vendor product system_ext odm; do
    if [ -e ./${img}.new.dat.1 ];then
      echo "检测到分段${img}.new.dat，正在合并"
      cat ./${img}.new.dat.{1..999} 2>/dev/null >> ./${img}.new.dat
      rm -rf ./${img}.new.dat.{1..999}
      python3 $bin/sdat2img.py ${img}.transfer.list ${img}.new.dat ./${img}.img
      mv ./${img}.img ../
    fi
  done
else
  for img in system vendor product system_ext odm; do
    if [ -e ./${img}.new.dat ];then
      echo "正在解压${img}.new.dat"
      python3 $bin/sdat2img.py ${img}.transfer.list ${img}.new.dat ./${img}.img
      mv ./${img}.img ../
    fi
  done
fi

#img检测
if [ -e ./system.img ];then
  mv ./*.img ../
fi

cd "$LOCALDIR"

make_type=$1
if [ -e ./system.img ];then
  case $make_type in
    "A"|"a") 
      ./SGSI.sh "A"
      ./workspace_cleanup.sh
      exit 0
      ;;
    "AB"|"ab")  
      ./SGSI.sh "AB"
      ./workspace_cleanup.sh
      exit 0
      ;;
    *)
      echo "error!"
      exit 1
      ;;
    esac
else
  echo "未检测到system.img, 无法制作SGSI！"
  exit 1
fi
