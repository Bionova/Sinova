clc;close all; clear all;%清除变量
data=csvread('sort.csv',1,1);
data=sortrows(data,1);
data(:,1)=data(:,1)/data(end,1)*204;
fid=fopen('sort.csv');
Colname=fscanf(fid,'%s',[1,1]);
Colname=Colname(1:length(Colname));
genenames=regexp(Colname,',','split');
gennames=genenames(1,3:end-1);
fclose(fid)


%% (1)数据拟合
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
datastand;
%% (2)曲线聚类
[type,center]=myClusteringfun(datastand);
center;%一行是一个聚类中心
%% 绘制分类图
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
        set(gca,'YLim',[-1 2]);% Y轴的数据显示范围
        tt1=['类型',num2str(set1(i)),'的聚类图'];
        title(tt1);
        tt2=['类型',num2str(set1(i)),'的数据.csv'];
                csvwrite(tt2,outdata);
    end
end

%% 输出基因名
for i=1:long1
    H1= type1==set1(i);
    disp(['第',num2str(set1(i)),'类包括的基因是:']);
    names1=gennames(H1)
end
%% 输出Excel结果
outcell={'基因','类别'};
outcell=[outcell;
    selectedgennames',num2cell(type)];
xlswrite('基因对应的聚类结果.xls',outcell);




