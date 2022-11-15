# Cluster 2D real-world graphs with spectral clustering and compare with k-means 
# USI, ICS, Lugano
# Numerical Computing

using SparseArrays, LinearAlgebra, Arpack
using Clustering

include("./Tools/add_paths.jl");

# Specify the number of clusters
K = 2;

# 1a) Get coordinate list from point clouds


#   Coords used in this demo

# points = pts_spiral, pts_clusterin, pts_corn, pts_halfk, pts_moon, pts_outlier.

points, nothing, nothing, nothing, nothing, nothing = getpoints();
# nothing, points, nothing, nothing, nothing, nothing = getpoints();
# nothing, nothing, points, nothing, nothing, nothing = getpoints();
# nothing, nothing, nothing, points, nothing, nothing = getpoints();
# nothing, nothing, nothing, nothing, points, nothing = getpoints();
# nothing, nothing, nothing, nothing, nothing, points = getpoints();
n = size(points, 1)


S = similarity(points[:, 1:2]);

# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1b) Find the mininal spanning tree of the full graph
minimal_spanning_tree = minspantree(S);
#   Compute epsilon. We will decide epsilon to be the 
#   value of the weight of the edge of the minimum spanning tree
#   with the largest weight. 

epsilon = maximum(minimal_spanning_tree)

# ------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1c) Compute the epsilon similarity graph
G_e = epsilongraph(epsilon, points);

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1d) Create the adjacency matrix for the epsilon case
W_e = S .* G_e;
draw_graph(W_e, points[:, 1:2])



# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1e) Create the Laplacian matrix and implement spectral clustering.
L, D = createlaplacian(W_e);
#   Spectral method
#     (Hint: use eigsvals() and eigvecs())
eigenvalues = eigvals(L)
eigenvectors = eigvecs(L)

# after finding the eigenvalues and eigenvectors,
# we need to sort them in ascending order

v, e = sort(eigenvalues)
eigenvectors = eigenvectors[:, sortperm(eigenvalues)]

# take the k smallest eigenvectors 
# (the first k eigenvectors are the ones with the smallest eigenvalues)
eigenvectors = eigenvectors[:, 1:K]

# and we will pass them to the function k-means 
# to find the clusters
s1, s2 = kmeans(L, K)





# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1f) Run K-means on input data
R = kmeans(points, K)
data_assign = R.assignments

#   Cluster rows of eigenvector matrix of L corresponding to K smallest eigenvalues. Use kmeans as above.
R = kmeans(eigenvectors, K)
spec_assign = R.assignments


# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1h) Visualize spectral and k-means clustering results
draw_graph(W_e, points, data_assign)
draw_graph(W_e, points, spec_assign)




# TODO: 1.7

# Cluster the datasets i) Two spirals, ii) Cluster in cluster, and iii) Crescent & full moon 
# in K = 2 clusters, and visualize the results obtained with spectral clustering and 
# k-means directly on the input data. Do the same for i) Corners, and ii) Outlier 
# for K = 4 clusters.


# for two_spirals:
# two_spiral, nothing, nothing, nothing, nothing, nothing = getpoints();
# two_spiral_map = rand(1:K, size(two_spiral, 1));
# two_spiral_ϵ = 1;
# two_spiral_S = similarity(two_spiral[:, 1:2]);
# two_spiral_minimal_spanning_tree = minspantree(two_spiral_S);
# two_spiral_ϵ = maximum(two_spiral_minimal_spanning_tree);
# two_spiral_G_e = epsilongraph(two_spiral_ϵ, two_spiral);
# two_spiral_W_e = two_spiral_S .* two_spiral_G_e;
# two_spiral_L, two_spiral_D = createlaplacian(two_spiral_W_e);
# two_spiral_eigenvalues, two_spiral_eigenvectors = eigs(two_spiral_L, nev = K, which = :SR);
# two_spiral_eigenvalues = sort(two_spiral_eigenvalues);
# two_spiral_eigenvectors = two_spiral_eigenvectors[:, sortperm(two_spiral_eigenvalues)];
# two_spiral_eigenvectors = two_spiral_eigenvectors[:, 1:K];
# two_spiral_clustered_eigenvalues, two_spiral_clustered_eigenvectors = kmeans(two_spiral, K, n)
# draw_graph(two_spiral_W_e, two_spiral, two_spiral_clustered_eigenvectors)
# draw_graph(two_spiral_W_e, two_spiral, two_spiral_eigenvectors_clustering)


