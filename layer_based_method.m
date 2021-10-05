clc;
clear;
p=im2double(rgb2gray(imread('long.png')));
depth=im2double((imread('longdep.png')));

maxdepth=max(max(depth));
mindepth=min(depth(depth~=0));
fencengshu=9;
d=(maxdepth-mindepth)/fencengshu;

lambda=639*10^(-6);
pitch=8*10^(-3);
a=-960:959;
b=-540:539;
[u,v]=meshgrid(a*pitch,b*pitch);

B = rand([1080 1920]);
quan2=zeros(1080,1920);
part=zeros(1080,1920);

figure(1)
for n=1:fencengshu
    part=p.*((depth>=(maxdepth-n*d))&(depth<(maxdepth-(n-1)*d)));
    subplot(3,3,n)
    imshow(part);
    part=part.*exp(1i*2*pi*B);
    f=300+n*5;

    holo=ASM('cut','forward','limit',part,1,f,pitch,lambda);
    quan2=quan2+holo;
    n
end

quan2=angle(quan2);
quan2=mod(quan2,2*pi);
ang=quan2/2/pi;
figure(2)
imshow(ang);
imwrite(ang,'1.png')



