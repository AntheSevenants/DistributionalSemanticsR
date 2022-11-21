library(methods)
library(vegan)
library(Rtsne)

distributional_semantics <- setRefClass("DistributionalSemantics", fields = list(
                                    vector_space="array"),
                                  methods = list(
                                    # constructor
                                    initialize = function(vector_space) {
                                      vector_space <<- vector_space
                                    },
                                    
                                    # Get distributional values
                                    get_distributional_values = function(words) {
                                      if (!is.character((words))) {
                                        stop("Supplied words list is not of type 'character'")
                                      }
                                      
                                      distributional_coords <- lapply(words,
                                                                      function(feature) {
                                                                        if(feature %in% rownames(vector_space)) {
                                                                          return(vector_space[feature,])
                                                                        } else {
                                                                          return(rep(0, dim(vector_space)[2]))
                                                                        } })
                                      distributional_coords <- do.call("cbind", distributional_coords)
                                      distributional_coords <- t(distributional_coords)
                                      
                                      return(distributional_coords)
                                    }
                                  ))
