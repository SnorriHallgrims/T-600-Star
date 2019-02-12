import os.path

my_path = os.path.dirname(__file__)
path=os.path.join(my_path,'../../data/fasta/gpv213sp0.05.filt.fa')
print(path)
o=open(path)

