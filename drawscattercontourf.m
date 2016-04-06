function [X,Y,Z]=drawscattercontourf(x,y,z,title1,flag)
%% 绘制散点图的等高线图
[X,Y,Z]=griddata(x,y,z,linspace(min(x),max(x))',linspace(min(y),max(y)),'v4');%插值
if flag==1
else
    figure;
end
contourf(X,Y,Z);%等高线图
title(title1);

