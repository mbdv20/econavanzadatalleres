*Taller 1: Punto 3

clear all
cap log close
set more off
cls

cd "/Users/andresmolano/Desktop/Econometría Avanzada/Taller 1"

* * * * * * * * 
* EJERCICIO A *
* * * * * * * * 

* i. Simulación

quietly forvalues i = 1(1)1000 {
set obs 1000
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

clear
}

* ii. Estimación del modelo (1) bajo el supuesto de homocedasticidad

//Definición de la matriz
mat MAT_IC = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 1000
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x

mat MAT_IC[`i',1] = r(table)[5,1]
mat MAT_IC[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_IC = "LI" "LS"
mat l MAT_IC

* iii. Estimación del modelo usando errores estándar robustos (hc1)

//Definición de la matriz
mat MAT_ICR = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 1000
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x, r

mat MAT_ICR[`i',1] = r(table)[5,1]
mat MAT_ICR[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_ICR = "LI" "LS"
mat l MAT_ICR

*iv. Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat MAT_IC
svmat MAT_ICR
gen IN_IC = inrange(2, MAT_IC1, MAT_IC2)
gen IN_ICR = inrange(2, MAT_ICR1, MAT_ICR2)
sum IN_IC
sum IN_ICR


* * * * * * * * 
* EJERCICIO B *
* * * * * * * * 

* Estimación del modelo (1) bajo el supuesto de homocedasticidad

//Definición de la matriz
mat MAT_IC20 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x

mat MAT_IC20[`i',1] = r(table)[5,1]
mat MAT_IC20[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_IC20 = "LI" "LS"
mat l MAT_IC20

* Estimación del modelo usando errores estándar robustos (hc1)

//Definición de la matriz
mat MAT_ICR20 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x, r

mat MAT_ICR20[`i',1] = r(table)[5,1]
mat MAT_ICR20[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_ICR20 = "LI" "LS"
mat l MAT_ICR20

*Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat MAT_IC20
svmat MAT_ICR20
gen IN_IC20 = inrange(2, MAT_IC201, MAT_IC202)
gen IN_ICR20 = inrange(2, MAT_ICR201, MAT_ICR202)
sum IN_IC20
sum IN_ICR20


* * * * * * * * 
* EJERCICIO C *
* * * * * * * * 

* Estimación del modelo (1) bajo el supuesto de homocedasticidad

//Definición de la matriz
mat MAT_IC20 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x

mat MAT_HC1[`i',1] = r(table)[5,1]
mat MAT_HC1[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_IC20 = "LI" "LS"
mat l MAT_IC20

* Estimación del modelo (1) usando errores estándar robustos (hc3)

//Definición de la matriz
mat MAT_HC3 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = rnormal(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x, vce(hc3)

mat MAT_HC3[`i',1] = r(table)[5,1]
mat MAT_HC3[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_HC3 = "LI" "LS"
mat l MAT_HC3

* Cálculo del porcentaje de veces que el parámetro verdadero se encuentra dentro de los inveralos de confianza

svmat MAT_IC20
svmat MAT_HC3
gen IN_IC20 = inrange(2, MAT_IC201, MAT_IC202)
gen IN_HC3 = inrange(2, MAT_HC31, MAT_HC32)
sum IN_IC20
sum IN_HC3


* * * * * * * * 
* EJERCICIO D * Preguntar lo de chi2
* * * * * * * * 

* Estimación del modelo (1) usando errores estándar usuales

//Definición de la matriz
mat MAT_CHI2 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = chi2(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x

mat MAT_CHI2[`i',1] = r(table)[5,1]
mat MAT_CHI2[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_CHI2 = "LI" "LS"
mat l MAT_CHI2

* Estimación del modelo (1) usando errores estándar robustos (hc1)

//Definición de la matriz
mat MAT_HC1 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = chi2(0,1)

local beta = 2

gen y = x*`beta' + u

reg y x, r

mat MAT_HC1[`i',1] = r(table)[5,1]
mat MAT_HC1[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_HC1 = "LI" "LS"
mat l MAT_HC1

* Estimación del modelo (1) usando errores estándar robustos (hc3)

//Definición de la matriz
mat MAT_HC3 = J(1000,2,.)

quietly forvalues i = 1(1)1000 {
set obs 20
set seed 14`i'

gen x = rnormal(0,1)
gen u = rchi2(0)

local beta = 2

gen y = x*`beta' + u

reg y x, r

mat MAT_HC3[`i',1] = r(table)[5,1]
mat MAT_HC3[`i',2] = r(table)[6,1]
clear
}

mat colnames MAT_HC3 = "LI" "LS"
mat l MAT_HC3


* * * * * * * * 
* EJERCICIO E *
* * * * * * * * 

* PREGUNTAR: Simular las primeras 100 observaciones de cada una de las muestras o simular 100 muestras de las 1000? ¿Cómo se hace esa mondá?
