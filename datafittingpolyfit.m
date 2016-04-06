function [fitdata,tlong,samplenumber,xfit,R2]=datafittingpolyfit(datay,datax)
%% ������Ϻ���
[tlong,samplenumber]=size(datay);
fitdata=[];
xfit=1:tlong;
xfit=xfit';
fitdata2=[];
for i=1:samplenumber
    y=datay(:,i);
    x=datax(:,i);
    P=polyfit(x,y,2);%����ʽ��ϣ����ؽ������еĶ���ʽϵ��
    yout=polyval(P,xfit);%�������ʽ��ֵ
    fitdata=[fitdata,yout];%���е���ʽ����
    yout=polyval(P,x);%�������ʽ��ֵ
    fitdata2=[fitdata2,yout];%���е���ʽ����
end

% for i=2:samplenumber
%     H1= (fitdata(i-1,:)-fitdata(i,:))~=0;
%     sum(H1)
% end
%% ����R2
R2=zeros(1,samplenumber);
for i=1:samplenumber
    
    y=datay(:,i);
    y1=fitdata2(:,i);
    R2(i)=1-sum((y-y1).^2)/sum((y-mean(y)).^2);
    
end