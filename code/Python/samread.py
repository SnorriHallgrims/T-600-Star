import os.path
import csv

def samread(sp1,sp2):
    filepath=os.path.join(os.path.dirname(__file__),'../../../T-600-Star data/ru_snorri/My friend SAM/1.00/sp'+sp1+'_'+sp2+'.sam')
    outfile=os.path.join(os.path.dirname(__file__),'../../../T-600-Star data/ru_snorri/My friend SAM/1.00/sp'+sp1+'_'+sp2+'_sum.tsv')

    f=open(filepath,'r')
    w=open(outfile,'w',newline='')
    reader=csv.reader(f,delimiter='	')
    writer=csv.writer(w,delimiter=' ')

    writer.writerow(['Name','S','H','D','I','M','NM','len','MQual'])

    mism_set=set()
    mism=0
    match=0
    totMQ=0

    for r in reader:
        if not r[0][0] == '@':
            if not r[0]==r[2]:
                mism+=1
                mism_set.add(r[0])

            else:
                match+=1
                totMQ+=int(r[4])
                S=0
                H=0
                D=0
                I=0
                M=0
                intstr=''

                for s in r[5]:
                    if (s=='S' and not (s=='')):
                        S+=int(intstr)
                        intstr=''
                    elif (s=='H' and not (s=='')):
                        H+=int(intstr)
                        intstr=''
                    elif (s=='D' and not (s=='')):
                        D+=int(intstr)
                        intstr=''
                    elif (s=='I' and not (s=='')):
                        I+=int(intstr)
                        intstr=''
                    elif (s=='M' and not (s=='')):
                        M+=int(intstr)
                        intstr=''
                    else:
                        intstr+=s
                
                writer.writerow([r[0],S,H,D,I,M,r[11][5:len(r[11])],len(r[9]),r[4]])
    f.close()
    w.close()

    #return([match/(mism+match), totMQ/(mism+match)],mism_set)
    return(mism_set)

sp=['0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00']
the_set=set()

for s in sp:
    inf=samread(s,'1.00')
    the_set.update(inf)

o=open('mism.txt','w',newline='')
for i in the_set:
    o.write(i+'\n')
o.close()