#Args <- commandArgs(TRUE)

library('ConsensusClusterPlus')

argv <- commandArgs(TRUE)
work_dir=argv[1]
work_dir

#set the working dir

setwd(work_dir)


marker='Col10a1'

data=read.table("PCA_result.tsv",sep='\t',header=F,row.names=1);
#data=t(data[,1:3])
#distence=1-cor(data)
distence=dist(data[,1:3],upper=T,diag=T)

require(igraph)
g <- graph.adjacency(as.matrix(distence), weighted=T, mode = 'undirected')
g <- simplify(g)

#extract the MST
mst <- minimum.spanning.tree(g)

#get handtune structure 
tkid<-tkplot(mst)

layid<-tkplot.getcoords(tkid)

gene_expression=read.csv('raw_data.csv',header=T,row.names=1);
genes=rownames(gene_expression)
cells=colnames(gene_expression)

k=0
for(i in 1:length(genes))
if (genes[i]==marker)
k=i

gene_expression=gene_expression[k,]

require(plotrix)
gene_expression=t(gene_expression)
mypalette <- color.scale(gene_expression,c(0,1,1),c(1,1,0),0,color.spec="rgb")
plot(mst, vertex.size=5,layout =layid,vertex.color=mypalette,vertex.label=NA,edge.width=3)
col.labels<-c("Low","Medium","High")
testcol<-color.gradient(c(0,1,1),c(1,1,0),0,nslices=100)
color.legend(-1.4,0.5,-1.3,1.3,rect.col=testcol,legend=col.labels,gradient="y")
#dev.off()
#calculating the longest path
#diameter(g)

#calculating the longes path and giving back the corresponding node IDs
#farthest.nodes(g)

st=cells[farthest.nodes(g)[1]]

#write.table(distence,'distence.txt')
write.table(st,'start.txt')

sink('edges.txt')
str(mst)
sink()

