/* **************************************************************** */
/* FORMAT                                                           */
/*                                                                  */
/* The format macro can be called from a post process step of a dw  */
/* table create.                                                    */
/*                                                                  */
/* Parameters                                                       */
/*                                                                  */
/* start : the name of the start variable                           */
/* label : the name of the label                                    */
/* fmtname : the name to give the format                            */
/* type: the type of format                                         */
/*                                                                  */
/*                                                                  */
/* DEVELOPMENT/MAINTENANCE HISTORY                                  */
/* DATE        BY          NOTE                                     */
/* ================================================================ */
/* 16MAR2002   SASGNN      Initial Creation.                        */
/* 10MAR2004   SASGNN      Pass in value to use as other            */
/* **************************************************************** */

/* **************************************************************** */
/* Copyright (c) 2002 by SAS Institute, Inc., Cary, NC 27513 USA    */
/* --- All Rights Reserved                                          */
/* **************************************************************** */

%macro format(dsname=parmdl.loplook2,
              start=c_lop,
              label=label,
              fmtname=lop2f,
              type=C,
              desc=LOP2 Format,
				  otherval=
             ) ;


%if otherval=%str() %then otherval='Other';

data lookup;
set &dsname(rename=(&start=start &label=label));

run;



data lookup;
  set lookup;
  fmtname="&fmtname";
  type="&type";
  hlo=' ';

run;

data lookup2;

  fmtname="&fmtname";
  type="&type";
  hlo='O';
  label="&otherval";

run;

data lookup;
set lookup lookup2;
run;


proc format library=formats cntlin=lookup;
 run;

%if &type=C %then %let fmtype=formatc;
%else %let fmtype=format;

%macro old;
/* commented out viya does not have proc catalog */
proc catalog catalog=formats.formats;
   modify &fmtname (description="&desc")
      /entrytype=&fmtype;
   quit;
%mend;

%mend;