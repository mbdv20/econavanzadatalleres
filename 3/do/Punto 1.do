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

use "${data}/P2/vih.dta", clear 

**#1a. Diferencia de medias 

	* t-test

	ttest got, by(any)
	preserve 
		recode any (1=0) (0=1)
		eststo dif: estpost ttest got, by(any) unequal
		esttab dif using "${output}/1ttest.tex", replace
	restore 
	
	
**#1c. Tabla de balance 
/*Presenten un tabla con la informacion de la media de la variable, la media
para el grupo de tratamiento y control, su error estandar, la diferencia de
medias y el p-valor de dicha diferencia
*/		
		preserve
    
        * Clear estimates 
        eststo clear
     
	 	* Outcomes
		global blcntrls distvct age male mar educ2004 eversex tb usecondom04	///
		hadsex12 land2004
		   
		   label var distvct "Distancia (km)"
		   label var age "Edad"
		   label var male "Sexo"
		   label var mar "Casado en LB"
		   label var educ2004 "Años de educación en LB"
		   label var timeshadsex_s "Relaciones sexuales por mes"
		   label var eversex "Si ha tenido relaciones sexuales en LB"
		   label var tb "Examen de VIH antes de LB"
		   label var land2004 "Terrateniente"
		   label var usecondom04 "Uso de preservativo en el último año"
		   label var hadsex12 "Relaciones sexuales en el último año"
		   
        * Include latex indentation in labels
        foreach var in $blcntrls {
            
            global lab`var': variable label `var'
            local lab`var'2 `""\hspace{0.2cm}${lab`var'}""'
            label var `var' `lab`var'2'
            
        }

        * Estimate mean and sd for total sample, treatment and control groups
        eststo total: qui estpost sum  ${blcntrls}
        eststo treatment: qui estpost sum ${blcntrls} if any==1
        eststo control: qui estpost sum ${blcntrls} if any==0
        
		recode any (0=1) (1=0)
        * Estimate difference between treatment and control groups
        eststo dif: estpost ttest ${blcntrls}, by(any) unequal
        
        * Regression of baseline characteristics to obtain F-statistic
        reg any $blcntrls, vce(robust)
        local fstat: dis %9.3f `e(F)'
        
        * Export table
        #d;
        esttab total treatment control dif using "${output}/1BalanceMuestral.tex",
               cells("mean(pattern(1 1 1 0) fmt(2))
                      b(pattern(0 0 0 1) star fmt(2))" 
                     "sd(par(( )) pattern(1 1 1 0) fmt(3))
                      se(par([ ]) pattern(0 0 0 1) fmt(3))"
					  p(pattern(0 0 0 1)))
               stats(N fstat, fmt(%9.0f %9.3f) 
               labels("Observations" "Joint F-statistic"))	  
               replace label compress 
               mtitles("Total" "Tratamiento" "Control" "Diff (2)-(3)") title("") 
               substitute("Joint F-statistic&" "Joint F-statistic&`fstat'");
        #d cr
		
    restore

**#1d. Estimaciones 
	*Seleccion controles
	global ctrls distvct age male mar educ2004 a8 land2004

	label var any "Recibió incentivos económicos"  
	label var distvct "Distancia (km)"
	label var age "Edad"
	label var male "Sexo"
	label var mar "Casado en LB"
	label var educ2004 "Años de educación en LB"
	label var a8 "Porbabilidad de infección-VIH"
	label var land2004 "Terrateniente"
	label var site "Localidad"
	label var numcond "Número de condones comprados (S)"
	label var bought "Compra de condones voluntaria (S)"
	label var villnum "Aldea"
	
	eststo clear 
	*Regresion 1
	reg got any, cluster(villnum)
	est sto r1
	local fstat1: dis %9.3f `e(F)'
	
	*Regresion 2
	reg got any $ctrls, cluster(villnum)
	est sto r2
	local fstat2: dis %9.3f `e(F)'
	
	*Regresion 3
	reghdfe got any $ctrls, absorb(villnum) cluster(villnum)
	est sto r3
	local fstat3: dis %9.3f `e(F)'
	
	*Regresion 4
	reghdfe got any $ctrls numcond bought, absorb(villnum) cluster(villnum)
	est sto r4
	local fstat4: dis %9.3f `e(F)'
	
	esttab r* using "${output}/1Regresiones.tex", replace label compress nomtitles cells("b(fmt(3) star)" se(par([ ])fmt(3))) keep(any _cons) stats(N, labels("Observaciones") fmt (%9.0f %9.3f)) mgroups("Recibió resultados de VIH", pattern (1 0 0 0) prefix (&\multicolumn{1}{c} &\multicolumn{4}{c})) indicate("Controles demográficos = distvct age male mar educ2004 a8 land2004" "Efecto fijo por municipio = " "Controles relativos a uso de preservativos = numcond bought", labels (Sí No)) addnotes("Errores estandar clusterizados por aldeas. \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)}")

**#1e. Efectos heterogéneos 
	
	* Creamos interacciones de interes
	gen inters= any*male 
	gen interd=0
	replace interd=any*distvct if distvct<1.6
	gen intere=0
	replace intere=any*educ2004 if educ2004>2
	
	label var inters "Efectos heterogéneos por sexo"
	label var interd "Efectos heterogéneos por distancia (<1.5 km)"
	label var intere "Efectos heterogéneos por educación (>2 años)"
	* Limpiamos ambiente
	eststo clear 
	
	*Regresion 
	reghdfe got any $ctrls, absorb(villnum) cluster(villnum)
	est sto s1
	local fstat3: dis %9.3f `e(F)'
	
	*Regresion - efectos hetero
	reghdfe got any $ctrls inters interd intere, absorb(villnum) cluster(villnum)
	est sto s2
	local fstat3: dis %9.3f `e(F)'
	
	esttab s* using "${output}/1EH.tex", replace label compress nomtitles cells("b(fmt(3) star)" se(par([ ])fmt(3))) keep(any inters interd intere) stats(N, labels("Observaciones") fmt (%9.0f %9.3f)) mgroups("Recibió resultados de VIH", pattern (1 0 0 0) prefix (&\multicolumn{1}{c}&\multicolumn{2}{c})) indicate("Controles demográficos= distvct age male mar educ2004 a8 land2004" "Efecto fijo por municipio = ", labels (Sí No)) addnotes("Errores estandar clusterizados por aldeas. \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)}")
	
**#1g. Atrición  

gen atricion = cond(followupsurvey==. & survey2004!=.,1,0)
tab atricion

preserve

        * Clear estimates 
        eststo clear  
		   label var distvct "Distancia (km)"
		   label var age "Edad"
		   label var male "Sexo"
		   label var mar "Casado en LB"
		   label var educ2004 "Años de educación en LB"
		   label var timeshadsex_s "Relaciones sexuales por mes"
		   label var eversex "Si ha tenido relaciones sexuales en LB"
		   label var tb "Examen de VIH antes de LB"
		   label var land2004 "Terrateniente"
		   label var usecondom04 "Uso de preservativo en el último año"
		   label var hadsex12 "Relaciones sexuales en el último año"
        * Include latex indentation in labels
        foreach var in $blcntrls {
            
            global lab`var': variable label `var'
            local lab`var'2 `""\hspace{0.2cm}${lab`var'}""'
            label var `var' `lab`var'2'
            
        }

        * Estimate mean and sd for total sample, treatment and control groups
        eststo total: qui estpost sum  ${blcntrls}
        eststo atri: qui estpost sum ${blcntrls} if atricion==1
        eststo noatri: qui estpost sum ${blcntrls} if atricion==0
        
		recode atricion (0=1) (1=0)
        * Estimate difference between treatment and control groups
        eststo dif: estpost ttest ${blcntrls}, by(atricion)
        
        * Regression of baseline characteristics to obtain F-statistic
        reg atricion $blcntrls, vce(robust)
        local fstat: dis %9.3f `e(F)'
        
        * Export table
        #d;
        esttab total atri noatri dif using "${output}/1BalanceAtricion.tex",
               cells("mean(pattern(1 1 1 0) fmt(2))
                      b(pattern(0 0 0 1) star fmt(2))" 
                     "sd(par(( )) pattern(1 1 1 0) fmt(3))
                      se(par([ ]) pattern(0 0 0 1) fmt(3))"
					  p(pattern(0 0 0 1)))
               stats(N fstat, fmt(%9.0f %9.3f) 
               labels("Observations" "Joint F-statistic"))	  
               replace label compress 
               mtitles("Total" "Atrición" "No atrición" "Diff (2)-(3)") title("") 
               substitute("Joint F-statistic&" "Joint F-statistic&`fstat'")
			   addnotes();
        #d cr
		
    restore

**#1f. Impacto sobre la compra de preservativos
		gen CI_L =.
		gen CI_U =.
		gen mean_ =.
		
		foreach i in 50 100 200 300 {
				ci means numcond if Ti==`i'
				replace CI_L=r(lb) if Ti==`i'
				replace CI_U=r(ub) if Ti==`i'
				sum numcond if Ti == `i'
				replace mean_=r(mean) if Ti==`i'
		}
		
		tabstat numcond CI_L CI_U , save
		
		matrix fimpacto =r(StatTotal)
		gen num_cond = fimpacto[1 ,1]
		scalar Lower = fimpacto[2 ,1]
		scalar Upper = fimpacto[3 ,1]
		
		sum numcond if any == 0
		gen meanTi0=r(mean)
		
		graph twoway (scatter mean_ Ti) (line meanTi0 Ti) (rcap CI_L CI_U Ti), legend(off) xtitle("Monto del incentivo económico") ytitle("Promedio de preservativos comprados en seguimiento") 
		graph export "${output}/1Graph.png", replace

clear all
/*==============================================================================
 4: Desarrollo Punto 2
==============================================================================*/

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

	