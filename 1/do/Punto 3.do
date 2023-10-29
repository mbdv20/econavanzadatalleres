*Taller 1: Punto 3

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
global taller   "${git}/1"
global do 		"${taller}/do"
global output	"${taller}/outputs"


/*==============================================================================
 3: Desarrollo Punto 3
==============================================================================*/

* * * * * * * * 
* EJERCICIO A *
* * * * * * * * 

* i. Simulación

quietly forvalues i = 1(1)1000 {

set obs 1000
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

clear
}

* ii. * Estimación del modelo (1) usando errores estándar usuales

//Definición de la matriz
mat mat_a_usual = J(1000,2,.)
mat colnames mat_a_usual = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 1000
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x

restore
mat mat_a_usual[`i',1] = r(table)[5,1]
mat mat_a_usual[`i',2] = r(table)[6,1]
}

mat l mat_a_usual

* iii. Estimación del modelo usando errores estándar robustos (hc1)

//Definición de la matriz
mat mat_a_hc1 = J(1000,2,.)
mat colnames mat_a_hc1 = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 1000
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x, r

restore
mat mat_a_hc1[`i',1] = r(table)[5,1]
mat mat_a_hc1[`i',2] = r(table)[6,1]
clear
}

mat l mat_a_hc1

*iv. Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat mat_a_usual
svmat mat_a_hc1
gen in_a_usual = inrange(2, mat_a_usual1, mat_a_usual2)
gen in_a_hc1 = inrange(2, mat_a_hc11, mat_a_hc12)
sum in_a_usual
sum in_a_hc1


* * * * * * * * 
* EJERCICIO B *
* * * * * * * * 

* Estimación del modelo (1) usando errores estándar usuales

//Definición de la matriz
mat mat_b_usual = J(1000,2,.)
mat colnames mat_b_usual = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x

restore
mat mat_b_usual[`i',1] = r(table)[5,1]
mat mat_b_usual[`i',2] = r(table)[6,1]
}

mat l mat_b_usual

* Estimación del modelo usando errores estándar robustos (hc1)

//Definición de la matriz
mat mat_b_hc1 = J(1000,2,.)
mat colnames mat_b_hc1 = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x, r

restore
mat mat_b_hc1[`i',1] = r(table)[5,1]
mat mat_b_hc1[`i',2] = r(table)[6,1]
clear
}

mat l mat_b_hc1

*Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat mat_b_usual
svmat mat_b_hc1
gen in_b_usual = inrange(2, mat_b_usual1, mat_b_usual2)
gen in_b_hc1 = inrange(2, mat_b_hc11, mat_b_hc12)
sum in_b_usual
sum in_b_hc1


* * * * * * * * 
* EJERCICIO C *
* * * * * * * * 

* Estimación del modelo (1) usando errores estándar usuales

//Definición de la matriz
mat mat_c_usual = J(1000,2,.)
mat colnames mat_c_usual = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x

restore
mat mat_c_usual[`i',1] = r(table)[5,1]
mat mat_c_usual[`i',2] = r(table)[6,1]
}

mat l mat_c_usual

* Estimación del modelo usando errores estándar robustos (hc3)

//Definición de la matriz
mat mat_c_hc3 = J(1000,2,.)
mat colnames mat_c_hc3 = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x, vce(hc3)

restore
mat mat_c_hc3[`i',1] = r(table)[5,1]
mat mat_c_hc3[`i',2] = r(table)[6,1]
clear
}

mat l mat_c_hc3

*Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat mat_c_usual
svmat mat_c_hc3
gen in_c_usual = inrange(2, mat_c_usual1, mat_c_usual2)
gen in_c_hc3 = inrange(2, mat_c_hc31, mat_c_hc32)
sum in_c_usual
sum in_c_hc3


* * * * * * * * 
* EJERCICIO D * 
* * * * * * * * 

* Estimación del modelo (1) usando errores estándar usuales

//Definición de la matriz
mat mat_d_usual = J(1000,2,.)
mat colnames mat_d_usual = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,x^2)

gen y = 2*x + u

reg y x

restore
mat mat_d_usual[`i',1] = r(table)[5,1]
mat mat_d_usual[`i',2] = r(table)[6,1]
}

mat l mat_d_usual

* Estimación del modelo usando errores estándar robustos (hc1)

//Definición de la matriz
mat mat_d_hc1 = J(1000,2,.)
mat colnames mat_d_hc1 = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,x^2)

gen y = 2*x + u

reg y x, r

restore
mat mat_d_hc1[`i',1] = r(table)[5,1]
mat mat_d_hc1[`i',2] = r(table)[6,1]
}

mat l mat_d_hc1

* Estimación del modelo usando errores estándar robustos (hc3)

//Definición de la matriz
mat mat_d_hc3 = J(1000,2,.)
mat colnames mat_d_hc3 = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 20
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,x^2)

gen y = 2*x + u

reg y x, vce(hc3)

restore
mat mat_d_hc3[`i',1] = r(table)[5,1]
mat mat_d_hc3[`i',2] = r(table)[6,1]
clear
}

mat l mat_d_hc3

*Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat mat_d_usual
svmat mat_d_hc1
svmat mat_d_hc3
gen in_d_usual = inrange(2, mat_d_usual1, mat_d_usual2)
gen in_d_hc1 = inrange(2, mat_d_hc11, mat_d_hc12)
gen in_d_hc3 = inrange(2, mat_d_hc31, mat_d_hc32)
sum in_d_usual
sum in_d_hc1
sum in_d_hc3


* * * * * * * * 
* EJERCICIO E *
* * * * * * * * 

* Estimación del modelo (1) usando errores estándar usuales

//Definición de la matriz
mat mat_e_usual = J(1000,2,.)
mat colnames mat_e_usual = ll ul 

//Loop para simulación
quietly forvalues i = 1(1)1000 {

preserve
clear
set obs 100
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

expand 10

reg y x

restore
mat mat_e_usual[`i',1] = r(table)[5,1]
mat mat_e_usual[`i',2] = r(table)[6,1]
}

mat l mat_e_usual

* Estimación del modelo (1) usando errores estándar robustos (hc1)

//Definición de la matriz
mat mat_e_hc1 = J(1000,2,.)
mat colnames mat_e_hc1 = ll ul 

//Loop para simulación
quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 100
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

expand 10

reg y x, r

restore
mat mat_e_hc1[`i',1] = r(table)[5,1]
mat mat_e_hc1[`i',2] = r(table)[6,1]
}

mat l mat_e_hc1

* Estimación del modelo (1) usando errores estándar robustos (hc3)

//Definición de la matriz
mat mat_e_hc3 = J(1000,2,.)
mat colnames mat_e_hc3 = ll ul 

//Loop para simulación
quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 100
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

expand 10

reg y x, vce(hc3)

restore
mat mat_e_hc3[`i',1] = r(table)[5,1]
mat mat_e_hc3[`i',2] = r(table)[6,1]
}

mat l mat_e_hc3

* Estimación del modelo (1) usando errores estándar cluster

//Definición de la matriz
mat mat_e_cluster = J(1000,2,.)
mat colnames mat_e_cluster = ll ul 

//Loop para simulación
quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 100
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

gen id = _n

expand 10

reg y x, cl(id)

restore
mat mat_e_cluster[`i',1] = r(table)[5,1]
mat mat_e_cluster[`i',2] = r(table)[6,1]
clear
}

mat l mat_e_cluster

* Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat mat_e_usual
svmat mat_e_hc1
svmat mat_e_hc3
svmat mat_e_cluster
gen in_e_usual = inrange(2, mat_e_usual1, mat_e_usual2)
gen in_e_hc1 = inrange(2, mat_e_hc11, mat_e_hc12)
gen in_e_hc3 = inrange(2, mat_e_hc31, mat_e_hc32)
gen in_e_cluster = inrange(2, mat_e_cluster1, mat_e_cluster2)
sum in_e_usual
sum in_e_hc1
sum in_e_hc3
sum in_e_cluster

* * * * * * * * 
* EJERCICIO F *
* * * * * * * * 

* Estimación con j=5,10,20,50,100,150,200 usando errores estándar cluster

//Loop para definición de la matriz
foreach x in 5 10 20 50 100 150 200 {
	mat mat_f_`x' = J(1000,2,.)
	mat colnames mat_f_`x'= ll_`x' ul_`x'
}

//Loop para simulación
foreach x in 5 10 20 50 100 150 200{
	quietly forvalues i = 1(1)1000 {

preserve
clear
set obs `x'
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

gen id_cluster = _n

expand (1000/`x')

reg y x, cl(id_cluster)

restore
mat mat_f_`x'[`i',1] = r(table)[5,1]
mat mat_f_`x'[`i',2] = r(table)[6,1]
}
}

mat l mat_f_5
mat l mat_f_10
mat l mat_f_20
mat l mat_f_50
mat l mat_f_100
mat l mat_f_150
mat l mat_f_200

* Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

foreach x in 5 10 20 50 100 150 200 {
	svmat mat_f_`x', names(col)
	gen in_f_`x' = inrange(2, ll_`x', ul_`x')
	sum in_f_`x'
}

clear 
input j perc
j perc
5 80.9
10 89.4
20 90.5
50 92.5
100 93.7
150 92.7
200 94.6
 end
 
 scatter perc j, connect(l) ytitle("Porcentaje (%)") xtitle("Tamaño de cluster")

* * * * * * * * 
* EJERCICIO G *
* * * * * * * * 

*i. Cuando hay homocedasticidad

//Definición de la matriz
mat mat_g_i = J(1000,2,.)
mat colnames mat_g_i = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 1000
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

reg y x, vce(bootstrap, reps(100))

restore
mat mat_g_i[`i',1] = r(table)[5,1]
mat mat_g_i[`i',2] = r(table)[6,1]
}

mat l mat_g_i

*ii. Cuando hay heteroscedasticidad

//Definición de la matriz
mat mat_g_ii = J(1000,2,.)
mat colnames mat_g_ii = ll ul 

quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 1000
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,x^2)

gen y = 2*x + u

reg y x, vce(bootstrap, reps(100))

restore
mat mat_g_ii[`i',1] = r(table)[5,1]
mat mat_g_ii[`i',2] = r(table)[6,1]
}

mat l mat_g_ii

*iii. Cuando hay correlación serial

//Definición de la matriz
mat mat_g_iii = J(1000,2,.)
mat colnames mat_g_iii = ll ul 

//Loop para simulación
quietly forvalues i = 1(1)1000 {
preserve
clear
set obs 100
set seed 1989`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

gen y = 2*x + u

expand 10

reg y x, vce(bootstrap, reps(100))

restore
mat mat_g_iii[`i',1] = r(table)[5,1]
mat mat_g_iii[`i',2] = r(table)[6,1]
clear
}

mat l mat_g_iii

* Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat mat_g_i
svmat mat_g_ii
svmat mat_g_iii
gen in_g_i = inrange(2, mat_g_i1, mat_g_i2)
gen in_g_ii = inrange(2, mat_g_ii1, mat_g_ii2)
gen in_g_iii = inrange(2, mat_g_iii1, mat_g_iii2)
sum in_g_i
sum in_g_ii
sum in_g_iii
