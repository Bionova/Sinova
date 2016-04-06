function Sincell_PCA(input_file)
fid=fopen(input_file)
Colname=fscanf(fid,'%s',[1,1]);
Colname=Colname(2:length(Colname));
celltype=regexp(Colname,',','split');
data=csvread(input_file,1,1);
fclose(fid)

[pc,score,latent,tsquare]=princomp(data);
col=kmeans(data',3);

%draw the 3D scatter and load cell type config file
pca=scatter3(pc(:,1),pc(:,2),pc(:,3),50,col,'filled');
setappdata(pca,'sourceFile_whatever', celltype)  
dcm = datacursormode(gcf);
datacursormode on;
set(dcm, 'updatefcn', @myfunction)
axis([0.02 0.08 -0.1 0.3 -0.2 0.2])
h = colorbar;
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
distence=pc(:,1:3);
[r,c]=size(distence);
fid=fopen('PCA_result.tsv','w');
for i=1:r
fprintf(fid,char(celltype(i)));
fprintf(fid,'\t');
for j=1:c
fprintf(fid,'%5f\t',distence(i,j));
if rem(j,c)==0
fprintf(fid,'\r\n');
end
end
end
fclose(fid);
