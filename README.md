# DistributionalSemanticsR
Tools for using distributional semantics in R

## What is DistributionalSemanticsR?

DistributionalSemanticsR is a library with which you can easily use distributional semantics datasets. The main idea is that you have a dataset which contains distributional vectors for words, which you can then use to draw your words of choice on a plot. This is done by running dimension reduction on the words' vector values.

DistributionalSemanticsR handles the following aspects of the dataset conversion process:
- retrieving the correct vectors from a distributional semantics dataset
- computing the distance matrix for the words of your choice
- applying dimension reduction on the distance matrix using the following techniques:
    - MDS
    - TSNE
    - UMAP
- computing data point clusters using the following techniques:
    - k means
    - dbscan

The output of these regression fits can be attached to the output of [ElasticToolsR](https://github.com/AntheSevenants/ElasticToolsR).

## Installing DistributionalSemanticsR

DistributionalSemanticsR is not available on the CRAN package manager (yet). To use it, simply copy the scripts from this repository to your R project's directory (preferably using `git clone`). From there, you can simply include the scripts you need. More information on what scripts to import is given below.

## Using DistributionalSemanticsR

### Importing the required scripts

```r
source("VectorSpace.R")
source("DimensionReductionFactory.R")
source("Clustering.R")
```
⚠ "VectorSpace.R", "DimensionReductionFactory.R" and "Clustering.R" should be present in your R script's directory.

### Vector space

#### Defining a vector space

If you want to retrieve distributional vectors from a distributional dataset, you first have to define a VectorSpace instance. The constructor for the VectorSpace class takes the following arguments:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `space` | array | a matrix of size $rows \times vector dimensions$ containing all distributional semantics vectors; rows must be named! | / |

E.g., to load a [snaut](http://meshugga.ugent.be/snaut/) dataset:
```r
vector_space_ <- vector_space(space=as.matrix(read.table(gzfile('dutch.gz'),
                                                         sep=' ',
                                                         row.names=1,
                                                         skip = 3)))
```

#### Building your own distributional matrix

Now, we want to create our own matrix with dimensions $number of words \times vector dimensions$. Use the `get_distributional_values` method. This will return an R matrix. There is one argument:


| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `words` | list(character) | the list of words you want to get distributional values for | `list("aap", "huis")` |

```r
distributional_coords <- vector_space_$get_distributional_values(list("aap", "huis"))
```
### Dimension reduction

#### Defining a dimension reduction factory

With your distributional coordinates collected, you can now define a DimensionReductionFactory instance. This factory will produce all your dimension reduced coordinates! The constructor for the DimensionReductionFactory class takes one argument:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `distributional_coords` | matrix | the matrix containing the vectors for your words | / |

```r
dim_reduce <- dimension_reduction_factory(distributional_coords)
```

#### Running MDS

To run MDS, simply run `$do_mds()` on your dimension reduction factory. The method will return a dataframe with two columns: `mds_x` and `mds_y`.

```r
coords.mds <- dim_reduce$do_mds()
```

#### Running TSNE

To run TSNE, simply run `$do_tsne()` on your dimension reduction factory. The method will return a dataframe with two columns: `tsne_x` and `tsne_y`.

```r
coords.tsne <- dim_reduce$do_tsne()
```


#### Running UMAP

To run UMAP, simply run `$do_umap()` on your dimension reduction factory. The method will return a dataframe with two columns: `umap_x` and `umap_y`.

```r
coords.umap <- dim_reduce$do_umap()
```
### Clustering

#### Defining a Clustering instance

Once your distributional coordinates have undergone dimension reduction, you can apply a clustering algorithm to sort the data points into clusters. You can do this by defining a Clustering instance. The constructor for the Clustering class takes two arguments:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `dimension_reduction_technique` | character | the name of the dimension reduction technique you are using (will be used for column names) | `"mds"` |
| coords | data.frame | a dataframe containing your coordinates; columns naming scheme: `"mds.x"`, `"mds.y"` | / | 

```r
clustering_ <- clustering("mds", coords.mds)
```

#### Running k means

To run k means on your coordinates, run `$do_k_means` on the clustering instance. It will return a list of indicies corresponding to the respective clusters of your data points. The method has one argument:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `k` | number | the number of desired clusters | `5` |

```r
clusters.mds <- clustering_$do_k_means(5)
```

##### Running k means in batch

You can also try a number of different k values in one go. To do this, run `$do_k_means_batch` with a vector of k values you want to try:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `k_range` | vector | a vector of *k* values you want to try | `1:10` |

```r
clusters.batch.mds <- clustering_$do_k_means_batch(1:10)
```

The function will return a named list with the following values:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `k_range` | vector | a vector of *k* values tried | `1:10` |
| `k_names` | vector | a vector of column names for the *k* values tried | `c("cluster.mds.kmeans_k_2", ...)` |
| `k_results` | vector | a vector of vectors containing the clustering information output from `$do_k_means` | / |

#### Running dbscan

To run dbscan on your coordinates, run `$do_dbscan` on the clustering instance. It will return a list of indicies corresponding to the respective clusters of your data points. The method has one argument:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `min_neighbourhood` | number | the minimum neighbourhood for the dbscan procedure | `5` |

```r
clusters.mds <- clustering_$do_dbscan(5)
```

##### Running dbscan in batch

You can also try a number of different neighbourhood values in one go. To do this, run `$do_dbscan_batch` with a vector of neighbourhood values you want to try:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `neighbourhood_range` | vector | a vector of neighbourhood values you want to try | `2:10` |

```r
clusters.batch.mds <- clustering_$do_dbscan_batch(2:10)
```

The function will return a named list with the following values:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `k_range` | vector | a vector of neighbourhood values tried | `2:10` |
| `k_names` | vector | a vector of column names for the neighbourhood values tried | `c("cluster.mds.dbscan_k_2", ...)` |
| `k_results` | vector | a vector of vectors containing the clustering information output from `$do_dbscan` | / |

⚠ The names of the named list are taken from the k means method in order to guarantee compatibility across clustering mechanisms.