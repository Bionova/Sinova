function data=smoothdata(data)
%% 数据平滑处理
long1=size(data,2);
M=2;%平滑次数
for k=1:M
    for i=1:long1
        data(:,i) = smooth(data(:,i));
    end
end
