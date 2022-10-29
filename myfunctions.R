###################################################
#Cost function for simple linear regression
Cost_fct<-function(X, y, theta){
  # X: independant variable
  # y: dependant variable
  # theta: parameters
  #####
  return( sum((X%*%theta-y)^2)/(2*(nrow(X))) )
  
  
}

################################################################
# Gradient Descent function
Grad_Desc_fct<-function(X, y, theta, alpha, max_iter,tol=1e-7){
  #X: independant variable
  #y: dependant variable
  #theta: parameters
  #alpha: learning rate
  #max_iter: maximum number of iterations
  #tol: Convergence tolerance, when the change resulting from an iteration is smaller than tol, the iterations are terminated (=1e-7 by default)
  ####
  # initialisation of vector of cost by iteration
  Cost_by_iter<- NULL# will be a vector of length nb_iter (nb_iter=number of iterations)
  #Normalizing X/ features scale (centered,scaled)
  Xmusig<-scale(X,center=TRUE,scale = TRUE)
  X_norm=labelled::remove_attributes(Xmusig,c("scaled:center","scaled:scale"))
  #mu and sigma
  mu=rbind(attr(Xmusig,which = "scaled:center"))
  sigma=rbind(attr(Xmusig,which = "scaled:scale"))
  # Adding  a column of ones to X normalized
  X_norm = cbind(1, X_norm,deparse.level = 0) 
  colnames(X)<-NULL
  ###
  nb_iter<-0
  while ((nb_iter<max_iter) & dist(rbind(0,c((alpha/nrow(X_norm))*t(t(X_norm%*%theta-y)%*%X_norm))))>tol) {
    theta<-theta-(alpha/nrow(X_norm))*t(t(X_norm%*%theta-y)%*%X_norm)
    Cost_by_iter <- rbind(Cost_by_iter,Cost_fct(X_norm, y, theta))
    nb_iter<-nb_iter+1
  }
  
    if(nb_iter==max_iter & dist(rbind(0,c((alpha/nrow(X_norm))*t(t(X_norm%*%theta-y)%*%X_norm))))>tol){
      stop(paste("No convergence after ",max_iter," iterations!",sep = ""))
    }else{
    theta[1]<-theta[1]-sum(theta[-1]*mu/sigma)
    theta[-1]<-theta[-1]/sigma
    print(paste("alpha=",alpha,": Convergence realized after",nb_iter," iterations."))
    return(list(Cost_by_iter=Cost_by_iter,theta=cbind(theta),nb_iter=nb_iter))
    }
}
########################################################################



