* Encoding: UTF-8.


*/ load the data in.
GET DATA
  /TYPE=XLSX
  /FILE='/Users/stephenbaum/Desktop/Shafir1993.xlsx'
  /SHEET=name 'Cleaned'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet2 WINDOW=FRONT.

*/ change condition variable to numeric.
*/ change english_pass to numeric.

*/ compute variable for people that passed the attention check.
COMPUTE passac = 0.
IF (condition = AC) passac = 1.
EXECUTE.

*/ compute variable for people that passed the AC and English check.
COMPUTE use = 0.
IF (passac = 1 & english_pass = 1) use = 1.
EXECUTE.

*/ just look at the descriptive accross conditions.
FREQUENCIES VARIABLES=choose_dv reject_dv
  /ORDER=ANALYSIS.

*/ ~78% of people prefer Lottery 2 in choose condition.
*/ ~51% of people prefer Lottery 2 in reject condition.
*/ overall, 129% of people prefer Lottery 2.

*/ Let's create a new variable that defines this.
COMPUTE prefer_two = 0.
IF (condition = 1 & choose_dv = 2) prefer_two = 1.
IF (condition = 2 & reject_dv = 1) prefer_two = 1.
EXECUTE.

*/ chi-squared to see if the preference differs between conditions.
CROSSTABS
  /TABLES=condition BY prefer_two
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL
  /BARCHART.

*/ do analyses with only participants that passed the AC and English check.
USE ALL.
COMPUTE filter_$=(use = 1).
VARIABLE LABELS filter_$ 'use = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
