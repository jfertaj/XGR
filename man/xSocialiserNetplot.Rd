% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xSocialiserNetplot.r
\name{xSocialiserNetplot}
\alias{xSocialiserNetplot}
\title{Function to visualise terms used to annotate an input SNP or gene using different network layouts}
\usage{
xSocialiserNetplot(g, query, displayBy = c("IC", "none"),
path.mode = c("all_paths", "shortest_paths", "all_shortest_paths"),
node.info = c("none", "term_id", "term_name", "both",
"full_term_name"),
wrap.width = 15, colormap = c("yr", "jet", "gbr", "wyr", "br", "bwr",
"rainbow", "wb"), ncolors = 40, zlim = NULL, colorbar = T,
newpage = T, glayout = layout_as_tree, vertex.frame.color = NA,
vertex.size = NULL, vertex.color = NULL, vertex.shape = NULL,
vertex.label = NULL, vertex.label.cex = NULL, vertex.label.dist = 0.3,
vertex.label.color = "blue", edge.arrow.size = 0.3, ...)
}
\arguments{
\item{g}{an object of class "igraph" (resulting from similarity
analysis)}

\item{query}{an object in query (for example, an SNP or Gene)}

\item{displayBy}{which statistics will be used for displaying. It can
be "IC" for information content (by default), "none" for no
color-coding on nodes/terms}

\item{path.mode}{the mode of paths induced by nodes in query. It can be
"all_paths" for all possible paths to the root, "shortest_paths" for
only one path to the root (for each node in query),
"all_shortest_paths" for all shortest paths to the root (i.e. for each
node, find all shortest paths with the equal lengths)}

\item{node.info}{tells the ontology term information used to label
nodes. It can be one of "none" for no node labeling, "term_id" for
using Term ID, "term_name" for using Term Name, "both" for using both
of Term ID and Name (the first 15 characters), and "full_term_name" for
using the full Term Name}

\item{wrap.width}{a positive integer specifying wrap width of Term
Name. By default, first 15 characters}

\item{colormap}{short name for the colormap. It can be one of "jet"
(jet colormap), "bwr" (blue-white-red colormap), "gbr" (green-black-red
colormap), "wyr" (white-yellow-red colormap), "br" (black-red
colormap), "yr" (yellow-red colormap), "wb" (white-black colormap), and
"rainbow" (rainbow colormap, that is,
red-yellow-green-cyan-blue-magenta). Alternatively, any
hyphen-separated HTML color names, e.g. "blue-black-yellow",
"royalblue-white-sandybrown", "darkgreen-white-darkviolet". A list of
standard color names can be found in
\url{http://html-color-codes.info/color-names}}

\item{ncolors}{the number of colors specified over the colormap}

\item{zlim}{the minimum and maximum z/patttern values for which colors
should be plotted, defaulting to the range of the finite values of z.
Each of the given colors will be used to color an equispaced interval
of this range. The midpoints of the intervals cover the range, so that
values just outside the range will be plotted}

\item{colorbar}{logical to indicate whether to append a colorbar. If
pattern is null, it always sets to false}

\item{newpage}{logical to indicate whether to open a new page. By
default, it sets to true for opening a new page}

\item{glayout}{either a function or a numeric matrix configuring how
the vertices will be placed on the plot. If layout is a function, this
function will be called with the graph as the single parameter to
determine the actual coordinates. This function can be one of
"layout_nicely" (previously "layout.auto"), "layout_randomly"
(previously "layout.random"), "layout_in_circle" (previously
"layout.circle"), "layout_on_sphere" (previously "layout.sphere"),
"layout_with_fr" (previously "layout.fruchterman.reingold"),
"layout_with_kk" (previously "layout.kamada.kawai"), "layout_as_tree"
(previously "layout.reingold.tilford"), "layout_with_lgl" (previously
"layout.lgl"), "layout_with_graphopt" (previously "layout.graphopt"),
"layout_with_sugiyama" (previously "layout.kamada.kawai"),
"layout_with_dh" (previously "layout.davidson.harel"),
"layout_with_drl" (previously "layout.drl"), "layout_with_gem"
(previously "layout.gem"), "layout_with_mds". A full explanation of
these layouts can be found in
\url{http://igraph.org/r/doc/layout_nicely.html}}

\item{vertex.frame.color}{the color of the frame of the vertices. If it
is NA, then there is no frame}

\item{vertex.size}{the size of each vertex. If it is a vector, each
vertex may differ in size}

\item{vertex.color}{the fill color of the vertices. If it is NA, then
there is no fill color. If the pattern is given, this setup will be
ignored}

\item{vertex.shape}{the shape of each vertex. It can be one of
"circle", "square", "csquare", "rectangle", "crectangle", "vrectangle",
"pie" (\url{http://igraph.org/r/doc/vertex.shape.pie.html}), "sphere",
and "none". If it sets to NULL, these vertices with negative will be
"csquare" and the rest "circle".}

\item{vertex.label}{the label of the vertices. If it is NA, then there
is no label. The default vertex labels are the name attribute of the
nodes}

\item{vertex.label.cex}{the font size of vertex labels.}

\item{vertex.label.dist}{the distance of the label from the center of
the vertex. If it is 0 then the label is centered on the vertex. If it
is 1 then the label is displayed beside the vertex.}

\item{vertex.label.color}{the color of vertex labels.}

\item{edge.arrow.size}{the size of the arrows for the directed edge.
The default value is 1.}

\item{...}{additional graphic parameters. See
\url{http://igraph.org/r/doc/plot.common.html} for the complete list.}
}
\value{
an igraph object to represent DAG, appended with a node attribute
called 'inherited' indicative of whether terms are inherited or not
}
\description{
\code{xSocialiserNetplot} is supposed to visualise terms used to
annotate an input SNP or gene using different network layouts. It
returns an object of class 'igraph'.
}
\note{
none
}
\examples{
\dontrun{
# Load the library
library(XGR)
RData.location="~/Sites/SVN/github/bigdata"

# 1) SNP-based similarity analysis using GWAS Catalog traits (mapped to EF)
# provide genes and SNPs reported in AS GWAS studies
ImmunoBase <- xRDataLoader(RData.customised='ImmunoBase')
## get lead SNPs reported in AS GWAS
example.snps <- names(ImmunoBase$AS$variants)
SNP.g <- xSocialiserSNPs(example.snps, include.LD=NA,
RData.location=RData.location)

# 2) Circos plot involving nodes 'rs6871626'
xCircos(g=SNP.g, entity="SNP", nodes.query="rs6871626",
RData.location=RData.location)

# 3) Net plot visualising terms used to annotate an SNP 'rs6871626'
dag <- xSocialiserNetplot(g=SNP.g, query='rs6871626', displayBy="IC",
node.info=c("none"), vertex.label=NA, wrap.width=30)
}
}
\seealso{
\code{\link{xSocialiserGenes}}, \code{\link{xSocialiserSNPs}}
}
