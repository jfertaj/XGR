% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xDAGpropagate.r
\name{xDAGpropagate}
\alias{xDAGpropagate}
\title{Function to generate a subgraph of a direct acyclic graph (DAG) propagaged by the input annotation data}
\usage{
xDAGpropagate(g, annotation, path.mode = c("all_paths",
"shortest_paths",
"all_shortest_paths"), propagation = c("all", "min", "max"),
verbose = TRUE)
}
\arguments{
\item{g}{an object of class "igraph" to represent DAG}

\item{annotation}{the vertices/nodes for which annotation data are
provided. It can be a sparse Matrix of class "dgCMatrix" (with
variants/genes as rows and terms as columns), or a data frame with
three columns: 1st column for variants/genes, 2nd column for terms, and
3rd column for values, or a list (with the name for terms) each element
storing a named vactor (that is, value for the content and
variants/genes as names)}

\item{path.mode}{the mode of paths induced by vertices/nodes with input
annotation data. It can be "all_paths" for all possible paths to the
root, "shortest_paths" for only one path to the root (for each node in
query), "all_shortest_paths" for all shortest paths to the root (i.e.
for each node, find all shortest paths with the equal lengths)}

\item{propagation}{how to propagate the score. It can be "max" for
retaining the maximum value from its children, "min" for retaining the
minimum value from its children, and 'all' for retaining all from its
children (by default)}

\item{verbose}{logical to indicate whether the messages will be
displayed in the screen. By default, it sets to true for display}
}
\value{
\itemize{
\item{\code{subg}: an induced/propagated subgraph, an object of class
"igraph". In addition to the original attributes to nodes and edges,
the return subgraph is also appended by two node attributes: 1) "anno"
containing a list of variants/genes (with numeric values as elements);
2) "IC" standing for information content defined as negative 10-based
log-transformed frequency of variants/genes annotated to that term.}
}
}
\description{
\code{xDAGpropagate} is supposed to produce a subgraph induced by the
input annotation data, given a direct acyclic graph (DAG; an ontology).
The input is a graph of "igraph", a list of the vertices containing
annotation data, and the mode defining the paths to the root of DAG.
The annotations are propagated to the ontology root (eg, retaining the
minmum pvalue). The propagaged subgraph contains vertices (with
annotation data) and their ancestors along with the defined paths to
the root of DAG. The annotations at these vertices (including their
ancestors) can also be updated according to the true-path rule: those
annotated to a term should also be annotated by its all ancestor terms.
}
\note{
For the mode "shortest_paths", the induced subgraph is the most
concise, and thus informative for visualisation when there are many
nodes in query, while the mode "all_paths" results in the complete
subgraph.
}
\examples{
\dontrun{
# Load the library
library(XGR)
}

RData.location <- "http://galahad.well.ox.ac.uk/bigdata_dev"
\dontrun{
# 1) EF ontology
# ig.EF (an object of class "igraph" storing as a directed graph)
ig <- xRDataLoader('ig.EF', RData.location=RData.location)
## optional: extract the disease part (EFO:0000408)
neighs.out <- igraph::neighborhood(ig, order=vcount(ig),
nodes='EFO:0000408', mode="out")
vids <- V(ig)[unique(unlist(neighs.out))]$name
g <- igraph::induced.subgraph(ig, vids=vids)

################
# 2a) load GWAS SNPs annotated by EF (an object of class "dgCMatrix" storing a sparse matrix)
annotation <- xRDataLoader(RData='GWAS2EF',
RData.location=RData.location)
## only significant
annotation[as.matrix(annotation>5e-8)] <- 0

# 2b) propagation based on shortest paths (ie the most concise subgraph)
dag <- xDAGpropagate(g, annotation, path.mode="shortest_paths",
propagation="min")

# 2c) color-code nodes/terms according to the number of annotations
data <- sapply(V(dag)$anno, length)
names(data) <- V(dag)$name
## only those GWAS>=100
nodes <- V(dag)$name[data>=100]
dagg <- igraph::induced.subgraph(dag, vids=nodes)
### DAG plot
dnet::visDAG(dagg, data, node.info="both")
### Net plot
set.seed(825); glayout <- layout_with_kk(dagg)
xVisNet(dagg, pattern=data, colormap="yr", glayout=glayout,
vertex.label=V(dagg)$term_name, vertex.shape="sphere",
vertex.label.font=2, vertex.label.dist=0.2, vertex.label.cex=0.5,
zlim=c(100,300))
### interpolation plot
set.seed(825); glayout <- layout_with_kk(dagg)
pattern <- sapply(V(dagg)$anno, length)
ls_xyz <- data.frame(x=glayout[,1], y=glayout[,2], z=log10(pattern))
xVisInterp(ls_xyz, nD="auto", image=TRUE)

################
3a) load ChEMBL targets annotated by EF (an object of class "dgCMatrix"
storing a sparse matrix)
annotation <- xRDataLoader(RData='Target2EF',
RData.location=RData.location)
## only approved (phase=4)
annotation[as.matrix(annotation<4)] <- 0

3b) propagation based on all paths
dag <- xDAGpropagate(g, annotation, path.mode="all_paths",
propagation="max")

3c) color-code nodes/terms according to the number of annotations
data <- sapply(V(dag)$anno, length)
names(data) <- V(dag)$name
## only those Targets>=50
nodes <- V(dag)$name[data>=50]
dagg <- igraph::induced.subgraph(dag, vids=nodes)
### DAG plot
dnet::visDAG(dagg, data, node.info="both")
### Net plot
set.seed(825); glayout <- layout_with_kk(dagg)
xVisNet(dagg, pattern=data, colormap="yr", glayout=glayout,
vertex.label=V(dagg)$term_name, vertex.shape="sphere",
vertex.label.font=2, vertex.label.dist=0.2, vertex.label.cex=0.5,
zlim=c(50,300))
### interpolation plot
set.seed(825); glayout <- layout_with_kk(dagg)
pattern <- sapply(V(dagg)$anno, length)
ls_xyz <- data.frame(x=glayout[,1], y=glayout[,2], z=log10(pattern))
xVisInterp(ls_xyz, nD="3D", contour=TRUE)
}
}
\seealso{
\code{\link{xRDataLoader}}
}
