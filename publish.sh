#!/bin/bash

 # 确保脚本抛出遇到的错误
 set -e
 # ⽣成静态⽂件
echo "####### build sart #######"
hugo -D
echo "####### build end #######"
 # 进⼊⽣成的⽂件夹
 echo "####### 开始推送 #######"
 message="feat: publish"
 if [[ $1 ]]; then
     message=\"$1\"
fi
echo $message

 cd public
 git init
 git add -A
 git commit -m "$message"
 git branch -M main
 git push -f git@github.com:zggz/zggz.github.io.git main
 echo "####### 推送成功 #######"
 cd -
