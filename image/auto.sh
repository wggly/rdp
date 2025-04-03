#!/bin/bash
#
#
echo ""
echo ""
echo "Silahkan Pilih OS yang ingin anda install:"
echo "	1.) Windows 10"
echo "	2.) Windows 2012 R2"
echo "	3.) Windows 2016"
echo "	4.) Windows 2019"
echo "	5.) Windows 2022"
echo "      6.) Win 10 Pro"

read -p "Pilih [1]: " selectos

ethernt="Ethernet Instance 0"

case "$selectos" in
	1|"") selectos="https://image.yha.my.id/2:/windows10.gz";;
	2) selectos="https://image.yha.my.id/2:/windows2012.gz";;
	3) selectos="https://image.yha.my.id/2:/windows2016.gz";;
	4) selectos="https://image.yha.my.id/2:/windows2019.gz";;
	5) selectos="https://image.yha.my.id/2:/windows2022.gz";;
        6) selectos="https://download1349.mediafire.com/je7f1g8jvqsgPMfNTPVCJLN8eQO21TmqLT65Rtukoh0gLGHCMKCiBkdYkGF2BlNUj_hBa3BCQaffkDoIWK2y1V18tEhDBGk19qzGdQSlFSdgcYATRucavvanTvvcIKCs4k8iIMB9iMVka6afAjHu_L8IXi_2gAI9ht6sTHzkM7RdqAk/jfcjxw8q6s201di/Win10ProNew.gz";;
	*) echo "pilihan salah"; exit;;
esac

IP4=$(curl -4 -s icanhazip.com)
getwey=$(ip route | awk '/default/ { print $3 }')


cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)


netsh -c interface ip set address name="$ethernt" source=static address=$IP4 mask=255.255.240.0 gateway=$getwey
netsh -c interface ip add dnsservers name="$ethernt" address=1.1.1.1 index=1 validate=no
netsh -c interface ip add dnsservers name="$ethernt" address=8.8.4.4 index=2 validate=no


ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"


cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"

del "%~f0"
exit
EOF


wget --no-check-certificate -O- $selectos | gunzip | dd of=/dev/vda bs=3M status=progress

mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat

echo 'Your server will turning off in 5 second'
sleep 5
poweroff
