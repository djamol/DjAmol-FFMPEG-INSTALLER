#!/bin/bash
# Amol Patil
#Email US :support@djamol.com
 # WEB@DjAmol.com
BUILDDIR=$INSTALL_SDIR/log/
mkdir $INSTALL_SDIR/log
BUILDFILE=$RANDOM.txt
BUILD=$BUILDDIR$BUILDFILE
echo "Build Log File Path is  : ";echo $BUILD;
date +"%r" >> $BUILD;echo "Status : FFMPEG Started" >> $BUILD; 

set -a
# Global Variable to access any bash other files run by this file
#TESTVARIABLE=hellohelloheloo
RED='\033[01;31m'
RESET='\033[0m'
INSTALL_SDIR='/root/djamolDEV/ffmpeg'
SOURCE_URL='https://github.com/djamol/offline/raw/master/ffmpeg/9'
INSTALL_DDIR='/usr/loca/avpffmpeg'
BUILD=$BUILD;
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
date +"%r" >> $BUILD;echo "Status : Pre Install Started" >> $BUILD; 
sh presetup.sh
date +"%r" >> $BUILD;echo "Status : Pre Install END" >> $BUILD; 
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
date +"%r" >> $BUILD;echo "Status : Pre Yum Upgrade" >> $BUILD; 
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
date +"%r" >> $BUILD;echo "Status : Pre Yum Upgrade END" >> $BUILD; 

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
date +"%r" >> $BUILD;echo "Status : Git Install Started" >> $BUILD; 
sh git.sh 
if [ -e "/usr/bin/git" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Git client  installation Failed. Git is required for ffmpeg and mplayer . Please install it and run this script"$RESET
        echo " "
	date +"%r" >> $BUILD;echo "Failed :  Git client  installation Failed. Git is required for ffmpeg and mplayer . Please install it and run this scrip" >> $BUILD;
	echo " "
        exit
fi 

date +"%r" >> $BUILD;echo "Status : Git Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status : subversion Install Started" >> $BUILD; 
#Subversion client
mkdir -pv /usr/loca/avpffmpeg/bin/
sh subversion.sh

if [ -e "/usr/loca/avpffmpeg/bin/svn" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Svn  client  installation Failed.Svn  is required for mplayer . Please install it and run this script"$RESET
	date +"%r" >> $BUILD;echo " Svn  client  installation Failed.Svn  is required for mplayer . Please install it and run this script" >> $BUILD; 
        echo " "
        echo " "
        exit
fi 
date +"%r" >> $BUILD;echo "Status : Git Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :1 FREEType Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n####1 FREE Type #########\n########################################"
#free type
sh freetype.sh
date +"%r" >> $BUILD;echo "Status :1 FreeType Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :2 libwmf Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n####2 libwmf #########\n########################################"
#libwmf
sh libwmf.sh
date +"%r" >> $BUILD;echo "Status :2 libwmf Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :3 Ruby Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n####3 Ruby #########\n########################################"
#ruby
sh ruby.sh
date +"%r" >> $BUILD;echo "Status :3 Ruby Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :4 FlvTool Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n####4 Flv Tool #########\n########################################"
#flvtool
sh flvtool.sh
date +"%r" >> $BUILD;echo "Status :4 Flv Tool Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :5 lame Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n####5 lame #########\n########################################"
#lame
sh lame.sh
date +"%r" >> $BUILD;echo "Status :5 lame Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :6 codecs Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 6 codecs #########\n########################################"
#codecs
sh codecs.sh
date +"%r" >> $BUILD;echo "Status :6 codecs Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :7 libogg Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 7 libogg #########\n########################################"
#libogg
sh libogg.sh
date +"%r" >> $BUILD;echo "Status :7 libogg Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :8 libvorbis Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 8 libvorbis #########\n########################################"
#libvorbis
sh libvorbis.sh
date +"%r" >> $BUILD;echo "Status :8 libvorbis Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :9 vorbistools Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 9 vorbistools #########\n########################################"
#vorbistools
sh vorbistools.sh
date +"%r" >> $BUILD;echo "Status :9 vorbistools Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :10 libtheora Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 10 libtheora #########\n########################################"
#libtheora
sh libtheora.sh
date +"%r" >> $BUILD;echo "Status :10 libtheora Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :11 fdk-aac  Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 11 fdk-aac #########\n########################################"
#fdk-aac
sh fdkaac.sh
date +"%r" >> $BUILD;echo "Status :11 fdk-aac  Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :12 voaacenc Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 12 voaacenc #########\n########################################"
# voaacenc
sh voaacenc.sh
date +"%r" >> $BUILD;echo "Status :12 voaacenc Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :13 voamrwbenc Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 13 voamrwbenc #########\n########################################"
# voamrwbenc
sh voamrwbenc.sh
date +"%r" >> $BUILD;echo "Status :13 voamrwbenc Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :14 libspeex Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 14 libspeex #########\n########################################"
# libspeex
sh libspeex.sh
date +"%r" >> $BUILD;echo "Status :14 libspeex Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :15 libflac Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 15 libflac #########\n########################################"
# libflac
sh libflac.sh
date +"%r" >> $BUILD;echo "Status :15 libflac Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :16 libao Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 16 libao #########\n########################################"
# libao
sh libao.sh
date +"%r" >> $BUILD;echo "Status :16 libao Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :17 uriparser Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 17 uriparser #########\n########################################"
# uriparser
sh uriparser.sh
date +"%r" >> $BUILD;echo "Status :17 uriparser Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :18 liboggz Install Started" >> $BUILD; 
# libxspf
#sh libxspf.sh
echo -e "\e[32m########################################\n#### 18 liboggz #########\n########################################"
# liboggz
sh liboggz.sh
date +"%r" >> $BUILD;echo "Status :18 liboggz Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :19 yamdi Install Started" >> $BUILD; 
# libfishsound
#sh libfishsound.sh
echo -e "\e[32m########################################\n#### 19 yamdi #########\n########################################"
# yamdi
sh yamdi.sh
date +"%r" >> $BUILD;echo "Status :19 yamdi Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :20 amrnb Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 20 amrnb #########\n########################################"
#amrnb
sh amrnb.sh
date +"%r" >> $BUILD;echo "Status :20 amrnb Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :21 amrwb Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 21 amrwb #########\n########################################"
#amrwb
sh amrwb.sh
date +"%r" >> $BUILD;echo "Status :21 amrwb Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :22 libopencoreamr Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 22 libopencoreamr #########\n########################################"
#openamr
sh libopencoreamr.sh
date +"%r" >> $BUILD;echo "Status :22 libopencoreamr Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :23 liba52 Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 23 liba52 #########\n########################################"
#liba52
sh liba52.sh
date +"%r" >> $BUILD;echo "Status :23 liba52 Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :24 facc Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 24 facc #########\n########################################"
#facc
sh facc.sh
date +"%r" >> $BUILD;echo "Status :24 facc Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :25 faad2 Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 25 faad2 #########\n########################################"
#faad2
sh faad2.sh
date +"%r" >> $BUILD;echo "Status :25 faad2 Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :26 yasm Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 26 yasm #########\n########################################"
#yasm
sh yasm.sh
date +"%r" >> $BUILD;echo "Status :26 yasm Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :27 nasm Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 27 nasm #########\n########################################"
#nasm
sh nasm.sh
date +"%r" >> $BUILD;echo "Status :27 nasm Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :28 xvid Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 28 xvid #########\n########################################"
#xvid
sh xvid.sh
date +"%r" >> $BUILD;echo "Status :28 xvid Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :29 x265 Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 29 x265 #########\n########################################"
#x265
sh x265.sh
date +"%r" >> $BUILD;echo "Status :29 x265 Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :30 x264 Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 30 x264 #########\n########################################"
#x264
sh x264.sh
date +"%r" >> $BUILD;echo "Status :30 x264 Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :31 re2c Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 31 re2c #########\n########################################"
#re2c
sh re2c.sh
date +"%r" >> $BUILD;echo "Status :31 re2c Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :32 acc Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 32 acc #########\n########################################"
#acc
sh acc.sh
date +"%r" >> $BUILD;echo "Status :32 acc Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status : mPlayer FirstAttempt Install Started" >> $BUILD; 

#mPlayer FirstAttempt
sh mplayer.sh
if [ -e "/usr/loca/avpffmpeg/bin/mplayer" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   Mplayer installation Failed :( , please contact  professional support djamolgroup@gmail.com"$RESET
	date +"%r" >> $BUILD;echo "Status : First Attempt Mplayer failed" >> $BUILD;
        echo " "
        echo " "
        
fi
date +"%r" >> $BUILD;echo "Status : mPlayer FirstAttempt Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :33 MAIN FFMPEG FRAMEWORK Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 33 MAIN FFMPEG FRAMEWORK #########\n#############################"
#ffmpeg
sh ffmpeg.sh
if [ -e "/usr/loca/avpffmpeg/bin/ffmpeg" ]; then
	date +"%r" >> $BUILD;echo "Success :33 MAIN FFMPEG FRAMEWORK" >> $BUILD;
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   FFMPEG installation Failed :( ,  please contact  professional support djamolgroup@gmail.com"$RESET
	date +"%r" >> $BUILD;echo "Failed :33  FFMPEG installation Failed :( ,  please contact  professional support djamolgroup@gmail.com" >> $BUILD;
        echo " "
        echo " "
        
fi
date +"%r" >> $BUILD;echo "Status :33 MAIN FFMPEG FRAMEWORK Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :34 Preset Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 34 Preset #########\n########################################"
# preset 
sh preset.sh
date +"%r" >> $BUILD;echo "Status :34 Preset Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :35 Rebuilding Mplayer Install Started" >> $BUILD; 

echo -e "\e[32m########################################\n#### 35 Mplayer  #########\n########################################"
#Rebuilding Mplayer
sh mplayer.sh
date +"%r" >> $BUILD;echo "Status :35 Mplayer Install END" >> $BUILD;

if [ -e "/usr/loca/avpffmpeg/bin/mplayer" ]; then
        echo " "
	date +"%r" >> $BUILD;echo "Success  :35 Rebuilding Mplayer" >> $BUILD;
else
        echo " "
        echo " "
        echo -e $RED"   Mplayer installation Failed :( , please contact  professional support djamolgroup@gmail.com"$RESET
	date +"%r" >> $BUILD;echo "Failed :35 Rebuilding Mplayer Failed" >> $BUILD;
        echo " "
        echo " "
        
fi
date +"%r" >> $BUILD;echo "Status :35 Rebuilding Mplayer Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :36 MP4Box Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 36 MP4Box #########\n########################################"
#Mp4Boxh
sh mp4box.sh
date +"%r" >> $BUILD;echo "Status :36 MP4Box Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :37 POST INSTALL Install Started" >> $BUILD; 
echo -e "\e[32m########################################\n#### 37 POST INSTALL #########\n########################################"
#post
sh post.sh
date +"%r" >> $BUILD;echo "Status :37 POST INSTALL Install END" >> $BUILD;
date +"%r" >> $BUILD;echo "Status :100% FFMpeg Process is Ended..Thanks For Choosing Our Service" >> $BUILD; 

