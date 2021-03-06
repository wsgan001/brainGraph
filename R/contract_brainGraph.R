#' Contract graph vertices based on brain lobe and hemisphere
#'
#' Create a new graph after merging multiple vertices based on brain \emph{lobe}
#' and \emph{hemisphere} membership.
#'
#' The vertex size of the resultant graph is equal to the number of vertices in
#' each lobe (in the input graph). The x- and y- coordinates of the new vertices
#' are equal to the mean coordinates of the lobe vertices of the original graph.
#' The new edge weight is equal to the number of inter-lobular connections of
#' the original graph.
#'
#' @param g An \code{igraph} graph object
#' @export
#'
#' @return A new \code{igraph} graph object
#'
#' @seealso \code{\link[igraph]{contract}}
#' @author Christopher G. Watson, \email{cgwatson@@bu.edu}

contract_brainGraph <- function(g) {
  stopifnot(is_igraph(g))

  g.sub <- contract(g, V(g)$lobe.hemi)
  E(g.sub)$weight <- 1
  g.sub <- simplify(g.sub)
  V(g.sub)$x <- vapply(1:max(V(g)$lobe.hemi),
                      function(m) mean(V(g)[V(g)$lobe.hemi==m]$x), numeric(1))
  V(g.sub)$y <- vapply(1:max(V(g)$lobe.hemi),
                      function(m) mean(V(g)[V(g)$lobe.hemi==m]$y), numeric(1))
  V(g.sub)$size <- vapply(1:max(V(g)$lobe.hemi),
                      function(m) mean(V(g)[V(g)$lobe.hemi==m]$degree), numeric(1))
  vcols <- unique(V(g)$color.lobe[order(V(g)$lobe)])
  vcols <- rep(vcols, 2)
  V(g.sub)$color <- vcols
  V(g.sub)$lobe <- rep(sort(unique(V(g)$lobe)), 2)
  E(g.sub)$color.lobe <- set_edge_color(g.sub, V(g.sub)$lobe)

  return(g.sub)
}
