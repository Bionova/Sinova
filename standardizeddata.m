function datastand=standardizeddata(selectedfitdata)
%% ��׼�����ݺ���
[K1,K2]=size(selectedfitdata);
datastand=zeros(K1,K2);

for i=1:K2
    
    P1=selectedfitdata(:,i)';
    [inputn,inputps]=mapminmax(P1,0,1);%���ݹ�һ��
    datastand(:,i)=inputn;
    
end