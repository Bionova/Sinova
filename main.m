clc;close all; clear all;%�������
data=csvread('sort.csv',1,1);
data=sortrows(data,1);
data(:,1)=data(:,1)/data(end,1)*204;
fid=fopen('sort.csv');
Colname=fscanf(fid,'%s',[1,1]);
Colname=Colname(1:length(Colname));
genenames=regexp(Colname,',','split');
gennames=genenames(1,3:end-1);
fclose(fid)


%% (1)�������
[fitdata,tlong,samplenumber,xfit,R2]=datafitting(data);
datay=data(:,2:end);%����
t=data(:,1);%ʱ��
[tlong,samplenumber]=size(datay);

datax=t*ones(1,samplenumber);
datax;

datay=smoothdata(datay);% ����ƽ������

[fitdata,tlong,samplenumber,xfit,R2]=datafittingpolyfit(datay,datax);
R2cv=0.35;%R2���ٽ�ֵ

H1= R2>R2cv;
selectednumber=sum(H1);%ѡ�����������
selectedfitdata=fitdata(:,H1);%ѡ����������������
R2selected=R2(H1);%ѡ���R2
selectedgennames=gennames(H1);%ѡ��Ļ�������

datastand=standardizeddata(selectedfitdata);% ��ѡ����������ݽ��й�һ������[0,1] ����
datastand;
%% (2)���߾���
[type,center]=myClusteringfun(datastand);
center;%һ����һ����������
%% ���Ʒ���ͼ
type1=type(1:end);%ȡǰ30������
datastand1=datastand(:,1:end);
set1=unique(type);
long1=length(set1);
% ���������x����
t2=1:tlong;
t2=t2';

for i=1:long1
    H1= type1==set1(i);
    Z=[];
    if sum(H1)>0
        data001=datastand1(:,H1);
        long2=size(data001,2);
        for j=1:long2
            z=abs(center(set1(i),:)'-data001(:,j));
            Z=[Z;z];
        end
    end
    [~,inputps{i,1}]=mapminmax(Z',0,1);
end


for i=1:long1
    H1= type1==set1(i);
    if sum(H1)>0
        data001=datastand1(:,H1);
        long2=size(data001,2);
        figure;
        outdata=[t2];
        for j=1:long2
            s = 10;
            %             c = linspace(s,s,length(t2));
            z=abs(center(set1(i),:)'-data001(:,j));
            z = mapminmax('apply',z',inputps{i,1});
            s=10;
            c=z';
            c1=[c,c,c];
            scatter(t2,data001(:,j),s,c1,'fill');%����ɢ��
            hold on;
            outdata=[outdata,data001(:,j)];
        end
        % ���ƾ�������
        
        plot(t2,center(set1(i),:),'r*-','LineWidth',5);
        set(gca,'YLim',[-1 2]);% Y���������ʾ��Χ
        tt1=['����',num2str(set1(i)),'�ľ���ͼ'];
        title(tt1);
        tt2=['����',num2str(set1(i)),'������.csv'];
                csvwrite(tt2,outdata);
    end
end

%% ���������
for i=1:long1
    H1= type1==set1(i);
    disp(['��',num2str(set1(i)),'������Ļ�����:']);
    names1=gennames(H1)
end
%% ���Excel���
outcell={'����','���'};
outcell=[outcell;
    selectedgennames',num2cell(type)];
xlswrite('�����Ӧ�ľ�����.xls',outcell);




