library(methods)

vector_space <- setRefClass("VectorSpace", fields = list(
                                    space="array"),
                                  methods = list(
                                    # constructor
                                    initialize = function(space) {
                                      space <<- space
                                    },
                                    
                                    # Get distributional values
                                    get_distributional_values = function(words) {
                                      if (!is.character((words))) {
                                        stop("Supplied words list is not of type 'character'")
                                      }
                                      
                                      distributional_coords <- lapply(words,
                                                                      function(feature) {
                                                                        if(feature %in% rownames(space)) {
                                                                          return(space[feature,])
                                                                        } else {
                                                                          return(rep(0, dim(space)[2]))
                                                                        } })
                                      distributional_coords <- do.call("cbind", distributional_coords)
                                      distributional_coords <- t(distributional_coords)
                                      rownames(distributional_coords) <- words
                                      
                                      return(distributional_coords)
                                    }
                                  ))
