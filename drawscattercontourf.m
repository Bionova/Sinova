function [X,Y,Z]=drawscattercontourf(x,y,z,title1,flag)
%% ����ɢ��ͼ�ĵȸ���ͼ
[X,Y,Z]=griddata(x,y,z,linspace(min(x),max(x))',linspace(min(y),max(y)),'v4');%��ֵ
if flag==1
else
    figure;
end
contourf(X,Y,Z);%�ȸ���ͼ
title(title1);

