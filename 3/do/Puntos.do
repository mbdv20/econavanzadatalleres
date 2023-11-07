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

count if residual <0
count if residual >0
egen sumapos = sum(residual) if residual>0
egen sumaneg = sum(residual) if residual<0
sum sumapos sumaneg

**#1b. Grafica dispersion

twoway (scatter Y X) (lfit Y X), xtitle("")
, connect(stepstair) 

scatter Y X || lfit Y X ||connect(stepstair)

gr export "${output}/figures/distributions_violmh.jpg", replace as(jpg)
