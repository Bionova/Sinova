function [fitdata,tlong,samplenumber,xfit,R2]=datafittingpolyfit(datay,datax)
%% 数据拟合函数
[tlong,samplenumber]=size(datay);
fitdata=[];
xfit=1:tlong;
xfit=xfit';
fitdata2=[];
for i=1:samplenumber
    y=datay(:,i);
    x=datax(:,i);
    P=polyfit(x,y,2);%多项式拟合，返回降幂排列的多项式系数
    yout=polyval(P,xfit);%计算多项式的值
    fitdata=[fitdata,yout];%以列的形式保存
    yout=polyval(P,x);%计算多项式的值
    fitdata2=[fitdata2,yout];%以列的形式保存
end

% for i=2:samplenumber
%     H1= (fitdata(i-1,:)-fitdata(i,:))~=0;
%     sum(H1)
% end
%% 计算R2
R2=zeros(1,samplenumber);
for i=1:samplenumber
    
    y=datay(:,i);
    y1=fitdata2(:,i);
    R2(i)=1-sum((y-y1).^2)/sum((y-mean(y)).^2);
    
end