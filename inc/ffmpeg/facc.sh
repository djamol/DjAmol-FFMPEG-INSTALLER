#!/bin/bash
# Amol Patil
#Email US :support@djamol.com
 # WEB@DjAmol.com
RED='\033[01;31m'
RESET='\033[0m'
INSTALL_SDIR='/root/djamolDEV/ffmpeg'
SOURCE_URL='https://github.com/djamol/offline/raw/master/ffmpeg/9'
INSTALL_DDIR='/usr/loca/avpffmpeg'
export cpu=`cat "/proc/cpuinfo" | grep "processor"|wc -l`
export TMPDIR=$HOME/tmp
_package='faac-1.29.9.2.tar.gz'
clear
sleep 2
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

echo -e $RED"Installation of $_package ....... started"$RESET
cd $INSTALL_SDIR/
rm -rf facc*
wget $SOURCE_URL/$_package
tar -xvzf $_package
cd faac-1.29.9.2/
./bootstrap
./configure --prefix=$INSTALL_DDIR  --with-mp4v2      

make -j$cpu
if   make install; then
date +"%r" >> $BUILD;echo "Succcess :faac Installled" >> $BUILD;
echo -e $RED" faac Installed Success ......"$RESET
else
date +"%r" >> $BUILD;echo "Failed :faac Installation Failed" >> $BUILD;
echo -e $RED"Failed :faac Installation Failed ......"$RESET
fi
echo -e $RED"
                        :rvri                     
                  :vJUJYri:::::i::                
            .sDgEJi                 r7i           
         .KQX7.                        .L:        
       iRRs.        5vsvv7v7Yv            Kr      
     :gd5.         5Yv7LYL777I.             M     
    PbuI  ..      ru7rrv:77rrr5              Q7   
   QUYI. .        I7r7vr .srir7j              BJ  
  g2LYj          ULr7rS   17rirJ:              Rr 
  EY7JL         i1r7rj:    2rrirU              KS 
 sUvvvI.        57rr7U     7LrrivJ             r1.
.1sv7vss       2v7r7J       sriiiJ:            r7:
:jjv77r7L     ru777vY       :7rirr2            7i:
 uJvriBMvI:   KL7vr:vuUIUI1urririrru           :r:
  Zvi1BBEiK2i:ii7:...jI2IUI11Lririrvr         ..X 
  gJ5BYB:i.iUYr:..rJ:         Jririrv7        .ur 
   DZQBu : 7Yvv77777j.        iYriiiirjr:...:iUY  
    5q: ...v:7Ls7v7uvU:        is7iriri77vvvvSr   
     :SYJ:::::. Iqr :7U.        .rLrrrrirrrsU     
       vq1vri.  Er   u75.         .::iirrJJ.      
         1JvJv.Ii  rBB:.i.    . .   ..r7i         
        LRbbPZbEKI .BR   s:....:ir7Lr:            
                  :......ir.....                 
"$RESET

echo -e $RED"Installation of $_package ....... Completed"$RESET
sleep 2
