echo -e "\n该小工具可以为你检查本服务器到中国北京、上海、深圳的[回程网络]类型\n"
read -p "按Enter(回车)开始启动检查..." sdad

#iplise=(220.181.38.149 202.106.50.1 221.179.155.161 202.96.209.133 110.242.68.3 211.136.112.200 58.60.188.222 210.21.196.6 120.196.165.24)
#iplocal=(北京电信 北京联通 北京移动 上海电信 河北联通 上海移动 深圳电信 深圳联通 深圳移动)
iplise=(220.181.38.149 112.80.248.76 39.156.66.18 101.91.22.57 110.242.68.3 183.194.238.117 121.14.77.221 163.177.151.110 120.196.165.24)
iplocal=(北京电信 南京联通 北京移动 上海电信 河北联通 上海移动 深圳电信 广州联通 深圳移动)
# install besttrace
if [ ! -f "besttrace2021" ]; then
    wget https://github.com/zq/shell/raw/master/besttrace2021
    # unzip besttrace4linux.zip
    chmod +x besttrace2021
fi

echo -e "\n正在测试,请稍等..."
echo -e "——————————————————————————————\n"
for i in {0..8}; do
	./besttrace2021 -q 1  ${iplise[i]} > /root/traceroute_testlog
	grep -q "59\.43\." /root/traceroute_testlog
	if [ $? == 0 ];then
		num=$(grep -c "202\.97\."  /root/traceroute_testlog)
		if [ $(($num)) -gt 1 ];then
		echo -e "出现202.97的次数：$(($num))"
		echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2 GT\033[0m"
		else
		echo -e "出现202.97的次数：$(($num))"
		echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2 GIA\033[0m"
		fi
	else
		grep -q "202\.97\."  /root/traceroute_testlog
		if [ $? == 0 ];then
			grep -q "219\.158\." /root/traceroute_testlog
			if [ $? == 0 ];then
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
			else
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;34m电信163\033[0m"
			fi
		else
			grep -q "219\.158\."  /root/traceroute_testlog
			if [ $? == 0 ];then
				grep -q "219\.158\.113\." /root/traceroute_testlog
				if [ $? == 0 ];then
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通AS4837\033[0m"
				else
					grep -q "218\.105\." /root/traceroute_testlog
					if [ $? == 0 ];then
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通9929\033[0m"
					else
						grep -q "210\.[0-9]{0,3}\." /root/traceroute_testlog
						if [ $? == 0 ];then
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通9929\033[0m"
						else
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m"
						fi
					fi
				fi
			else				
				grep -q "203\.160\."  /root/traceroute_testlog
				if [ $? == 0 ];then
					grep -q "218\.105\." /root/traceroute_testlog
					if [ $? == 0 ];then
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通9929\033[0m"
					else
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通香港\033[0m"
					fi
				else				
					grep -q "223\.120\."  /root/traceroute_testlog
					if [ $? == 0 ];then
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
					else
						grep -q "221\.183\."  /root/traceroute_testlog
						if [ $? == 0 ];then
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动cmi\033[0m"
						else
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:其他"
						fi
					fi
				fi
			fi
		fi
	fi
echo 
done
rm -f /root/traceroute_testlog
echo -e "\n——————————————————————————————\n本脚本测试结果为TCP回程路由,非ICMP回程路由 仅供参考 谢谢\n"
