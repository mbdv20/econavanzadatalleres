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

use "${data}/P3/base_spp_2014_2.dta", clear 

/* Outcome de interés (Y): Universidad de alta calidad o de baja calidad, Universidad publica o privada).
* Variable indep. de interés (T): Elección de alcalde proveniente de un 
	* 	partido islámico en las elecciones de 1994.
* Running variable (X): Margen de votos con la que ganó (o perdió) el
	*	candidato islámico en las elecciones de 1994.

¿Qué impacto tiene la llegada al poder de un alcalde islámico sobre la matricula en educacion superior y eleccion de universidad? 	*/

**#3.1 Estadisticas descriptivas 

	*Variables of interest
	global dptvas puntaje_saber11 edad estrato miembros_familia

	label var puntaje_saber11 "Puntaje Saber 11"
	label var edad "Edad en años"
	label var estrato "Estrato económico"
	label var miembros_familia "Número de miembros familiares"
	
	*Estimate descriptives
	eststo descriptivas: estpost sum ${dptvas}
	
	*Export table to latex
	#d;
        esttab descriptivas using "${output}/3Descriptivas.tex", 
		cells("count(fmt(2)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")
		frag replace label compress ;
     #d cr
	 
**#3.1 Graficos elegibilidad y tratamiento efectivo 

	*Grafico 1 probabilidad de ser elegible para el programa

	/*  puntaje max SISBEN = 1 & puntaje minimo SABER 11 = 310 & admision a programa universitario en una IES con acreditacion de alta calidad*/
	
cap drop rdplot_*
rdplot Y X, c(0) p(4) genvars													///
	graph_options(graphregion(color(white)) legend(off)						 	///
	 xti("Margen de votos islámicos") yti("Educación de la mujer")))  
	
scatter rdplot_mean_y rdplot_mean_x, mcolor(gray) ||							///
	qfit rdplot_hat_y rdplot_mean_x if rdplot_mean_x>=0, lcolor(black)	||		///
	qfit rdplot_hat_y rdplot_mean_x if rdplot_mean_x<=0, lcolor(black)  		///
	xline(0, lcolor(red) lp("-")) graphregion(color(white)) legend(off)			///
	xti("Margen de votos islámicos") yti("Educación de la mujer")

	