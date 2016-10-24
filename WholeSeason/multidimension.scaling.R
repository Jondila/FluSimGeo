# Distance matrix implied by transition matrix
epsilon
distancematrix <- as.dist(1/epsilon, diag = T, upper = T)
fit <- cmdscale(distancematrix, eig = TRUE, k = 2)
x <- fit$points[, 1]
y <- fit$points[, 2]
plot(x, y, main = "Graph for a distance Matrix",
xlim = range(x) + c(-1200, 1200))
text(x, y, pos = 4, labels = RTO_Names, cex = 0.4)

# Visualizing distance matrix in R using igraph
#install.packages('igraph')

library(igraph)
transformedmatrix <- as.matrix(distancematrix)
g <- graph.full(nrow(transformedmatrix))
V(g)$label <- RTO_Names
layout <- layout.mds(g, dist = as.matrix(transformedmatrix))
plot(g, layout = layout, vertex.size = 3)
