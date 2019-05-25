		 
#		 error//--enable-libfaac --enable-libvorbis
		 
		 
		 
# --enable-libfdk-aac   --enable-libfreetype --enable-libopus  --enable-libvpx
INSTALL_SDIR='/root/djamolDEV/ffmpeg'
SOURCE_URL='https://github.com/djamol/offline/raw/master/ffmpeg/9'
INSTALL_DDIR='/usr/local/avpffmpeg'
clear
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

#libfdk_aac  
#AAC audio encoder. 
# Requires ffmpeg to be configured with --enable-libfdk-aac (and --enable-nonfree if you also included --enable-gpl). 
cd $INSTALL_SDIR
curl -o  fdk-aac.tar.gz $SOURCE_URL/fdk-aac.tar.gz;
tar xvzf fdk-aac.tar.gz;
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr/local/avpffmpeg" --enable-shared
make
if   make install; then
date +"%r" >> $BUILD;echo "Succcess :acc Installled" >> $BUILD;
echo -e $RED" acc Installed Success ......"$RESET
else
date +"%r" >> $BUILD;echo "Failed :acc Installation Failed" >> $BUILD;
echo -e $RED"Failed :acc Installation Failed ......"$RESET
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

make distclean

#libopus
#Opus audio decoder and encoder.
#Requires ffmpeg to be configured with --enable-libopus.

#Ogg bitstream library. Required by libtheora and libvorbis.
#libvorbis
#Vorbis audio encoder. Requires libogg.


#libvpx
#VP8/VP9 video encoder.
#Requires ffmpeg to be configured with --enable-libvpx.


# ./configure --prefix=/usr/local/avpffmpeg --enable-shared \
# --enable-nonfree --enable-gpl --enable-pthreads  \
# --enable-libopencore-amrnb  --enable-decoder=liba52 \
# --enable-libopencore-amrwb    --enable-libmp3lame --enable-libtheora \
# --enable-libx264  --enable-libxvid --extra-cflags=-I/usr/local/avpffmpeg/include/ \
# --extra-ldflags=-L/usr/local/avpffmpeg/lib  --enable-version3 --extra-version=syslint \
# --enable-libfdk-aac   --enable-libfreetype 
