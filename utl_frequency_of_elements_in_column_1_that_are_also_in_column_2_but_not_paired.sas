Frequency of elements in column 1 that are also in column 2 but not paired

Same results

  1. SAS
  2. Base WPS
  3. WPS Proc R

github
https://tinyurl.com/y7l6oogy
https://github.com/rogerjdeangelis/utl_frequency_of_elements_in_column_1_that_are_also_in_column_2_but_not_paired

https://tinyurl.com/ybtrdckj
https://communities.sas.com/t5/Base-SAS-Programming/I-have-data-set-need-to-count-column-b-values-how-many-times-it/m-p/463504


HAVE
====
                      |     RULES
SD1.HAVE total obs=8  |
                      |
    UNQ    DUP        |   UNQ    COUNT
                      |
     1      0         |    1       2     1 occurs twice in DUP column
     3      0         |    3       2     3 occurs twice in DUP column
     4      1         |    4       2     4 occurs twice in DUP column
     5      1         |
     6      3         |
     7      3         |
     .      4         |
     .      4         |

EXAMPLE OUTPUT

 40 obs from want total obs=6

  UNQ    COUNT

   1       2
   3       2
   4       2
   5       0
   6       0
   7       0


PROCESS
=======


proc sql;

 * UNQ is the unique column to match to the DUP column;

 select
     l.unq
     ,sum(l.unq=r.dup) as count     /* just sum the equal values */
 from
     sd1.have as l, sd1.have as r   /* cartesian */
 where
     l.unq is not missing
 group
     by l.unq;
quit;



OUTPUT
======

The WPS System

WORK.WANT total obs=6

 UNQ    COUNT

  1       2
  3       2
  4       2
  5       0
  6       0
  7       0

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input unq dup;
cards4;
1 0
3 0
4 1
5 1
6 3
7 3
. 4
. 4
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 "d:/sd1";
proc sql;
 select
     l.unq
     ,sum(l.unq=r.dup) as count
 from
     sd1.have as l, sd1.have as r
 where
     l.unq is not missing
 group
     by l.unq;
quit;
run;quit;
');



%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(sqldf);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat");
want<-sqldf("
 select
     l.UNQ
     ,sum(l.UNQ=r.DUP) as count
 from
     have as l, have as r
 where
     l.UNQ is not null
 group
     by l.UNQ;
");
want;
endsubmit;
import r=want data=wrk.want;
run;quit;
proc print data=wrk.want;
run;quit;
');

