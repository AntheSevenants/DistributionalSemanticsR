# DistributionalSemanticsR
Tools for using distributional semantics in R

## What is DistributionalSemanticsR?

DistributionalSemanticsR is a library with which you can easily use distributional semantics datasets. The main idea is that you have a dataset which contains distributional vectors for words, which you can then use to draw your words of choice on a plot. This is done by running dimension reduction on the words' vector values.

DistributionalSemanticsR handles the following aspects of the dataset conversion process:
- retrieving the correct vectors from a distributional semantics dataset
- computing the distance matrix for the words of your choice
- applying dimension reduction on the distance matrix
    - MDS
    - TSNE

The output of these regression fits can be attached to the output of [ElasticToolsR](https://github.com/AntheSevenants/ElasticToolsR).

## Installing DistributionalSemanticsR

DistributionalSemanticsR is not available on the CRAN package manager (yet). To use it, simply copy the scripts from this repository to your R project's directory (preferably using `git clone`). From there, you can simply include the scripts you need. More information on what scripts to import is given below.

## Using DistributionalSemanticsR

### Importing the required scripts

```r
source("VectorSpace.R")
source("DimensionReductionFactory.R")
```
⚠ "VectorSpace.R" and "DimensionReductionFactory.R" should be present in your R script's directory.

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
distributional_coords <- vector_space_$get_distributional_values(list("aap", "huis")
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
