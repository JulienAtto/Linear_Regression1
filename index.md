---
title: "Simple Linear Regression"
author: "Esse Julien Atto"
output: 
  html_document:
    code_folding: hide
    keep_md: true
    toc: true 
    toc_depth: 2 
    toc_float: true 
    number_sections: true  
    theme: united
    highlight: espresso
---






```r
#loading libraries to use
library(dplyr)
library(datasets) #for cars data
library(ggplot2)
```

Simple linear regression is a statistical method for finding a linear relationship between an explanatory variable $X$ and a variable to be explained $y$:
\[y= \theta_0 + \theta_1 X.\]

# Data preparation and visualisation

```r
#Loading car data

data(cars)
```

The data **cars** in R package **datasets** give the speed of cars and the distances taken to stop, and  were recorded in the 1920s.

##  Visualization of 10 rows chosen randomly among the 50 observations

```r
set.seed(1234)
cars[sample(1:50,10),]
```

```
##    speed dist
## 28    16   40
## 16    13   26
## 22    14   60
## 37    19   46
## 44    22   66
## 9     10   34
## 5      8   16
## 38    19   68
## 49    24  120
## 4      7   22
```


## Graph

```r
# Plot Data
plt<-cars%>%
  ggplot(aes(x = speed, y = dist)) +
  geom_point(colour="red") +
  xlab("Speed (mph)") +
  ylab("Stopping distance (feet)") +
  ggtitle("Speed and Stopping Distances of Cars")

plt
```

![](index_files/figure-html/graph-1.png)<!-- -->

# Linear regresson using Gradient Descent
## Computation of the parameters

```r
#X and y
X<-cars$speed
y=cars$dist

# initializing fitting parameters
theta = cbind(numeric(2)) 

#loading  some functions... 
source("myfunctions.R")

##############################################################
  # Running Gradient Descent and plotting cost as function of number of iterations for some values of the learning rate.

  ALPHA<-c(0.3,0.1,0.03,0.01)
  COL<-c("red","blue","green","yellow")
  nb_iter<-NULL #initialiation of vector containing number of iterations for each value of alpha
  out<-list()
  Cost_by_iter<-list()

  for(i in 1:length(ALPHA)){
    # Initializing  theta and running Gradient Descent 
    theta = matrix(0,2)
    Grad_Desc<- Grad_Desc_fct(X, y, theta, alpha = ALPHA[i], max_iter=10000)
    theta<-Grad_Desc$theta
    Cost_by_iter[[i]]<-Grad_Desc$Cost_by_iter
    nb_iter=append(nb_iter,Grad_Desc$nb_iter)
    out[[i]]<-theta
    } # end of for(i in 1:length(ALPHA))
```

```
## [1] "alpha= 0.3 : Convergence realized after 53  iterations."
## [1] "alpha= 0.1 : Convergence realized after 169  iterations."
## [1] "alpha= 0.03 : Convergence realized after 544  iterations."
## [1] "alpha= 0.01 : Convergence realized after 1538  iterations."
```

```r
    # Plot the convergence graph for different values of alpha
      plot(1:nrow(Cost_by_iter[[1]]), Cost_by_iter[[1]], type="l",lwd=2,xlab='Number of iterations',ylab='Cost',col=COL[1],
           main=expression(paste("Convergence of Gradient Descent for a given learning rate ",alpha,".")),xlim = c(0,min(max(nb_iter),400)))
      
    for(i in 2:length(ALPHA)){
      lines(1:nrow(Cost_by_iter[[i]]), Cost_by_iter[[i]], type="l",lwd=2,col=COL[i])
    }
  
  
  legend("topright", 
         legend =sapply(ALPHA, function(.) as.expression(bquote(alpha==.(.)))),
         lwd = 2, cex = 1.2, col = COL, lty = rep(1,4))
```

![](index_files/figure-html/GD_and_plots-1.png)<!-- -->




If we choose $\alpha=0.01$, then we have:


\[\theta=\begin{pmatrix} -17.5790872\\3.9324077 \end{pmatrix}\]

## Plotting the linear fit

```r
#Plot the linear fit

plt+geom_abline(intercept = theta[1], slope = theta[2], color="blue", 
               size=1.5)
```

![](index_files/figure-html/plot_fit-1.png)<!-- -->

## Predictions
* **Predict stopping distance for a speed of 21 mph**:

```r
dist_for_21 = c(c(1, 21)%*%theta)
```

$\qquad\quad$For speed = 21 mph (33.8 km/h), we predict a stopping distance of  **65** feet (**19.81** m).

\
&nbsp;

* **Predict stopping distance for a  speed of 30 mph**:

```r
dist_for_30 =c( c(1, 30)%*%theta)
```

$\qquad\quad$For speed = 30 mph (48.28 km/h), we predict a stopping distance of  **100.39** feet (**30.6** m).

# Simple Linear Regression using lm() function of R (Normal equation)

\[\theta=(X^TX)^{-1}X^Ty.\]


```r
model_lm<-lm(dist~speed,data = cars)

model_lm
```

```
## 
## Call:
## lm(formula = dist ~ speed, data = cars)
## 
## Coefficients:
## (Intercept)        speed  
##     -17.579        3.932
```

We can see that the values of the fitted parameters are $\hat{\theta_0}=-17.579$ and $\hat{\theta_1}=3.932$.

## Summary of the model

```r
summary(model_lm)
```

```
## 
## Call:
## lm(formula = dist ~ speed, data = cars)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -29.069  -9.525  -2.272   9.215  43.201 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -17.5791     6.7584  -2.601   0.0123 *  
## speed         3.9324     0.4155   9.464 1.49e-12 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 15.38 on 48 degrees of freedom
## Multiple R-squared:  0.6511,	Adjusted R-squared:  0.6438 
## F-statistic: 89.57 on 1 and 48 DF,  p-value: 1.49e-12
```


## Predictions
* **Predict stopping distance for a speed of 21 mph**:

```r
dist_for_21_ =predict.lm(model_lm,data.frame(speed=21))
```

$\qquad\quad$For speed = 21 mph (33.8 km/h), we predict a stopping distance of  **65** feet (**19.81** m).

* **Predict stopping distance for a speed of 30 mph**:

```r
dist_for_30_ =predict.lm(model_lm,data.frame(speed=30))
```

$\qquad\quad$For speed = 30 mph (48.28 km/h), we predict a stopping distance of  **100.39** feet (**30.6** m).
