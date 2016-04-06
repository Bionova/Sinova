function datastand=standardizeddata(selectedfitdata)
%% 标准化数据函数
[K1,K2]=size(selectedfitdata);
datastand=zeros(K1,K2);

for i=1:K2
    
    P1=selectedfitdata(:,i)';
    [inputn,inputps]=mapminmax(P1,0,1);%数据归一化
    datastand(:,i)=inputn;
    
end