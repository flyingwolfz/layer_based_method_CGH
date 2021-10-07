clc;
clear;
p=im2double(rgb2gray(imread('long.png')));
depth=im2double((imread('longdep.png')));
shuang=0;%1:double phase hologram; 0: phase only hologram
fencengshu=20;%number of layers

maxdepth=max(max(depth));
mindepth=min(depth(depth~=0));
d=(maxdepth-mindepth)/fencengshu;

lambda=639*10^(-6);
pitch=8*10^(-3);
a=-960:959;
b=-540:539;
[u,v]=meshgrid(a*pitch,b*pitch);

B = rand([1080 1920]);
quan2=zeros(1080,1920);
part=zeros(1080,1920);

if (shuang==1)

for n=1:fencengshu
    part=p.*((depth>=(maxdepth-n*d))&(depth<(maxdepth-(n-1)*d)));
    f=300+n*0.03;
    part=part.*exp(1i*2*pi*f);
    holo=ASM('cut','forward','limit',part,2,f,pitch,lambda);
    quan2=quan2+holo;
    n
end

ang=angle(quan2);
amp=abs(quan2);
amp=amp./max(max(amp));
coss=acos(amp);
quana=ang+coss;
quanb=ang-coss;

qipan=zeros(1024,1024);
for i=1:1080
    for j=1:1920 
       if(mod(i+j,2)==0)
           qipan(i,j)=1;
       end
    end
end
qipan2=1-qipan;

quan2=quana.*qipan+quanb.*qipan2;
quan2=mod(quan2,2*pi);
ang=quan2/2/pi;
imshow(ang);
imwrite(ang,'1.png')
end 

if (shuang==0)
    p=p.*exp(1i*2*pi*B);
for n=1:fencengshu
    part=p.*((depth>=(maxdepth-n*d))&(depth<(maxdepth-(n-1)*d)));
    f=300+n*0.03;
    holo=ASM('cut','forward','limit',part,2,f,pitch,lambda);
    quan2=quan2+holo;
    n
end

quan2=angle(quan2);
quan2=mod(quan2,2*pi);
ang=quan2/2/pi;
imshow(ang);
imwrite(ang,'1.png')
end


