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
Grad_Desc_fct<-function(X, y, theta, alpha, nb_iter){
  #X: independant variable
  #y: dependant variable
  #theta: parameters
  #alpha: learning rate
  #nb_iter: number of iterations
  ####
  # initialisation of vector of cost by iteration
  Cost_by_iter<- matrix(0,nb_iter) # matrix nb_iter X 1
  # Adding  a column of ones to X
  X = cbind(1, X,deparse.level = 0) 
  colnames(X)<-NULL
  ###
  for (i in 1:nb_iter) {
    theta<-theta-(alpha/nrow(X))*t(t(X%*%theta-y)%*%X)
    
    Cost_by_iter[i] <- Cost_fct(X, y, theta)
    
  }
  
  return(list(Cost_by_iter=Cost_by_iter,theta=cbind(theta)))
}
########################################################################



