import readfasta
import os.path
import csv


def qualstrread(filepath,qualstrdict,i,ii):
    sp=['0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00']
    f=open(filepath,'r')
    reader=csv.reader(f,delimiter='	')
    for r in reader:
        if (r[0] not in qualstrdict.keys()):
            if (not (r[0][0]=='@')): 
                qualstrdict[r[0]]={(sp[i]+'_'+sp[ii]):r[5]}

        else:
            if (not (r[0][0]=='@')):
                qualstrdict[r[0]][(sp[i]+'_'+sp[ii])]=r[5]
    f.close()
    return qualstrdict

def comp(ctrlstr,fstr,lstr):
    l=''
    outstr=''
    ind1=0
    dcount=0
    icount=0
    for c in ctrlstr:
        if (c.isdigit()): 
            l+=c
        else:
            ind2=ind1+int(l)
            if (c=='M'):
                outstr+=fstr[(ind1):(ind2)]
                l=''
            elif (c=='D'):
                outstr+='('+fstr[(ind1):(ind2)]+')'
                dcount+=int(l)
                l=''
            elif (c=='I'):
                outstr+='['+lstr[(ind1-dcount+icount):(ind2-dcount+icount)]+']'
                icount+=int(l)
                l=''
            elif (c=='S'):
                outstr+='{'+lstr[(ind1-dcount+icount):(ind2-dcount+icount)]+'}'
                icount+=int(l)
                l=''
            ind1=ind2
    return outstr



qualstrdict={}
sp=['0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00']

for i in range(0,8):
    filepath=os.path.join(os.path.dirname(__file__),'../../../T-600-Star data/ru_snorri/My friend SAM/sp'+sp[i]+'_'+sp[i+1]+'.sam')
    qualstrdict=qualstrread(filepath,qualstrdict,i,i+1)



filepath=os.path.join(os.path.dirname(__file__),'../../../T-600-Star data/ru_snorri/My friend SAM/sp0.05ref1.00.sam')
qualstrdict=qualstrread(filepath,qualstrdict,0,4)

filepath=os.path.join(os.path.dirname(__file__),'../../../T-600-Star data/ru_snorri/My friend SAM/sp1.00ref2.00.sam')
qualstrdict=qualstrread(filepath,qualstrdict,4,8)
#num='18d13ed9-c1d1-404a-bdc8-c275c7f152e0'
num='bd9ad8d2-d1b5-4e15-9083-2e3b9540a8ac'

basestrdict=readfasta.fread()

ctrlstr=qualstrdict[num]['0.05_1.00']
fstr=basestrdict[num]['0.05']
lstr=basestrdict[num]['1.00']


print(qualstrdict[num]['0.05_1.00']+'\n\n')
print(comp(ctrlstr,fstr,lstr))

#print(basestrdict['055d799c-be1f-458b-8371-9994fef909d8']['0.25']+'\n\n\n\n')
#print(basestrdict['18d13ed9-c1d1-404a-bdc8-c275c7f152e0']['2.00'])

#65023614-4774-436d-ba4b-517c3eaa5c8e Mq 60

#05cad487-1c42-478b-9436-700ffca09df4 Mq 43

#09257bd8-2d1b-4fef-a4fc-f9cc72607e8b Mq 46



