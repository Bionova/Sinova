function [type,center]=myClusteringfun(datastand)
%% 聚类函数
%% kmeans
opts = statset('Display','final');
% distance1={'sqEuclidean','cityblock','cosine','correlation'};%参数: 'Distance'距离类型
distance1={'sqEuclidean','cityblock'};%参数: 'Distance'距离类型
%kset=[4,5,6,7];%分类数
kset=[10];%分类数
idx=cell(length(kset),size(distance1,2));%聚类指示矩阵
ctrs=cell(length(kset),size(distance1,2));%聚类中心
s=cell(length(kset),size(distance1,2));%轮廓系数
smean=zeros(length(kset),size(distance1,2));%平均系数
X=datastand';%一行一个样本
for i=1:length(kset)
    k=kset(i);
    for j=1:size(distance1,2)
        [idx{i,j},ctrs{i,j},sumds,D] = kmeans(X,k,'Distance',distance1{1,j},'Options',opts);%kmeans聚类
        s{i,j}=silhouette(X,idx{i,j});%轮廓系数
        smean(i,j)=mean(s{i,j});
    end
end

%绘图
smean(1,:)=0;
%figure;
plot(kset,mean(smean,2),'bo-');
xlabel('k');
ylabel('mean silhouette');
title('mean silhouette of k');

[v1,index1]=max(smean);%每列的最大值,这是行号
[v2,index2]=max(v1);%每列的最大值中的最大值
indexrow=index1(index2);%行号
indexcol=index2;%列号
type=idx{indexrow,indexcol};
center=ctrs{indexrow,indexcol};

