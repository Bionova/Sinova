function data=smoothdata(data)
%% ����ƽ������
long1=size(data,2);
M=2;%ƽ������
for k=1:M
    for i=1:long1
        data(:,i) = smooth(data(:,i));
    end
end
