#!/bin/bash
# Amol Patil
#Email US :support@djamol.com
 # WEB@DjAmol.com
 
set -a
# Global Variable to access any bash other files run by this file
#TESTVARIABLE=hellohelloheloo
RED='\033[01;31m'
RESET='\033[0m'
INSTALL_SDIR='/root/djamolDEV/ffmpeg'
SOURCE_URL='https://github.com/djamol/offline/raw/master/ffmpeg/9'
INSTALL_DDIR='/usr/loca/avpffmpeg'
export cpu=`cat "/proc/cpuinfo" | grep "processor"|wc -l`
export TMPDIR=$HOME/tmp
export LD_LIBRARY_PATH=/usr/loca/avpffmpeg/lib:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=/usr/loca/avpffmpeg/lib:/usr/lib:/usr/local/lib:$LIBRARY_PATH
export CPATH=/usr/loca/avpffmpeg/include:/usr/include/:usr/local/include:$CPATH
# ...
# Here put all the variables that will be marked for export
# and that will be available from within test2 (and all other commands).
# If test2 modifies the variables, the modifications will never be
# seen in the present script!
set +a

#presetup
echo -e "\e[32m########################################\n#### PRE Install #########\n########################################"
sh presetup.sh
echo -e '
 ▒█░▒░▓█░█▒░▒▒█░█▓░▒░█▓   █████▒    ▓█ ▒█▓▓█▓ ██████ ▓████▒░█░      ░█████░▒████▓ ▓█████░ 
 ░▓ █▓▓█ ▓ ██▒█░▓░▓█░█▓   ▓▒  █▓    ▒█ ▒▓▓▓█▓ ▓░█▓▒█░▓▒  █▓ ▓       ░█░  ▓ ▒▓  ▓█ ▓▒▓█▒█▒ 
 ▒█▒█▓▓█░█▓▓█▒█▒█▓▓█▒█▓   █▓  █▓░▓░ ▓█ ██▒▒█▓░█▒█▓▒█░██  █▓░█▒  ░   ▒█▒ ░▓ ██  ██ █▓▓█░█▒ 
 ░█████▓ ██████ ▓█████░▓█ █████░░█████ █▓  █▓░█▒░░▒█ ▓████▒░█████▒█▓ █████ ▒████▓ █▓░▒░█▒ 
';
echo -e "$GREEN 
# Powered By DjAmol Group Inc         #
# Email : Support@djamol.com          #
# Website : www.djamol.com            #
# Copyright By PatilWeb.com           #
# IG:PatilWeb FB:PatilWeb TW:PatilWeb #
$RESET";
echo -e "\e[32m########################################\n#### PRE SETUP  YUM UPgrade #####\n########################################"
if [ -e "/etc/yum.conf" ];then
        echo "Ensuring required RPM ........"
        yum install gcc gcc-c++ libgcc gd gd-devel gettext freetype \
        	freetype-devel ImageMagick ImageMagick-devel libjpeg* libjpeg-devel* \
        	libpng* libpng-devel* libstdc++* libstdc++-devel* libtiff* \
        	libtiff-devel* libtool*  libxml* libxml2* \
        	libxml2-devel* zlib* zlib-devel* automake* autoconf* samba-common* \
		ncurses-devel ncurses patch make apr-util giflib-devel giflib neon expat expat-devel alsa-lib -y
	rpm -e alsa-lib --nodeps
	export ARCH=$(arch)
fi

if [ -e "/etc/csf/csf.conf" ];then
	csf -x
fi


if [ -e "/etc/debian_version" ];then
	echo "Ensuring Debian packages ....."
	apt-get install gcc libgd-dev gettext libfreetype6 libfreetype6-dev libpng-dev libstdc++-dev \
		libtiff-dev libtool libxml2 libxml2-dev automake autoconf libncurses-dev ncurses-dev patch \
		make git subversion -y
fi
#Git client
sh git.sh

if [ -e "/usr/bin/git" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Git client  installation Failed. Git is required for ffmpeg and mplayer . Please install it and run this script"$RESET
        echo " "
        echo " "
        exit
fi 

#Subversion client
mkdir -pv /usr/loca/avpffmpeg/bin/
sh subversion.sh

if [ -e "/usr/loca/avpffmpeg/bin/svn" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Svn  client  installation Failed.Svn  is required for mplayer . Please install it and run this script"$RESET
        echo " "
        echo " "
        exit
fi 


echo -e "\e[32m########################################\n####1 FREE Type #########\n########################################"
#free type
sh freetype.sh
echo -e "\e[32m########################################\n####2 libwmf #########\n########################################"
#libwmf
sh libwmf.sh
echo -e "\e[32m########################################\n####3 Ruby #########\n########################################"
#ruby
sh ruby.sh
echo -e "\e[32m########################################\n####4 Flv Tool #########\n########################################"
#flvtool
sh flvtool.sh
echo -e "\e[32m########################################\n####5 lame #########\n########################################"
#lame
sh lame.sh
echo -e "\e[32m########################################\n#### 6 codecs #########\n########################################"
#codecs
sh codecs.sh
echo -e "\e[32m########################################\n#### 7 libogg #########\n########################################"
#libogg
sh libogg.sh
echo -e "\e[32m########################################\n#### 8 libvorbis #########\n########################################"
#libvorbis
sh libvorbis.sh
echo -e "\e[32m########################################\n#### 9 vorbistools #########\n########################################"
#vorbistools
sh vorbistools.sh
echo -e "\e[32m########################################\n#### 10 libtheora #########\n########################################"
#libtheora
sh libtheora.sh
echo -e "\e[32m########################################\n#### 11 fdk-aac #########\n########################################"
#fdk-aac
sh fdkaac.sh
echo -e "\e[32m########################################\n#### 12 voaacenc #########\n########################################"
# voaacenc
sh voaacenc.sh
echo -e "\e[32m########################################\n#### 13 voamrwbenc #########\n########################################"
# voamrwbenc
sh voamrwbenc.sh
echo -e "\e[32m########################################\n#### 14 libspeex #########\n########################################"
# libspeex
sh libspeex.sh
echo -e "\e[32m########################################\n#### 15 libflac #########\n########################################"
# libflac
sh libflac.sh
echo -e "\e[32m########################################\n#### 16 libao #########\n########################################"
# libao
sh libao.sh
echo -e "\e[32m########################################\n#### 17 uriparser #########\n########################################"
# uriparser
sh uriparser.sh
# libxspf
#sh libxspf.sh
echo -e "\e[32m########################################\n#### 18 liboggz #########\n########################################"
# liboggz
sh liboggz.sh
# libfishsound
#sh libfishsound.sh
echo -e "\e[32m########################################\n#### 19 yamdi #########\n########################################"
# yamdi
sh yamdi.sh
echo -e "\e[32m########################################\n#### 20 amrnb #########\n########################################"
#amrnb
sh amrnb.sh
echo -e "\e[32m########################################\n#### 21 amrwb #########\n########################################"
#amrwb
sh amrwb.sh
echo -e "\e[32m########################################\n#### 22 libopencoreamr #########\n########################################"
#openamr
sh libopencoreamr.sh
echo -e "\e[32m########################################\n#### 23 liba52 #########\n########################################"
#liba52
sh liba52.sh
echo -e "\e[32m########################################\n#### 24 facc #########\n########################################"
#facc
sh facc.sh
echo -e "\e[32m########################################\n#### 25 faad2 #########\n########################################"
#faad2
sh faad2.sh
echo -e "\e[32m########################################\n#### 26 yasm #########\n########################################"
#yasm
sh yasm.sh
echo -e "\e[32m########################################\n#### 27 nasm #########\n########################################"
#nasm
sh nasm.sh
echo -e "\e[32m########################################\n#### 28 xvid #########\n########################################"
#xvid
sh xvid.sh
echo -e "\e[32m########################################\n#### 29 x265 #########\n########################################"
#x265
sh x265.sh

echo -e "\e[32m########################################\n#### 30 x264 #########\n########################################"
#x264
sh x264.sh
echo -e "\e[32m########################################\n#### 31 re2c #########\n########################################"
#re2c
sh re2c.sh

echo -e "\e[32m########################################\n#### 32 acc #########\n########################################"
#acc
sh acc.sh

#mPlayer FirstAttempt
sh mplayer.sh
if [ -e "/usr/loca/avpffmpeg/bin/mplayer" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Mplayer installation Failed :( , please contact  professional support djamolgroup@gmail.com"$RESET
        echo " "
        echo " "
        exit
fi

echo -e "\e[32m########################################\n#### 33 MAIN FFMPEG FRAMEWORK #########\n#############################"
#ffmpeg
sh ffmpeg.sh
if [ -e "/usr/loca/avpffmpeg/bin/ffmpeg" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   FFMPEG installation Failed :( ,  please contact  professional support djamolgroup@gmail.com"$RESET
        echo " "
        echo " "
        
fi
echo -e "\e[32m########################################\n#### 34 Preset #########\n########################################"
# preset 
sh preset.sh
echo -e "\e[32m########################################\n#### 35 Mplayer  #########\n########################################"
#Rebuilding Mplayer
sh mplayer.sh
if [ -e "/usr/loca/avpffmpeg/bin/mplayer" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Mplayer installation Failed :( , please contact  professional support djamolgroup@gmail.com"$RESET
        echo " "
        echo " "
        
fi
echo -e "\e[32m########################################\n#### 36 MP4Box #########\n########################################"
#Mp4Boxh
sh mp4box.sh
echo -e "\e[32m########################################\n#### POST INSTALL #########\n########################################"
#post
sh post.sh

