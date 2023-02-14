library("cluster")
library("dbscan")
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
                            
                            generate_names = function(value_range,
                                                      clustering_algorithm) {
                              k_names <- lapply(value_range,
                              function(value) { 
                                return(paste0("cluster.",
                                              dimension_reduction_technique,
                                              ".",
                                              clustering_algorithm,
                                              "_k_", value)) })
                              
                              return(k_names)
                            },
                            
                            do_k_medoids = function(k = 5) {
                              
                            },
                            
                            do_k_means = function(k = 5) {
                              kmeans_done <- kmeans(coords, centers=k, iter.max=25)
                              return(as.numeric(kmeans_done$cluster))
                            },
                            
                            do_k_means_batch = function(k_range) {
                              # Filter for valid k ranges
                              k_range <- k_range[k_range <= nrow(coords) - 1 &
                                                 k_range >= 1]
                                                            
                              k_names <- generate_names(k_range, "kmeans")
                              k_results <- lapply(k_range,
                                                  function(k_value) { return(do_k_means(k=k_value)) })
                              
                              output <- list("k_range" = k_range,
                                             "k_names" = k_names,
                                             "k_results" = k_results)
                              
                              return(output)
                            },
                            
                            do_dbscan = function(min_neighbourhood=5) {
                              dbscan_done <- dbscan(coords, minPts = min_neighbourhood, eps=0.8)
                              clusters <- as.numeric(dbscan_done$cluster)
                              clusters <- lapply(clusters,
                                                 function(x) ifelse(x==0,NA,x))
                              return(clusters)
                            },
                            
                            do_dbscan_batch = function(neighbourhood_range) {
                              k_names <- generate_names(neighbourhood_range, "dbscan")
                              k_results <- lapply(neighbourhood_range,
                                function(k_value) { 
                                  return(do_dbscan(min_neighbourhood=k_value)) })
                              
                              output <- list("k_range" = neighbourhood_range,
                                             "k_names" = k_names,
                                             "k_results" = k_results)
                              
                              return(output)
                            }
                                           
))
