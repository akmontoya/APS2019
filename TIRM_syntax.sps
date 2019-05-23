T-TEST PAIRS=int_G WITH int_I (PAIRED). 

T-TEST PAIRS=comm_G WITH comm_I (PAIRED). 

compute int_diff = int_G - int_I. 
compute comm_diff = comm_G - comm_I. 
compute comm_sum = comm_G+comm_I.
compute comm_sumc = comm_G+comm_I - 8.325490. 
EXECUTE.  
regression dep = int_diff /method = enter comm_diff comm_sumc. 

MEMORE m = comm_G comm_I /y = int_G int_I. 

MEMORE m = comm_I comm_G diff_I diff_G /y = int_I int_G. 

MEMORE m= HazSimp HazComp /y = DoseSimp DoseComp. 

MEMORE m= HazSimp HazComp /y = DoseSimp DoseComp /bc = 1. 

MEMORE m= HazSimp HazComp /y = DoseSimp DoseComp /mc = 1. 

MEMORE m= HazSimp HazComp /y = DoseSimp DoseComp /normal = 1. 