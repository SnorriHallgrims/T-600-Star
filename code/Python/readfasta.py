from Bio import SeqIO
import os.path

def fread():

    sp=['0.05','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00']
    seqdict={}
    #filepath='C:/Cadence/SPB_Data/T-600-Star/data/fasta/gpv213sp'+sp[0]+'.filt.fa'
    filepath=os.path.join(os.path.dirname(__file__),'../../data/fasta/gpv213sp'+sp[0]+'.filt.fa')
    fasta_seq = SeqIO.parse(filepath,'fasta')

    for r in fasta_seq:
        seqdict[r.id]={}

    for s in sp:
        #filepath='C:/Cadence/SPB_Data/T-600-Star/data/fasta/gpv213sp'+s+'.filt.fa'
        filepath=os.path.join(os.path.dirname(__file__),'../../data/fasta/gpv213sp'+s+'.filt.fa')

        fasta_seq = SeqIO.parse(filepath,'fasta')

        for r in fasta_seq:
            seqdict[r.id][s]=str(r.seq)

    return seqdict

