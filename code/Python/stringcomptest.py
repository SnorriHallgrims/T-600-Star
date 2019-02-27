import bamnostic as bs
import os.path
from functions import comp,parse_md


filepath=os.path.join(os.path.dirname(__file__),'../../../T-600-Star data/ru_snorri/gpv213sp1.00.minimap.sorted.bam')
bam=bs.AlignmentFile(filepath,'rb')

r=next(bam)

ref=parse_md(r.get_tag('MD'),r.cigarstring,r.query_sequence)

outstr=comp(r.cigarstring,r.query_sequence,ref)

#print(len(r.seq))
#print(len(ref))


#print(r.cigarstring+'\n')
#print(outstr)