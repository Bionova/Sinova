function [type,center]=myClusteringfun(datastand)
%% ���ຯ��
%% kmeans
opts = statset('Display','final');
% distance1={'sqEuclidean','cityblock','cosine','correlation'};%����: 'Distance'��������
distance1={'sqEuclidean','cityblock'};%����: 'Distance'��������
%kset=[4,5,6,7];%������
kset=[10];%������
idx=cell(length(kset),size(distance1,2));%����ָʾ����
ctrs=cell(length(kset),size(distance1,2));%��������
s=cell(length(kset),size(distance1,2));%����ϵ��
smean=zeros(length(kset),size(distance1,2));%ƽ��ϵ��
X=datastand';%һ��һ������
for i=1:length(kset)
    k=kset(i);
    for j=1:size(distance1,2)
        [idx{i,j},ctrs{i,j},sumds,D] = kmeans(X,k,'Distance',distance1{1,j},'Options',opts);%kmeans����
        s{i,j}=silhouette(X,idx{i,j});%����ϵ��
        smean(i,j)=mean(s{i,j});
    end
end

%��ͼ
smean(1,:)=0;
%figure;
plot(kset,mean(smean,2),'bo-');
xlabel('k');
ylabel('mean silhouette');
title('mean silhouette of k');

[v1,index1]=max(smean);%ÿ�е����ֵ,�����к�
[v2,index2]=max(v1);%ÿ�е����ֵ�е����ֵ
indexrow=index1(index2);%�к�
indexcol=index2;%�к�
type=idx{indexrow,indexcol};
center=ctrs{indexrow,indexcol};

