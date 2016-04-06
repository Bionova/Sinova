function [X,Y,Z]=datamake(xt,data001,center)
%% 处理数据为可绘图数据
% 分成50份
n=50;
long1=size(data001,2);%样本数
minx=min(xt);
maxx=max(xt);
dx=(maxx-minx)/n;

miny=min(min(data001));
maxy=max(max(data001));

dy=(maxy-miny)/n;

xv=minx:dx:maxx;
xv=xv';
yv=miny:dy:maxy;
% [X,Y] = meshgrid(xv, yv);
x1=xt;
Z=0;
long2=size(data001,1);
x=[];
y=[];
z=[];
for i=1:long1
    y1=data001(:,i);
    d=abs(center-y1');%距离
    %     [d,inputps]=mapminmax(d,1,2);
    z1=1./d;
    x=[x;x1'];
    y=[y;y1];
    z=[z;z1'];
%     z=y;
    %     vq=griddata(x,y,v,X,Y,'v4');
    
    % 处理影响
%     for k=1:long2
%         x01=xt(k);
%         d1= abs(X-x01);
%         [v1,index1]=min(d1);
%         [v2,index2]=min(v1);
%         xid=index1(index2)
%         yid=index2
%         Zc(xid,:)=0;
%         Zc(xid,yid)=1;
%     end
        
%     Z=Z+Zc;
end
% Z=Z/max(max(Z));
[X,Y,Z]=griddata(x,y,z,linspace(minx,maxx,n)',linspace(miny,maxy,n),'v4');%插值
