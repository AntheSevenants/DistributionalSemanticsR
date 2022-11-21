library(methods)
library(vegan)
library(Rtsne)

dimension_reduction_factory <- setRefClass("DimensionReductionFactory",
                                           fields = list(
                                              distributional_coords="matrix",
                                              distance_matrix="matrix"),
                                           methods = list(
                                              # constructor
                                              initialize = function(distributional_coords) {
                                                distributional_coords <<- distributional_coords
                                                distance_matrix <<- get_distance_matrix()
                                              },
                                              
                                              get_distance_matrix = function() {
                                                distance_matrix_ <- dist(distributional_coords, method="euclidean", diag=T, upper=T)
                                                distance_matrix_ <- as.matrix(distance_matrix_)
                                                return(distance_matrix_)
                                              },
                                              
                                              do_mds = function() {
                                                coordinates <- metaMDS(distance_matrix, k=2, parallel=numCores)$points
                                                coordinates <- as.data.frame(coordinates)
                                                colnames(coordinates) <- c("mds_x", "mds_y")
                                                
                                                return(coordinates)
                                              },
                                              
                                              do_tsne = function() {
                                                coordinates <- Rtsne(distance_matrix, is_distance=TRUE)$Y
                                                coordinates <- as.data.frame(coordinates)
                                                colnames(coordinates) <- c("tsne_x", "tsne_y")
                                                
                                                return(coordinates)
                                              }
))
