* Encoding: UTF-8.
* APS Workshop.


* Convert Fluency data to long-form data.

VARSTOCASES
  /ID=id
  /MAKE Hazard FROM HazFas HazCyt HazNxu HazTon HazRib HazCal
  /MAKE Dose FROM DoseFas DoseCyt DoseNxu DoseTon DoseRib DoseCal
  /INDEX=Drug(6) 
  /KEEP=
  /NULL=KEEP.

RECODE Drug (1=1) (2=0) (3=0) (4=1) (5=0) (6=1) INTO Simple.
EXECUTE.



* MLM: Regress Hazard on Name.

MIXED Dose WITH Hazard
  /FIXED=Hazard | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT Hazard | SUBJECT(id) COVTYPE(UN).

* Grand mean center.

DESCRIPTIVES VARIABLES=Hazard
  /STATISTICS=MEAN.

COMPUTE Hazard_grand = Hazard - 5.3048.
EXECUTE.

MIXED Dose WITH Hazard_grand
  /FIXED=Hazard_grand | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT Hazard_grand | SUBJECT(id) COVTYPE(UN).


* Group mean center.

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=id
  /Hazard_m=MEAN(Hazard).

COMPUTE Hazard_groupc = Hazard - Hazard_m.
EXECUTE.

MIXED Dose WITH Hazard_groupc
  /FIXED=Hazard_groupc | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT Hazard_groupc | SUBJECT(id) COVTYPE(UN).


* Contextual.

MIXED Dose WITH Hazard_groupc Hazard_m
  /FIXED=Hazard_groupc Hazard_m | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT Hazard_groupc | SUBJECT(id) COVTYPE(UN).


* Group mean center X.

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=id
  /Simple_m=MEAN(Simple).

COMPUTE Simple_groupc = Simple - Simple_m.
EXECUTE.

* Fit model for M with Error.

MIXED Hazard WITH Simple_groupc Simple_m
  /FIXED=Simple_groupc Simple_m | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT | SUBJECT(id) COVTYPE(VC).


* Fit model for M without Error. 

MIXED Hazard WITH Simple_groupc
  /FIXED=Simple_groupc | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT | SUBJECT(id) COVTYPE(VC).


* Fit model for Y.

MIXED Dose WITH Hazard_groupc Hazard_m Simple_groupc
  /FIXED=Hazard_groupc Hazard_m Simple_groupc | SSTYPE(3)
  /METHOD=REML
  /PRINT=G  SOLUTION TESTCOV
  /RANDOM=INTERCEPT | SUBJECT(id) COVTYPE(VC).



* Fit models simultaneously.

MLmed data = DataSet1
/x = Simple
/xB = 0
/m1 = Hazard
/y = Dose
/cluster = id
/folder = /Users/username/Desktop/.


* Add random X -> M and m -> Y slopes, and covariance between random slopes.

MLmed data = DataSet1
/x = Simple
/xB = 0
/randx = 01
/m1 = Hazard
/randm = 1
/y = dose
/covmat = UN
/cluster = id
/folder = /Users/username/Desktop/.



* Tutor dataset.

MLmed data = DataSet1
/x = tutor
/m1 = motiv
/y = post
/cov1 = pre
/cluster = classid
/folder = /Users/username/Desktop/.


* With random slopes and their covariance.


MLmed data = DataSet1
/x = tutor
/randx = 01
/m1 = motiv
/randm = 1
/y = post
/cov1 = pre
/covmat = UN
/cluster = classid
/folder = /Users/username/Desktop/.


* 2-1-1 model.

MLmed data = DataSet1
/x = train
/xW = 0
/m1 = motiv
/y = post
/cov1 = pre
/cluster = classid
/folder = /Users/username/Desktop/.

