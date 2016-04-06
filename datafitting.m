function [fitdata,tlong,samplenumber,xfit,R2]=datafitting(data)
%% 数据拟合函数
[tlong,samplenumber]=size(data);
fitdata=[];
x=1:tlong;

for i=1:samplenumber
    y=data(:,i);
    pp = csaps(x,y,0.1);
    points = fnplt(pp);%根据函数产生数据点坐标,第一行是x,第二行是y
    temp1=points(1,:);
    temp2=points(2,:);
    yout=zeros(tlong,1);%%以列的形式保存
    for j=1:tlong
        H1=temp1==j;
        if sum(H1)~=0
            y1=temp2(H1);
            yout(j)=y1(1);
        else
            % 找最接近的x值对应的y值
            temp3=abs(temp1-j);
            [v1,index1]=min(temp3);
            yout(j)=temp2(index1);
        end
    end
    
    fitdata=[fitdata,yout];%以列的形式保存
end
xfit=1:tlong;
% for i=2:samplenumber
%     H1= (fitdata(i-1,:)-fitdata(i,:))~=0;
%     sum(H1)
% end
%% 计算R2
R2=zeros(1,samplenumber);
for i=1:samplenumber
    y=data(:,i);
    y1=fitdata(:,i);
    R2(i)=1-sum((y-y1).^2)/sum((y-mean(y)).^2);
    
end

