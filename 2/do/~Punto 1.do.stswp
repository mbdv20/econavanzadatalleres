*Taller 2: Punto 1

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
global taller   "${git}/2"
global do 		"${taller}/do"
global output	"${taller}/output"
global data 	"${taller}/data"


/*==============================================================================
 3: Desarrollo Punto 1
==============================================================================*/

*Load data

use "${data}/P1/vih.dta", clear 

**#1a. Diferencia de medias 

	* t-test

		ttest got, by(any)

**#1c. Tabla de balance 
/*Presenten un tabla con la informacion de la media de la variable, la media
para el grupo de tratamiento y control, su error estandar, la diferencia de
medias y el p-valor de dicha diferencia
*/

global covs distvct age male mar educ2004 timeshadsex_s eversex tb land2004

di "${covs}"

mat balance=J(3,10,.)
mat significancia=J(8,10,0)

	
	ttest got, by(any)
	return list
	
	tokenize ${covs}
	forvalues j=1/9{

		qui sum ``j''
		matrix balance[`j',1]=r(mean)
		matrix balance[`j',2]=r(sd)
		ttest ``j'', by(any) 
		matrix balance [`j',3]=r(mu_2) // tratados
		matrix balance [`j',4]=r(sd_2)
		matrix balance [`j',5]=r(mu_1) // no tratados
		matrix balance [`j',6]=r(sd_1)
		matrix balance[`j',7]=r(mu_2)-r(mu_1)
		matrix balance[`j',8]=r(se)
		matrix balance[`j',9]=r(p) 
		matrix significancia[`j',7]=(r(p)<0.1)+(r(p)<0.05)+(r(p)<0.01)

		matlist balance
		matlist significancia
	}

	frmttable using "${output}/Tabla_1_Balance_Muestral.doc", replace sdec(3)				/// 
		statmat(balance) substat(1) annotate(significancia) asymbol(*,**,***)	///
		title("Tabla 1. Balance muestral")										///
		ctitles("", "Muestra completa", "Tratamiento", "Control", "Diferencia",	///
			"p-valor")															///
		rtitles("Distancia a centro"\ "" \"Edad"\ "" \ "Sexo"\""\ "Casado"\""\ "Educación"\""\"Veces al mes que se ha mantenido relaciones sexuales"\""\"Indicador de si alguna vez tuvo relaciones sexuales en la l´ınea de base"\""\"Indicador si declar´o haberse sometido a una prueba del VIH antes de la l´ınea de base"\""\" Indicador de si se pose´ıa alg´un terreno en la l´ınea de base"\"")

