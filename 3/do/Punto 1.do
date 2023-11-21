*Taller 3

clear all
cap log close
set more off
cls


/*==============================================================================
 1: Main Paths
==============================================================================*/

**# Mariana Bonet --------------------------------------------------------------
if "`c(username)'"=="maria" {
	global git   "C:\Users\maria\OneDrive - Universidad de los andes\MECA\Econometria Avanzada\econavanzadatalleres"
}

**# Andres Molano --------------------------------------------------------------
if "`c(username)'"=="andresmolano" {
	global git   "/Users/andresmolano/Desktop/Econometría Avanzada/Taller 1"
}

/*==============================================================================
 2: Secondary Paths
==============================================================================*/
* Output
global taller   "${git}/3"
global do 		"${taller}/do"
global output	"${taller}/output"
global data 	"${taller}/data"


/*==============================================================================
 3: Desarrollo Punto 2
==============================================================================*/

*Cargar datos

use "${data}/P3/smoke_day_v3.dta", clear 

**#1b. Transformacion a datos panel 
*) Ordenamos la base de acuerdo a la variable panel (countyfip) y a la variable de tiempo (date)
order countyfip date

*) Declaramos la base para ser panel 
xtset countyfip date, d

*) Generamos una variable que nos indique la fecha en la que hubo cada incendio
gen first_fire_date = date if smoke_day==1
format first_fire_date %td

*) A partir de lo anterior, generamos una variable que nos indique cuando fue el primer incendio
egen first_fire = min(first_fire_date), by(countyfip)
format first_fire %td

*) Generamos variable de tratamiento
gen Dit = 0
bys countyfip: replace Dit = 1 if (date >= first_fire)

*) Creamos una variable que nos indique el tiempo relativo
bys countyfip: gen rel_time=date-first_fire

*) Generamos dummies para cada categoría posible de tiempos relativos
tab rel_time, gen(evt)

*) Cambiamos los labels y los nombres para no confundirnos

*Leads

forvalues x = 1/81 {
    
    local j= 82-`x'
	ren evt`x' evt_l`j'
	cap label var evt_l`j' "-`j'" 
}


*Lags

forvalues x = 0/83 {
    
    local j= 82+`x'
	ren evt`j' evt_f`x'
	cap label var evt_f`x' "`x'"  
}

*) Periodo base (t=-1) - Omitir por multicolinealidad
replace evt_l1=0

**************************************
***************PUNTO  D***************
**************************************

*) Vamos a generar la variable que indique el dia de la semana

gen weekday = dow(date)
label variable weekday "0=Sunday,...,6=Saturday"

*) Estimamos por MCO
reghdfe pm25 evt_l10 evt_l9 evt_l8 evt_l7 evt_l6 evt_l5 evt_l4 evt_l3 evt_l2 evt_l1 evt_f0 evt_f1 evt_f2 evt_f3 evt_f4 evt_f5 evt_f6 evt_f7 evt_f8 evt_f9 evt_f10, nocon absorb(day countyfip weekday) cluster(countyfip)

estimates store coefs_i

*) Realizamos tabla (REVISAR)

*) Graficamos
coefplot coefs_i, omitted														///
	vertical 																	///
	label drop(_cons)															///
	yline(0, lpattern(dash) lwidth(*0.5))   							 		///
	ytitle("Concentración de pm2.5 (ug/m3)")                                    ///
	xtitle("Tiempo relativo al tratamiento", size(medsmall))			 		///
	xlabel(, labsize(small) nogextend labc(black)) 	 				 			///
	ylabel(,nogrid nogextend labc(black) format(%9.2f)) 				 		///
	msymbol(O) 														 			///
	mlcolor(black) 													 			///
	mfcolor(black) 													 			///
	msize(vsmall) 													 			///
	levels(95) 														 			///
	xline(11, lpattern(dash) lwidth(*0.5))										///
	ciopts(lcol(black) recast(rcap) lwidth(*0.8)) 					 			///
	plotregion(lcolor(black) fcolor(white))  							 		///
	graphregion(lcolor(black) fcolor(white))  						 			///
	yscale(lc(black)) 												 			///
	xscale(lc(black)) 												 			///
	name(Punto_2d, replace)
	
*) Pruebas de hipótesis (REVISAR)
estimates restore coefs_i
test evt_l1 evt_l2 evt_l3  /* No hay efectos anticipatorios 			*/
test evt_f0 evt_f1 evt_f2 evt_f3 /* Hay efectos dinámicos				*/

**************************************
***************PUNTO  F***************
**************************************

*) Estimación
*net install csdid, from ("https://raw.githubusercontent.com/friosavila/csdid_drdid/main/code/") replace

csdid pm25 evt_l10 evt_l9 evt_l8 evt_l7 evt_l6 evt_l5 evt_l4 evt_l3 evt_l2 evt_l1 evt_f0 evt_f1 evt_f2 evt_f3 evt_f4 evt_f5 evt_f6 evt_f7 evt_f8 evt_f9 evt_f10, ivar(countyfip) time(date) gvar(first_fire)  		
/*==============================================================================
 5: Desarrollo Punto 3
==============================================================================*/
clear all
use "${data}/P2/sim.dta", clear 

**#1a. Tabla de suma de errores

reg Y X 
predict residual, res
predict Y_hat, xb

gen var_errors= cond(residual>0, 1, 0)

egen sumapos = sum(residual) if residual>0
egen sumaneg = sum(residual) if residual<0
sum sumapos sumaneg

eststo total: estpost summ sumapos sumaneg

**#1b. Grafica dispersion
twoway (scatter Y X, msymbol(O) mlcolor(stc15) mfcolor(stc15) xlabel(0(1)4) xscale(range(0 4))) (lfit Y X, lcolor(stc15) legend(label (2 "Línea ajuste, media") pos(6) col(3))) (rcap Y Y_hat X, lcolor(stc15) legend(label (3 "Error de predicción individual") pos(6)))
gr export "${output}/grafica1b.png", replace as(png)

**#2 Estimacion 
qreg Y X
predict Y_hatb, xb
predict residualm, res

**#2a. Grafica dispersion 
twoway (scatter Y X, msymbol(O) mlcolor(gs7) mfcolor(gs7)  xlabel(0(1)4) xscale(range(0 4))) (lfit Y_hatb X, lcolor(gs7) legend(label (2 "Línea ajuste, mediana") pos(6) col(2)))(lfit Y X, lcolor(stc15) legend(label (3 "Línea ajuste, media") pos(6))) (rcap Y Y_hatb X, lcolor(gs7) legend(label (4 "Error de predicción individual") pos(6)))
gr export "${output}/grafica2a.png", replace as(png)

**#4 Estimacion 0.1, 0.25, 0.5, 0.75 y 0.9
qreg Y X, quantile(0.1)
predict residual10, res
predict Y_hat_10, xb

qreg Y X, quantile(0.25)
predict residual25, res
predict Y_hat_25, xb

qreg Y X, quantile(0.5)
predict residual50, res
predict Y_hat_50, xb

qreg Y X, quantile(0.75)
predict residual75, res
predict Y_hat_75, xb

qreg Y X, quantile(0.9)
predict residual90, res
predict Y_hat_90, xb

**#4a Grafico con estimaciones anteriores 0.1, 0.25, 0.5, 0.75 y 0.9
twoway (scatter Y X, msymbol(O) mlcolor(gs7) mfcolor(gs7) xlabel(0(1)4) xscale(range(0 4))) (lfit Y X, lcolor(purple) legend(label(2 "Línea ajuste media") pos(6) col(4))) (lfit Y_hat_10 X, lcolor(lavender) legend(label(3 "Línea ajuste 0.10"))) (lfit Y_hat_25 X, lcolor(styellow) legend(label(4 "Línea ajuste 0.25"))) (lfit Y_hat_50 X, lcolor(orange) legend(label(5 "Línea ajuste 0.50"))) (lfit Y_hat_75 X, lcolor(emerald) legend(label(6 "Línea ajuste 0.75"))) (lfit Y_hat_90 X, lcolor(sienna) legend(label(7 "Línea ajuste 0.90")))
gr export "${output}/grafica4a.png", replace as(png)

**#4c Tabla de errores

preserve 

keep residual* 

global res residual residualm residual10 residual25 residual50 residual75 residual90

foreach var in $res {

gen errors`var'= cond(`var'>0, 1, 0)
sum errors`var'
dis "`var' count positive errors:"
count if errors`var'==1
dis "`var' count negative errors: "
count if errors`var'==0

egen sumapos`var' = sum(`var') if `var'>0
sum sumapos`var'
local pos = r(mean)
dis "`var' sum of positive errors: `pos'"

egen sumaneg`var' = sum(`var') if `var'<0
sum sumaneg`var'
local neg = r(mean)
dis "`var' sum of negative errors: `neg'"
}  

clear 
input Estimación ObsPos SumaPos ObsNeg SumaNeg
Estimación ObsPos SumaPos ObsNeg SumaNeg
1 22 64.521 34 -64.521 
2 27 81.908 29 -40.147
10 49 183.632 7 -2.874
25 41 117.615 15 -18.513
50 27 81.908 29 -40.147
75 14 22.947 42 -148.279
90 5 3.025 51 -253.833
 end
 
mkmat Estimación ObsPos SumaPos ObsNeg SumaNeg, matrix(Tablaerrores)

esttab matrix(Tablaerrores) using "${output}/Tablaerrores4.tex", replace
  
**#6 Estimacion reg lineal lnwage y educ por MCO y QR [0.1, 0.9]
clear all
use "${data}/P2/Card.dta", clear 
  
reg lwage i.educ
predict residual, res
predict Y_hat, xb

qreg lwage i.educ, quantile(0.1)
predict residual1, res
predict Y_hat_1, xb

qreg lwage i.educ, quantile(0.2)
predict residual2, res
predict Y_hat_2, xb

qreg lwage i.educ, quantile(0.3)
predict residual3, res
predict Y_hat_3, xb

qreg lwage i.educ, quantile(0.4)
predict residual4, res
predict Y_hat_4, xb

qreg lwage i.educ, quantile(0.5)
predict residual5, res
predict Y_hat_5, xb	

qreg lwage i.educ, quantile(0.6)
predict residual6, res
predict Y_hat_6, xb	

qreg lwage i.educ, quantile(0.7)
predict residual7, res
predict Y_hat_7, xb	

qreg lwage i.educ, quantile(0.8)
predict residual8, res
predict Y_hat_8, xb	

qreg lwage i.educ, quantile(0.9)
predict residual9, res
predict Y_hat_9, xb		

**#6a Grafico regresiones estimadas por MCO, y para los cuantiles 0.1 0.3, 0.5, 0.7 y 0.9.
twoway (scatter lwage educ, msymbol(O) mlcolor(gs7) mfcolor(gs7) xtitle("Educación") xlabel(0(5)20) xscale(range(0 20)) legend(label(1 "Salario (ln)"))) (lfit lwage educ, lcolor(purple) legend(label(2 "MCO") pos(6) col(4))) (lfit Y_hat_1 educ, lcolor(lavender) legend(label(3 "Línea ajuste 0.1"))) (lfit Y_hat_3 educ, lcolor(styellow) legend(label(4 "Línea ajuste 0.3"))) (lfit Y_hat_5 educ, lcolor(orange) legend(label(5 "Línea ajuste 0.5"))) (lfit Y_hat_7 educ, lcolor(emerald) legend(label(6 "Línea ajuste 0.7"))) (lfit Y_hat_9 educ, lcolor(sienna) legend(label(7 "Línea ajuste 0.9")))
gr export "${output}/grafica6a.png", replace as(png)


**#6b regresiones MCO y para los cuantiles 0.1, 0.3, 0.5, 0.7 y 0.9.
eststo MCO: reg lwage educ
eststo q1: qreg lwage educ, quantile(0.1)
eststo q2: qreg lwage educ, quantile(0.2)
eststo q3: qreg lwage educ, quantile(0.3)
eststo q4: qreg lwage educ, quantile(0.4)
eststo q5: qreg lwage educ, quantile(0.5)
eststo q6: qreg lwage educ, quantile(0.6)
eststo q7: qreg lwage educ, quantile(0.7)
eststo q8: qreg lwage educ, quantile(0.8)
eststo q9: qreg lwage educ, quantile(0.9)

 #d;
                esttab MCO q1 q3 q5 q7 q9
                        using "${output}/results6b.tex", replace
                        style(tex) title(" ")
                        cells("b(fmt(3) star)" se(par([ ])fmt(3)))
                        starlevels(* 0.1  ** 0.05 *** 0.01)
                     ;
 #d cr
 
**#6c grafica deciles, coef estimado e intervalos de confianza

eststo educ: sqreg lwage educ, quantiles(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9)
estat coefplot educ, title("") xlabel(0.1(0.1)0.9) xscale(range(0.1 0.9)) ytitle("") xtitle("Deciles") legend(pos(6) col(3) label(1 "Regresión" 2 "Intervalo de confianza 95%"))

using "${output}/grafica6c.png", replace as(png)

**#7b prueba de hipotesis  
set seed 1001	
sqreg lwage educ, quantile(.1 .9) 
eststo prueba: test [q10]educ = [q90]educ

mat MAT = J(1,2,.)
mat MAT[1,1]=r(F)
mat MAT[1,2]=r(p)
mat list MAT
 #d;
		esttab matrix(MAT,fmt(3)) using "${output}/tabla7.tex", 
		cell("c1 c2") noobs nonumber nomtitles
		collabels("Valor F" "P-valor") varlabels(r1 "Prueba de hipotesis") 
		label replace;
 #d cr