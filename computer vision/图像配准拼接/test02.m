
im1=imread('a.jpg');
im2=imread('b.jpg');

gray1=zoo_x2gray(im1);
gray2=zoo_x2gray(im2);
[des1,loc1]=zoo_sift(gray1);
[des2,loc2]=zoo_sift(gray2);
figure;zoo_drawPoints(im1,loc1,im2,loc2);
Num=3;Thresh=0.85;
match=zoo_BidirectionalMatch(des1,des2,Num,Thresh);
clear des1 des2
loc1=loc1(match(:,1),:);
loc2=loc2(match(:,2),:);
 
figure;zoo_linePoints(im1,loc1,im2,loc2);
 
agl=zoo_getRotAgl(loc1,loc2);
 
figure;zoo_drawRotAglHist(agl);
 
opt=zoo_optIndex(agl);
loc1=loc1(opt,:);
loc2=loc2(opt,:);
 
figure;zoo_linePoints(im1,loc1,im2,loc2);
 
T=zoo_getTransMat(gray1,loc1,gray2,loc2);
im=zoo_imRegist(im1,im2,T);
 
figure,imshow(im);

function gray=zoo_x2gray(im)
if length(size(im))==3
    gray=rgb2gray(im);
else
    gray=im;
end
gray=uint8(medfilt2(double(gray)));
end

function [des,loc]=zoo_sift(im)
[row,col]=size(im);
f=fopen('tmp.pgm','w');
if f==-1
    error('Could not create file tmp.pgm.');
end
fprintf(f, 'P5\n%d\n%d\n255\n', col, row);
fwrite(f,im','uint8');
fclose(f);
 if isunix
    command = '!./sift ';
else
    command = '!siftWin32 ';
end
command = [command ' <tmp.pgm >tmp.key'];
eval(command);
 g=fopen('tmp.key','r');
if g==-1
    error('Could not open file tmp.key.');
end
[header,cnt]=fscanf(g,'%d %d',[1 2]);
if cnt~=2
    error('Invalid keypoint file beginning.');
end
num=header(1);
len=header(2);
if len~=128
    error('Keypoint descriptor length invalid (should be 128).');
end
 loc=double(zeros(num,4));
des=double(zeros(num,128));
for k=1:num
    [vector,cnt]=fscanf(g, '%f %f %f %f', [14]);
    if cnt~=4
        error('Invalid keypoint file format');
    end
    loc(k,:)=vector(1,:);
     [descrip, count] = fscanf(g, '%d', [1 len]);
    if (count ~= 128)
        error('Invalid keypoint file value.');
    end
    descrip = descrip / sqrt(sum(descrip.^2));
    des(k, :) = descrip(1, :);
end
fclose(g);
for k=1:size(des,1)
    des(k,:)=des(k,:)/sum(des(k,:));
end
delete tmp.key tmp.pgm
end
function zoo_drawPoints(im1,loc1,im2,loc2)
im=zoo_appendingImages(im1,im2);
imshow(im);
hold on
set(gcf,'Color','w');
plot(loc1(:,2),loc1(:,1),'r*',loc2(:,2)+size(im1,2),loc2(:,1),'b*');
hold off
end

function match=zoo_BidirectionalMatch(des1,des2,Num,Thresh)
X=sum(des1.^2,2);
Y=sum(des2.^2,2);
XY=des1*des2';zoo_BidirectionalMatch
corr=XY./sqrt(X*Y');
 
[corr1,ix1]=sort(corr,2,'descend');
corr1=corr1(:,1:Num);
ix1=ix1(:,1:Num);
[row1,col1]=find(corr1>Thresh);
match12=zeros(length(row1),2);
match12(:,1)=row1;
match12(:,2)=ix1(size(corr1,1)*(col1-1)+row1);
clear corr1 ix1 row1 col1
 
[corr2,ix2]=sort(corr,1,'descend');
corr2=corr2(1:Num,:);
ix2=ix2(1:Num,:);
[row2,col2]=find(corr2>Thresh);
match21=zeros(length(col2),2);
match21(:,1)=ix2(Num*(col2-1)+row2);
match21(:,2)=col2;
clear corr2 ix2 row2 col2
 
m1=match12(:,1)*10000+match12(:,2);
m2=match21(:,1)*10000+match21(:,2);
 
clear match12
 
match=[];
for k=1:length(m1)
    re=m1(k)-m2;
    idx=find(re==0);
    if ~isempty(idx)
        match=[match;match21(idx,:)];
    end
end
end

function zoo_linePoints(im1,loc1,im2,loc2)
im=zoo_appendingImages(im1,im2);
imshow(im);
hold on
set(gcf,'Color','w');
plot(loc1(:,2),loc1(:,1),'r*',loc2(:,2)+size(im1,2),loc2(:,1),'b*');
for k=1:size(loc1,1)
    text(loc1(k,2)-10,loc1(k,1),num2str(k),'Color','y','FontSize',12);
   text(loc2(k,2)+size(im1,2)+5,loc2(k,1),num2str(k),'Color','y','FontSize',12);
    line([loc1(k,2) loc2(k,2)+size(im1,2)],...
           [loc1(k,1) loc2(k,1)],'Color','g');
end
hold off
end

function agl=zoo_getRotAgl(loc1,loc2)
ori1=loc1(:,4);
ori2=loc2(:,4);
agl=ori2-ori1;
agl=agl*180/pi;
end

function zoo_drawRotAglHist(agl)
agl=agl(agl>-180);
agl=agl(agl<180);
hist(agl,180);
hold on
set(gcf,'Color','w');
xlabel('Rotated Angle(¡ã)');
ylabel('Number of Feature Point');
hold off
end

function T=zoo_getTransMat(gray1,loc1,gray2,loc2)
gray1=double(gray1);
gray2=double(gray2);
N=size(loc1,1);
iter=N*(N-1)*(N-2)/6;
SEL=zeros(iter,3);
count=1;
for i=1:N-2
    for j=2:N-1
        for k=3:N
            if i<j && j<k
                SEL(count,:)=[i j k];
                count=count+1;
            end
        end
    end
end
T=[];
corr1=-1;
for k=1:iter
    sel=SEL(k,:);
    x1=loc1(sel,2);
    y1=loc1(sel,1);
    x2=loc2(sel,2);
    y2=loc2(sel,1);
    xy1=[x1';y1';ones(1,3)];
    xy2=[x2';y2';ones(1,3)];
    t=xy1/xy2;
     grayset=getMask(gray1,gray2,t);
    if isempty(grayset)
        continue
    end
    d1=grayset(1,:);
    d2=grayset(2,:);
    corr2=(d1*d2')/sqrt((d1*d1')*(d2*d2'));
    if corr2>corr1
        corr1=corr2;
        T=t;
    end
end
end
function grayset=getMask(im1,im2,T)
[row1,col1]=size(im1);
[row2,col2]=size(im2);
T=T^(-1);
grayset=[];
for i=1:row1
    for j=1:col1
        xy1=[j;i;1];
        xy2=round(T*xy1);
        if xy2(1)>=1 && xy2(1)<=col2&& xy2(2)>=1 && xy2(2)<=row2
           grayset=[grayset,[im1(i,j);im2(xy2(2),xy2(1))]];
        end
    end
end
end

function im=zoo_imRegist(im1,im2,T)
sz=3*max(length(im1),length(im2));
dim=length(size(im1));
if dim==3
    [row1,col1,~]=size(im1);
    [row2,col2,~]=size(im2);
    im=zeros(sz,sz,3);
else
    [row1,col1]=size(im1);
    [row2,col2]=size(im2);
    im=zeros(sz,sz);
end
 
cX=sz/3;
cY=sz/3;
if dim==3
    im(1+cY:row1+cY,1+cX:col1+cX,:)=im1;
else
    im(1+cY:row1+cY,1+cX:col1+cX)=im1;
end
T=T^(-1);
for i=1:size(im,1)
    for j=1:size(im,2)
        xy1=[j-cX;i-cY;1];
        xy2=round(T*xy1);
        nx=xy2(1);
        ny=xy2(2);
        if nx>=1&& nx<=col2 && ny>=1 && ny<=row2
           if i<=cY || i>=cY+row1 || j<=cX ||j>=cX+col1
               if dim==3
                   im(i,j,:)=im2(ny,nx,:);
               else
                   im(i,j)=im2(ny,nx);
               end
           end
        end
    end
end
 
im=imCrop(im);
im=uint8(im);
end
function im=imCrop(pic)
if length(size(pic))==3
    gray=rgb2gray(pic);
else
    gray=pic;
end
SZ=length(gray);
k=1;
while k<SZ
    if any(any(gray(k,:)))
        break
    end
    k=k+1;
end
ceil=k;
 
k=SZ;
while k>0
    if any(any(gray(k,:)))
        break
    end
    k=k-1;
end
bottom=k;
 
k=1;
while k<SZ
    if any(any(gray(:,k)))
        break
    end
    k=k+1;
end
left=k;
 
k=SZ;
while k>0
    if any(any(gray(:,k)))
        break
    end
    k=k-1;
end
right=k;
 
if length(size(pic))==3
    im=pic(ceil:bottom,left:right,:);
else
    im=pic(ceil:bottom,left:right);
end
end

function im=zoo_appendingImages(im1,im2)
if length(size(im1))==3
    [row1,col1,~]=size(im1);
    [row2,col2,~]=size(im2);
    if row1<=row2
        im1=[im1;zeros(row2-row1,col1,3)];
    else
        im2=[im2;zeros(row1-row2,col2,3)];
    end
else
    [row1,col1]=size(im1);
    [row2,col2]=size(im2);
    if row1<=row2
        im1=[im1;zeros(row2-row1,col1)];
    else
        im2=[im2;zeros(row1-row2,col2)];
    end
end
im=[im1,im2];
end

function opt=zoo_optIndex(agl)
[n,xout]=hist(agl,180);
alpha=0.75;
[~,IX]=find(n>alpha*max(n));
n=n(IX);
xout=xout(IX);
theta=sum(xout.*n)/sum(n);
rg=[theta-1,theta+1];
opt=[];
for k=1:length(agl)
    if agl(k)>=rg(1) && agl(k)<=rg(2)
        opt=[opt,k];
    end
    if length(opt)>=16
        break
    end
end
end