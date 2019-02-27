

def parse_md(md,cig,bs):
    num=''
    nstr=''
    ind=0

    for c in cig:
        if c.isdigit(): num+=c
        elif (c=='I' or c=='S'):
            ind+=int(num)
            num=''
        elif (c=='M'):
            nstr+=bs[ind:(ind+int(num))]
            ind+=int(num)
            num=''
        elif (c=='D' or c=='H'): num=''


    num=''
    ref=''
    ind=0
    for c in md:
        if c.isdigit(): 
            num+=c
            delbool=False
        else:
            if (num!=''):
                ref+=nstr[ind:(ind+int(num))]
                ind+=int(num)
                num=''
            if (c=='^'):delbool=True
            else:
                ref+=c
                if (not delbool): ind+=1

    if (not num==''):
        ref+=nstr[ind:(ind+int(num))]
        ind+=int(num)
        num=''
    return ref

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