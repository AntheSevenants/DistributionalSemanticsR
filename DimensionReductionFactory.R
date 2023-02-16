library(methods)
library(vegan)
library(Rtsne)
library(umap)
library(parallel)

if (Sys.info()['sysname'] == "Windows") {
  numCores <- 1
} else {
  numCores <- detectCores()
  numCores
}

dimension_reduction_factory <- setRefClass("DimensionReductionFactory",
                                           fields = list(
                                              distributional_coords="matrix",
                                              distance_matrix="matrix"),
                                           methods = list(
                                              # constructor
                                              initialize = function(distributional_coords, distance_matrix=NULL) {
                                                if (is.null(distance_matrix)) {
                                                  distributional_coords <<- distributional_coords
                                                  distance_matrix <<- get_distance_matrix()
                                                } else {
                                                  distance_matrix <<- distance_matrix
                                                }
                                              },
                                              
                                              get_distance_matrix = function() {
                                                distance_matrix_ <- dist(distributional_coords, method="euclidean", diag=T, upper=T)
                                                distance_matrix_ <- as.matrix(distance_matrix_)
                                                return(distance_matrix_)
                                              },
                                              
                                              do_mds = function() {
                                                # If the distance matrix is very large, we get OOM issues
                                                # So, decide on cores dynamically
                                                # MDS absolutely GOBBLES memory so I have to be very conservative
                                                cores_to_use <- numCores
                                                if (dim(distance_matrix)[1] > 1000) {
                                                  cores_to_use <- numCores / 4
                                                }
                                                
                                                coordinates <- metaMDS(distance_matrix, k=2, parallel=cores_to_use)$points
                                                coordinates <- as.data.frame(coordinates)
                                                colnames(coordinates) <- c("mds_x", "mds_y")
                                                
                                                return(coordinates)
                                              },
                                              
                                              do_tsne = function() {
                                                coordinates <- Rtsne(distance_matrix, is_distance=TRUE)$Y
                                                coordinates <- as.data.frame(coordinates)
                                                colnames(coordinates) <- c("tsne_x", "tsne_y")
                                                
                                                return(coordinates)
                                              },
                                              
                                              do_umap = function() {
                                                coordinates <- umap(distributional_coords)$layout
                                                coordinates <- as.data.frame(coordinates)
                                                colnames(coordinates) <- c("umap_x", "umap_y")
                                                
                                                return(coordinates)
                                              }
))
