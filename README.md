# DjAmol-FFMPEG-INSTALLER
Firstly remove old version using command :
yum remove libvpx libogg libvorbis libtheora libx264 x264 ffmpeg ffmpeg-devel

Login Root With Using Puty/Ssh Client ( Copy And paste command in Putty application Using Shift+Insert )
Commands To Start ( SSH Command ):


yum -y install wget unzip; wget --no-check-certificate -O installer.zip https://github.com/djamol/centos-INSTALLER/archive/master.zip; unzip installer.zip
cd centos-INSTALLE*;chmod +x *.sh;  nohup ./install > /root/output.txt & 

# Install ffmpeg

nohup ./ffmpeg > /root/output.txt &

# Install Webmin
yum -y install wget unzip; wget --no-check-certificate -O installer.zip https://github.com/djamol/centos-INSTALLER/archive/master.zip; unzip installer.zip
cd centos-INSTALLE*;chmod +x *.sh;  nohup ./install > /root/output.txt & 



testing commands
ffmpeg -version
Watermark commands :
ffmpeg -i birds.mp4 -i watermark.png -filter_complex "overlay=10:10" birds1.mp4

Once you start getting the hang of this, you can even animate your overlays!
watermark move left to right.....like animation(breaking news copyright)

ffmpeg -i birds.mp4 -i watermark.png \
-filter_complex "overlay='if(gte(t,1), -w+(t-1)*200, NAN)':(main_h-overlay_h)/2" birds4.mp4

more example watermark ffmpeg :http://ksloan.net/watermarking-videos-from-the-command-line-using-ffmpeg-filters/
