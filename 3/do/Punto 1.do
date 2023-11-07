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


/*==============================================================================
 5: Desarrollo Punto 3
==============================================================================*/

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
twoway (scatter Y X, msymbol(O) mlcolor(stc15) mfcolor(stc15)) (lfit Y X, lcolor(stc15)) (rcap Y Y_hat X, lcolor(stc15))
gr export "${output}/grafica1b.png", replace as(png)

**#2 Estimacion 
qreg Y X
predict Y_hatb, xb

**#2a. Grafica dispersion 
twoway (scatter Y X, msymbol(O) mlcolor(gs7) mfcolor(gs7)) (lfit Y_hatb X, lcolor(gs7))(lfit Y X, lcolor(stc15)) (rcap Y Y_hatb X, lcolor(gs7))
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
twoway (scatter Y X, msymbol(O) mlcolor(gs7) mfcolor(gs7)) (lfit Y X, lcolor(stc15)) (lfit Y_hat_10 X, lcolor(gs7)) (lfit Y_hat_25 X, lcolor(stc15)) (lfit Y_hat_50 X, lcolor(gs7)) (lfit Y_hat_75 X, lcolor(stc15)) (lfit Y_hat_90 X, lcolor(gs7))

**#4c Tabla de errores

preserve 

keep residual* 

local res 

foreach var in $res {
	
	
}
restore 
