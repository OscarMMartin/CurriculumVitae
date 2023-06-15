# 1) Introducción
#    Análisis y Modelo de Regresión del Conjunto de Población Suiza (s. XIX)

install.packages("car")
library(car)
install.packages("lmtest")
library(lmtest)


conjunto_swiss<-swiss
n<-dim(conjunto_swiss)[1]
m<-dim(conjunto_swiss)[2]
poblacion<-c(11.56,163.85,85.62,23.20,23.60,64.48,142.48,134.48,213.42,
             280.53,77.90,186.48, 17.83,18.46,10.41,10.73,17.13,410.76,
             5.68,426.34,40.52,26.08,135.24,19.29,26.44,36.36, 637.62,
             18.31,79.25,62.75,83.63,97.60,65.78,115.35,	101.19, 65.17,
             101.38,99.11,129.85,291.74,112.26,165.65, 90.64,165.49,
             757.09,20.67,23.78)
for(i in 1:n){
  conjunto_swiss[i,]<-conjunto_swiss[i,]*poblacion[i]
}
for(i in 2:m){
  conjunto_swiss[,i]<-round(conjunto_swiss[,i],0)
}
conjunto_swiss

# 2) Estudio y Evaluación del Modelo Completo

summary(conjunto_swiss)
head(conjunto_swiss)

boxplot(conjunto_swiss)
scatterplotMatrix(x=conjunto_swiss)
cor(conjunto_swiss)

Fertility<-conjunto_swiss$Fertility
Agriculture<-conjunto_swiss$Agriculture
Examination<-conjunto_swiss$Examination
Education<-conjunto_swiss$Education
Catholic<-conjunto_swiss$Catholic
Infant<-conjunto_swiss$Infant.Mortality

model<-lm(Fertility~Agriculture+Examination+Education+Catholic+Infant,
          data=conjunto_swiss)
model$coefficients
summary(model)
anova(model)

#3. Selección del mejor modelo. Métodos por pasos y por criterios.

# 3. 1) MÉTODO POR PASOS:

#    Método Fordward

# Paso 1) Realizamos un modelo donde "Fertility" es nuestra
#         variable respuesta:

model.all <- lm(Fertility ~ 
                  Agriculture+Examination+Education+Catholic+
                  Infant.Mortality, data = conjunto_swiss)

# Paso 2) Una vez hecho el modelo completo, vemos si tiene sentido 
#         realizar una selección de variables:

summary(model.all)

# Ahí vemos que hay variables estadísticamente NO significativas,
# por tanto, sí tiene sentido hacer un modelo:

model.inicial <- lm(Fertility~1, data = conjunto_swiss)
summary(model.inicial)$coef

# Tengo que ir añadiendo variables, pero para añadir tengo que generar:
#         SCOPE: Estudia la significación de las variables señaladas.

SCOPE <- (~.~Agriculture+Examination+Education+Catholic+
            Infant.Mortality)

# Añadimos el término al modelo:

add1(model.inicial, scope=SCOPE, test="F")

#   Observación: La F y el p-valor van al contrario. El que tiene la F
#                más grande tiene el p-valor más pequeño.
#   Actualizamos(1) el modelo:  (Infant.Mortality tiene el p-valor más
#                pequeño)

model.update1 <- update(model.inicial, .~.+Infant.Mortality)

summary(model.update1)$coef

#       Añado al modelo actualizado 1:

add1(model.update1,scope=SCOPE, test="F")

#   Actualizamos(2) el modelo: (Examination tiene el p-valor más pequeño)

model.update2 <- update(model.update1, .~.+Examination)

summary(model.update2)$coef

#       Añado al modelo actualizado 2:

add1(model.update2, scope=SCOPE, test="F")

#   Actualizamos(3) el modelo:  (Education tiene el p-valor más pequeño)

model.update3 <- update(model.update2, .~.+Education)

summary(model.update3)$coef

#       Añado al modelo actualizado 3:

add1(model.update3, scope = SCOPE, test = "F")

#   Ya hemos terminado porque ninguno de esos p-valores
#   es menor que 0.05

# 3.2) Métodos basados en criterios

# 3.2.1) R2 ajustado

models<-regsubsets(Fertility~.,data=conjunto_swiss)
summary(models)
MR2adj<-summary(models)$adjr2
MR2adj
which.max(MR2adj)
plot(models,scale="adjr")

# 3.2.2) Cp de Mallows

MCp<-summary(models)$cp
MCp
which.min(MCp)
plot(models,scale="Cp")

# 3.2.3) BIC (Criterio de Información de Bayes)

MBIC<-summary(models)$bic
MBIC
which.min(MBIC)
plot(models,scale="bic")

# 3.2.4) AIC (Criterio de Información de Akaike)

SCOPE<-(~.)
stepAIC(modelo_completo, scope=SCOPE,k=2)


# 4) Diagnóstico

# 4.1) Linealidad, Normalidad y Homocedasticidad

# 4.1.1) Linealidad

cor.test(Fertility, Agriculture)#p-valor:3.406e-12<0.05
cor.test(Fertility,Examination)
cor.test(Fertility,Education)
cor.test(Fertility,Catholic)
cor.test(I)

# La linealidad se produce cuando existe una relacion lineal entre
# las variables explicativas y la variable respuesta.
# Como hemos obtenido un p-valor=2.2e-16<0.05 podemos asegurar que
# existe linealidad.

# 4.1.2) Normalidad

#Vamos a usar el test de Shapiro-Wilk

shapiro.test(resid(modelo_mejor))

# p-valor=0.082338, luego no tenemos evidencias signficativas para
# rechazar las hipotesis nula, es decir los residuos se distribuyen
# normalmente.

qqnorm(modelo_mejor$residuals)
qqline(modelo_mejor$residuals)

# 4.1.3) Homocedasticidad

#Se dice que existe homocedasticidadd cuando la varianza de los errores
# de la regresion es constante.

plot(modelo_mejor,which=1)

# Recurrimos al test de Breusch-Pagan,H0:Hay homocedasticidad,H1=No hay
# homocedasticidad

bptest(modelo_mejor)

# p-valor=0.3467>0.05, , luego aceptamos la hipotesis nula,
# hay homocedasticidad.

# 4.2) Autocorrelación

durbinWatsonTest(bestmodel)

#Como el p-valor es mayor que 0.05 no podemos rechazar la hipótesis nula,
# es decir, no tenemos evidencias significativas

# 4.3) Estudio de Outliers, influyentes y leverage

outlierTest(bestmodel)
plot(outlierTest(bestmodel))
study<-c(37)
conjunto_swiss_sin37<-conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin37$Fertility
Agriculture<-conjunto_swiss_sin37$Agriculture
Examination<-conjunto_swiss_sin37$Examination
Education<-conjunto_swiss_sin37$Education
Catholic<-conjunto_swiss_sin37$Catholic
Infant<-conjunto_swiss_sin37$Infant.Mortality
bestmodel_sin_37<-lm(Fertility~Examination+Education+Infant,
                     data=conjunto_swiss_sin37)

#----------Comprobamos si mejora el modelo al quitar 37--------

#-----AUTOCORRELACIÓN:

durbinWatsonTest(bestmodel_sin_37)

# Como el p-valor es mayor que 0.05 no podemos rechazar la hipótesis
# nula, es decir, no tenemos evidencias significativas de que exista
# correlación entre los residuos.

#--NORMALIDAD:

shapiro.test(resid(bestmodel_sin_37))
qqnorm(bestmodel_sin_37$residuals)
qqline(bestmodel_sin_37$residuals)

# Como el p-valor es mayor que 0.05 no podemos rechazar la hipótesis
# nula, es decir, los residuos se distribuyen normalmente.

#---HOMOCEDASTICIDAD:

install.packages("lmtest")
library(lmtest)

# Se dice que existe homocedasticidadd cuando la varianza de los errores
# de la regresion es constante

plot(bestmodel_sin_37,which=1)

# Recurrimos al test de Breusch-Pagan,H0:Hay homocedasticidad,H1=No
# hay homocedasticidad

bptest(bestmodel_sin_37)

# Como el p-valor<0.05, no hay homocedasticidad. Luego, como el modelo
# empeora nos quedamos con el bestmodel

cooks.distance(bestmodel)
cutoff<-4/(47-4-2) #cota
plot(bestmodel, which=4, cook.levels=cutoff, las=1)

#abline(h=cutoff, lty="dashed", col="dodgerblue2")

influenceIndexPlot(bestmodel, vars="Cook")
install.packages("ggplot2") 
library(ggplot2)

# Como podemos ver las observaciones Paysd'enhaut y V. de Geneve son
# posibles observaciones influyentes, vamos a analizar el comportamiento
# del modelo tras eliminar cada una de ellas

# Comenzamos eliminando la observación V. de Geneve que presenta una
# mayor distancia de Cook

study<-c(45)
conjunto_swiss_sin45 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin45$Fertility
Agriculture<-conjunto_swiss_sin45$Agriculture
Examination<-conjunto_swiss_sin45$Examination
Education<-conjunto_swiss_sin45$Education
Catholic<-conjunto_swiss_sin45$Catholic
Infant<-conjunto_swiss_sin45$Infant.Mortality

posible_modelo_sin45 <- lm(Fertility ~ Examination+Education+Infant,
                           data=conjunto_swiss_sin45)
fmodsin45 <- fortify(posible_modelo_sin45)
X <- model.matrix(posible_modelo_sin45)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))
shapiro.test(resid(posible_modelo_sin45))
qqnorm(posible_modelo_sin45$residuals)
qqline(posible_modelo_sin45$residuals)

plot(posible_modelo_sin45,which=c(1,2))
bptest(posible_modelo_sin45)

durbinWatsonTest(posible_modelo_sin45)

# Como el p-valor del shapiro test es menor que 0,05 no podemos
# eliminar la observación de v. de Geneve

#Veamos eliminando ahora Paysh

study<-c(27)
conjunto_swiss_sin27 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin27$Fertility
Agriculture<-conjunto_swiss_sin27$Agriculture
Examination<-conjunto_swiss_sin27$Examination
Education<-conjunto_swiss_sin27$Education
Catholic<-conjunto_swiss_sin27$Catholic
Infant<-conjunto_swiss_sin27$Infant.Mortality

posible_modelo_sin27 <- lm(Fertility ~ Examination+Education+Infant,
                           data=conjunto_swiss_sin27)
fmodsin45 <- fortify(posible_modelo_sin27)
X <- model.matrix(posible_modelo_sin27)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))
shapiro.test(resid(posible_modelo_sin27))
qqnorm(posible_modelo_sin27$residuals)
qqline(posible_modelo_sin27$residuals)

bptest(posible_modelo_sin27)

plot(posible_modelo_sin27,which=c(1,2))
durbinWatsonTest(posible_modelo_sin27)

# De nuevo, el p-valor del shapiro test es menor que 0.05 y
# decidimos no quitarlo.

# La medida DFFITS es una medidda de influencia

dffits<- dffits(bestmodel)
which(abs(dffits)>2*sqrt(4/47))
fit<-with(conjunto_swiss, bestmodel)
cv<-2*sqrt(4/47)
plot(abs(dffits),ylab="DFFITS estandarizados",xlab="Index",
     main=paste("DFFITS estandarizados"))


abline(h=cv, lty="dashed",col="dodgerblue2")


# Tenemos que analizar el modelo quitandole Lavaux , Sierre,
# Laussane y Aigle.

#Empezamos quitando Lavaux

study<-c(20)
conjunto_swiss_sin20 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin20$Fertility
Agriculture<-conjunto_swiss_sin20$Agriculture
Examination<-conjunto_swiss_sin20$Examination
Education<-conjunto_swiss_sin20$Education
Catholic<-conjunto_swiss_sin20$Catholic
Infant<-conjunto_swiss_sin20$Infant.Mortality

posible_modelo_sin20 <- lm(Fertility ~ Examination+Education+Infant,
                           data=conjunto_swiss_sin20)
fmodsin20 <- fortify(posible_modelo_sin20)
X <- model.matrix(posible_modelo_sin20)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))
shapiro.test(resid(posible_modelo_sin20))
qqnorm(posible_modelo_sin20$residuals)
qqline(posible_modelo_sin20$residuals)

bptest(posible_modelo_sin20)
plot(posible_modelo_sin20,which=c(1,2))
durbinWatsonTest(posible_modelo_sin20)

# como el p-valor de shapiro test es menor que 0.05 no eliminamos Lavaux

# La medida DFBETAS

dfbetas<- dfbetas(bestmodel)
which(abs(dfbetas)>2/sqrt(47))

cv<-2/sqrt(47)
plot(abs(dfbetas),ylab="DFBETAS estandarizados",xlab="Index",
     main=paste("DFBETAS estandarizados"))


abline(h=cv, lty="dashed",col="dodgerblue2")

# Vamos a analizar el modelo quitandole Porrentruy, Gruyere,
# Sarine Sion La chauxdfnd

study<-c(6)
conjunto_swiss_sin6 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin6$Fertility
Agriculture<-conjunto_swiss_sin6$Agriculture
Examination<-conjunto_swiss_sin6$Examination
Education<-conjunto_swiss_sin6$Education
Catholic<-conjunto_swiss_sin6$Catholic
Infant<-conjunto_swiss_sin6$Infant.Mortality

posible_modelo_sin6 <- lm(Fertility ~ Examination+Education+Infant,
                          data=conjunto_swiss_sin6)
fmodsin6 <- fortify(posible_modelo_sin6)
X <- model.matrix(posible_modelo_sin6)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))
shapiro.test(resid(posible_modelo_sin6))
qqnorm(posible_modelo_sin6$residuals)
qqline(posible_modelo_sin6$residuals)

bptest(posible_modelo_sin6)

plot(posible_modelo_sin6,which=c(1,2))
durbinWatsonTest(posible_modelo_sin6)

#Tampoco eliminamos el 6 Porrentruy

study<-c(10)
conjunto_swiss_sin10 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin10$Fertility
Agriculture<-conjunto_swiss_sin10$Agriculture
Examination<-conjunto_swiss_sin10$Examination
Education<-conjunto_swiss_sin10$Education
Catholic<-conjunto_swiss_sin10$Catholic
Infant<-conjunto_swiss_sin10$Infant.Mortality

posible_modelo_sin10 <- lm(Fertility ~ Examination+Education+Infant,
                           data=conjunto_swiss_sin10)
fmodsin6 <- fortify(posible_modelo_sin10)
X <- model.matrix(posible_modelo_sin10)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))
models_sin10<-regsubsets(Fertility~.,data=conjunto_swiss_sin10)
MR2adjsin10<-summary(models_sin10)$adjr2
MR2adjsin10
shapiro.test(resid(posible_modelo_sin10))
qqnorm(posible_modelo_sin10$residuals)
qqline(posible_modelo_sin10$residuals)

bptest(posible_modelo_sin10)

plot(posible_modelo_sin10,which=c(1,2))
durbinWatsonTest(posible_modelo_sin10)

# error cuadratico

anova(modelosin10) #Nos interesa la columna Mean Sq fila Residualsxc 

#Es posible que haya que quitarlo, Sarine

influence.measures(bestmodel)

#Veamos Sierre

study<-c(37)
conjunto_swiss_sin37 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin37$Fertility
Agriculture<-conjunto_swiss_sin37$Agriculture
Examination<-conjunto_swiss_sin37$Examination
Education<-conjunto_swiss_sin37$Education
Catholic<-conjunto_swiss_sin37$Catholic
Infant<-conjunto_swiss_sin37$Infant.Mortality

posible_modelo_sin37 <- lm(Fertility ~ Examination+Education+Infant,
                           data=conjunto_swiss_sin37)
fmodsin6 <- fortify(posible_modelo_sin37)
X <- model.matrix(posible_modelo_sin37)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))

shapiro.test(resid(posible_modelo_sin37))
qqnorm(posible_modelo_sin37$residuals)
qqline(posible_modelo_sin37$residuals)

bptest(posible_modelo_sin37)

plot(posible_modelo_sin37,which=c(1,2))
durbinWatsonTest(posible_modelo_sin37)

#Como el p-valor del bptest es menor que 0.05 no lo eliminamos

study<-c(40)
conjunto_swiss_sin40 <- conjunto_swiss[-study,1:6]
Fertility<-conjunto_swiss_sin40$Fertility
Agriculture<-conjunto_swiss_sin40$Agriculture
Examination<-conjunto_swiss_sin40$Examination
Education<-conjunto_swiss_sin40$Education
Catholic<-conjunto_swiss_sin40$Catholic
Infant<-conjunto_swiss_sin40$Infant.Mortality

posible_modelo_sin40 <- lm(Fertility ~ Examination+Education+Infant,
                           data=conjunto_swiss_sin40)
fmodsin40 <- fortify(posible_modelo_sin40)
X <- model.matrix(posible_modelo_sin40)
H <- X%*%solve(t(X)%*%X)%*%t(X)
sum(diag(H))
models_sin40<-regsubsets(Fertility~.,data=conjunto_swiss_sin40)
MR2adjsin40<-summary(models_sin40)$adjr2
MR2adjsin40
shapiro.test(resid(posible_modelo_sin40))
qqnorm(posible_modelo_sin40$residuals)
qqline(posible_modelo_sin40$residuals)

bptest(posible_modelo_sin40)

plot(posible_modelo_sin40,which=c(1,2))
durbinWatsonTest(posible_modelo_sin40)
anova(modelosin40)
obs_10_40<- c(10,40)
conjunto_swiss_sin10sin40 <-conjunto_swiss[-obs_10_40,1:6]
modelosin10sin40 <- lm(conjunto_swiss_sin10sin40$Fertility~
                         conjunto_swiss_sin10sin40$Examination+
                         conjunto_swiss_sin10sin40$Education+
                         conjunto_swiss_sin10sin40$Infant)

# Hay que comprobar que la suma de los elementos de la diagonal de
# la matriz Hat H=X(X^tX)^-1X^t es igual al número de parametros
# del modelo en nuestro caso hay 4 parametros.

X <- model.matrix(modelosin10sin40)
H <- X%*%solve(t(X)%*%X)%*%t(X)

sum(diag(H)) # =4 que es el número de variables involucradas

#R^2ajustado

models_sin10sin40<-regsubsets(Fertility~.,
                              data=conjunto_swiss_sin10sin40)
MR2adjsin10sin40<-summary(models_sin10sin40)$adjr2
MR2adjsin10sin40[3]
shapiro.test(resid(modelosin10sin40))
qqnorm(modelosin10sin40$residuals)
qqline(modelosin10sin40$residuals)

# Homocedasticidad

plot(modelosin10sin40,which=1)
bptest(modelosin10sin40)

# Autocorrelación

durbinWatsonTest(modelosin10sin40)

# Error cuadrático

anova(modelosin10sin40)
leverage<-hat(model.matrix(modelo_mejor))#37
p<-sum(leverage)

# 4.4) Colinealidad

X <- cbind(rep(1,length(Fertility)), Examination, Education, Infant)
det(t(X)%*%X)


# 5) Calcular el Error de test con CV_(k)

modelo_cv<-lm(Fertility~Agriculture+Examination+Education+Catholic+Infant,
              data=conjunto_swiss)
obs_out<-c(10)
set.seed(5) #semilla
train <- sample (c(TRUE, FALSE), size=nrow(conjunto_swiss[-obs_out,]),
                 replace=TRUE, prob=c(0.7,0.3)) #conjunto de entenamiento
prop.table(table(train))#calcula los percentiles en train
test <- (!train)
prop.table(table(test)) #calcula los percentiles en test
model.exh <- regsubsets(Fertility ~ ., data = conjunto_swiss[train, 1:6],
                        method= "exhaustive")
summary(model.exh) #todos los modelos posibles para los predictores

# Vamos a calcular el error del conjunto de validación para el mejor
# modelo de entre los obtenidos antes

predict.regsubsets <- function(object, newdata, id,...){
  form <-as.formula(object$call[[2]])
  mat <- model.matrix(form,newdata)
  coefi <- coef(object,id=id)
  xvars <- names(coefi)
  mat[,xvars]%*%coefi
}
val.errors <- rep(NA,5)
Y <- conjunto_swiss[test,]$Fertility
for (i in 1:5){
  Yhat <- predict.regsubsets (model.exh,
                              newdata=conjunto_swiss[test,], id=i)
  val.errors[i] <- mean((Y-Yhat)^2)
}
val.errors
coef(model.exh, which.min(val.errors))

# 6) Conclusión

# 6.1) Nuevas observaciones

newdataframe<-data.frame(Fertility=c(13.20,50.30,18.93),
                         Agriculture=c(40.31,52.54,39.99),
                         Education=c(23,2,5),
                         Examination=c(20.11,12.19,20.51),
                         Catholic=c(50.31,36.54,27.89),
                         Infant=c(62.31,21.00,24.70))
newdataframe
summary(newdataframe)
Fertility<-newdataframe$Fertility
Agriculture<-newdataframe$Agriculture
Education<-newdataframe$Education
Examination<-newdataframe$Examination
Catholic<-newdataframe$Catholic
Infant<-newdataframe$Infant.Mortality
newmodel<-lm(Fertility~Agriculture+Education+
               Examination+Catholic+Infant,
             data=newdataframe)

# Calculamos los intervalos de Confianza al 95%

g<-3
alpha<-0.05
Tstudentfunction<-qt(1-alpha/(2*g),46)
RES<-predict(bestmodel_sin_10,newdata=newdataframe,se.fit=TRUE)
Yhat<-((RES$fit/2)+1)^2
S_yhat<-RES$se.fit
IntervConfInf<-(Yhat-Tstudentfunction*S_yhat)
IntervConfSup<-(Yhat+Tstudentfunction*S_yhat)
Bestconfidenceinterval<-cbind(Yhat,S_yhat,
                              IntervConfInf,
                              IntervConfSup)
Bestconfidenceinterval