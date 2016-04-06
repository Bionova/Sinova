import os
import re

import sys
dir=sys.argv[1]
space=re.compile(" +")
sq=re.compile("\[\d+\]")
#pwd=os.getcwd()
#os.system("Rscript "+pwd+"/MST_location.R "+pwd)

f=open(dir+"/edges.txt")
#g=open(pwd+"/distence.txt")
#g=open("/Users/luohf/Desktop/bionova/singlecell/project/MST_PCA/test_MST/location3.tsv")
g=open(dir+"/location.tsv")
h=open(dir+"/start.txt")
start=h.read()
start=start.split("\"")
start=start[-2][1:]
#h=open(pwd+"/start.txt")
#name=open(pwd+"/filter-bionova.csv")
express=open(dir+"/raw_data.csv")
expression=express.read()
expression=expression.split('\r')

for i in range(len(expression)):
	expression[i]=expression[i].split(',')


edges=f.read()
location=g.readlines()
#matrix=location
#start=h.read()
#data=name.readlines()
#cellname=data[0][0:-2].split(",")
#start=int(start.split(" ")[-1][0:-1])

for i in range(len(location)):
	location[i]=location[i].split("\t")
	
hash_dis={}
for i in range(len(location)):
	hash_dis[location[i][0]]=[location[i][1],location[i][2],location[i][3]]
	
edges="".join(edges.split("\n")[3:])
edges=" ".join(sq.split(edges))


edges=edges.split("--")

relation=[]
temp=space.split(edges[0])
relation.append(temp[1])
for i in range(1,len(edges)-1):
	temp=space.split(edges[i])
	relation.append(temp[0])
	relation.append(temp[1])
temp=space.split(edges[len(edges)-1])
relation.append(temp[0])


hash={}
for i in range(0,len(relation)-1,2):
	if not hash.has_key(relation[i]):
		hash[relation[i]]=[]
	hash[relation[i]].append(relation[i+1])
	if not hash.has_key(relation[i+1]):
		hash[relation[i+1]]=[]
	hash[relation[i+1]].append(relation[i])	

#the expression of all genes
hash_exp={}
for i in range(len(expression[0])):
	hash_exp[expression[0][i]]=[]
for i in range(len(expression)):
	for j in range(len(expression[i])):
		hash_exp[expression[0][j]].append(expression[i][j])

	
#hash2={}
#for i in range(0,len(relation)-1,2):
#	if not hash2.has_key(relation[i+1]):
#		hash2[relation[i+1]]=[]
#	hash2[relation[i+1]].append(relation[i])
	
#for i in range(len(data[0])):
#	if not hash2.has_key(data[0][i][1:-1]):
#		start.append(data[0][i][1:-1])	
#start=start[-2]

#for (k,v) in hash.items():
#	if len(v)==1:
#		start.append(k)


#k=[]
#for i in range(len(start)):
#	tested=[]
#	l=0
#	temp=start[i]		
#	test=[]
#	test.append(temp)
#	while len(test)!=0:
#		temp=test[0]
#		tested.append(temp)
#		del(test[0])
#		if hash.has_key(temp):
#			for j in range(len(hash[temp])):
#				if not hash[temp][j] in tested:
#					test.append(hash[temp][j])
#		l+=1
#	k.append(l)
#g=open("/Users/luohf/Desktop/mst.tsv",'w')
g=open(dir+"/sort.csv",'w')
distence=0
pool=[]
test=[]
tested=[]
test.append(start)
 
hash_score={}
hash_score[start]=['NULL',0]
while len(test)!=0:
	start=test[0]
	tested.append(start)
	del(test[0])
	if hash.has_key(start):
		for j in range(len(hash[start])):
			if not hash[start][j] in tested:
				test.append(hash[start][j])
				d1=float(hash_dis[start][0])-float(hash_dis[hash[start][j]][0])
				d2=float(hash_dis[start][1])-float(hash_dis[hash[start][j]][1])
				d3=float(hash_dis[start][2])-float(hash_dis[hash[start][j]][2])
				distence+=(d1**2+d2**2+d3**2)**0.5
				hash_score[hash[start][j]]=[start,hash_score[start][1]+distence]

g.write("Cellname,distence")
for j in range(len(expression)):
	g.write(expression[j][0]+",")
g.write("\n")

for (k,v) in hash_score.items():
	g.write(k+','+"%s,"%v[1]+",".join(hash_exp[k][1:]))
	#loc=expression[0].index(k)
	#for j in range(1,len(expression)):
	#	g.write("\t"+expression[j][loc])
	g.write("\n")
					
g.close()

	


#f=open("/Users/luohf/Desktop/bionova/singlecell/Summary/Step2_MST/result/rank.csv",'w')
#f.write("Cell name,Rank,Distence\n")
#i=start
#k=1

#while hash.has_key(i):
#	j=hash[i]
#	distence=matrix[i][j]
#	f.write(cellname[i]+",%s,"%k+"%s\n"%distence)
#	i=j

#f.close()


