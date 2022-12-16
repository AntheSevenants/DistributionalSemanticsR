library("cluster")
#library("factoextra")

clustering <- setRefClass("Clustering",
                          fields = list(
                            dimension_reduction_technique="character",
                            coords="data.frame"),
                          methods = list(
                            # constructor
                            initialize = function(dimension_reduction_technique, coords) {
                              dimension_reduction_technique <<- dimension_reduction_technique
                              coords <<- coords
                            },
                            
                            do_k_medoids = function(k = 5) {
                              
                            },
                            
                            do_k_means = function(k = 5) {
                              kmeans_done <- kmeans(coords, centers=k, iter.max=25)
                              return(as.numeric(kmeans_done$cluster))
                            },
                            
                            do_k_means_batch = function(k_range) {
                              k_names <- lapply(k_range,
                                                function(k_value) { return(paste0(dimension_reduction_technique,"_k_", k_value)) })
                              k_results <- lapply(k_range,
                                                  function(k_value) { return(do_k_means(k=k_value)) })
                              
                              output <- list("k_range" = k_range,
                                             "k_names" = k_names,
                                             "k_results" = k_results)
                              
                              return(output)
                            }
                                           
))
