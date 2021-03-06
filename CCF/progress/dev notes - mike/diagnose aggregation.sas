libname store '/Local_Files/covid';
PROC SGPLOT DATA=store.MODEL_FINAL;
	where ModelType='DS - SIR' and ScenarioIndex<3;
	by ScenarioIndex;
	SERIES X=DATE Y=S_N / LINEATTRS=(THICKNESS=2);
	SERIES X=DATE Y=E_N / LINEATTRS=(THICKNESS=2);
	SERIES X=DATE Y=I_N / LINEATTRS=(THICKNESS=2);
	SERIES X=DATE Y=R_N / LINEATTRS=(THICKNESS=2);
	XAXIS LABEL="Date";
	YAXIS LABEL="Daily Count";
RUN;
proc sort data=store.model_final out=sum; 
	where ModelType='DS - SIR' and ScenarioIndex<3;
	by date;
run;

PROC TIMESERIES data=jesse out=jesse_sum_by_date;
           id date interval=day accumulate=total;
           var amount;
run;
proc expand data=sum out=sum method=none from=day to=day;
	convert S_N E_N I_N R_N / transformout=(sum);
	*id date;
run;
PROC SGPLOT DATA=sum;
	SERIES X=DATE Y=S_N / LINEATTRS=(THICKNESS=2);
	SERIES X=DATE Y=E_N / LINEATTRS=(THICKNESS=2);
	SERIES X=DATE Y=I_N / LINEATTRS=(THICKNESS=2);
	SERIES X=DATE Y=R_N / LINEATTRS=(THICKNESS=2);
	XAXIS LABEL="Date";
	YAXIS LABEL="Daily Count";
RUN;