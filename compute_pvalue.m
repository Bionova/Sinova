%read the data
clc;close all; clear all;%清除变量
data=csvread('sort.csv',1,1);
data=sortrows(data,1);
data(:,1)=data(:,1)/data(end,1)*201;
fid=fopen('sort.csv');
Colname=fscanf(fid,'%s',[1,1]);
Colname=Colname(1:length(Colname));
genenames=regexp(Colname,',','split');
gennames=genenames(1,3:end-1);
fclose(fid)

%计算聚类中心
[fitdata,tlong,samplenumber,xfit,R2]=datafitting(data);
datay=data(:,2:end);%数据
t=data(:,1);%时间
[tlong,samplenumber]=size(datay);

datax=t*ones(1,samplenumber);
datax;

datay=smoothdata(datay);% 数据平滑处理

[fitdata,tlong,samplenumber,xfit,R2]=datafittingpolyfit(datay,datax);
R2cv=0.35;%R2的临界值

H1= R2>R2cv;
selectednumber=sum(H1);%选择的样本数量
selectedfitdata=fitdata(:,H1);%选择的样本的拟合数据
R2selected=R2(H1);%选择的R2
selectedgennames=gennames(H1);%选择的基因名称

datastand=standardizeddata(selectedfitdata);% 对选择的曲线数据进行归一化处理到[0,1] 区间
%datastandtemp=standardizeddata(fitdata);
datastand;
%% (2)曲线聚类
[type,center]=myClusteringfun(datastand);

type1=type(1:end);%取前30个来看
datastand1=datastand(:,1:end);
set1=unique(type);
long1=length(set1);
% 定义输出的x坐标
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
            scatter(t2,data001(:,j),s,c1,'fill');%绘制散点
            hold on;
            outdata=[outdata,data001(:,j)];
        end
        % 绘制聚类中心
        
        plot(t2,center(set1(i),:),'r*-','LineWidth',5);
        set(gca,'YLim',[-1 2]);% Y轴的数据显示	范围
        tt1=['类型',num2str(set1(i)),'的聚类图'];
        title(tt1);
        tt2=['类型',num2str(set1(i)),'的数据.csv'];
                csvwrite(tt2,outdata);
    end
end


%data_norm=zscore(data(:,2:end));

%compute the pvalue
%list=[2307,8293,6261,6870,9243,9392];

k_number=size(center);
%center_norm=zscore(center);

for (j=1:k_number(1))

marker=center(j,:);


filename=strcat('group_',int2str(j),'.csv');

result=zeros(1,9739);
corr=zeros(1,9739);
for (i=1:9739)
target=data(:,i);
[r,p]=corrcoef(target,marker);
%temp=2*(center_norm(j,:))'+data_norm(:,i);
%AB=length(find(temp==3));
%NN=length(find(temp==0));
%AN=length(find(temp==2));
%NB=length(find(temp==0));

%totBpres=AB+NB;
%totBabs=NN+AN;
%totApres=AB+AN;
%totAabs=NN+NB;
%tot=totApres+totAabs;

result(i)=p(2);
corr(i)=r(2);
if (corr(i)<0)
result(i)=1;
end
end

fid=fopen(char(filename),'w')
fprintf(fid,'genename,correlation coefficient,pvalue\r\n');
for (i=2:length(result))
fprintf(fid,char(gennames(i-1)));
fprintf(fid,',%e,',corr(i));
fprintf(fid,'%e\r\n',result(i));
end
end
