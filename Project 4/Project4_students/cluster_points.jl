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
#   TODO: Get the coordinate list from the function getpoints() located in the file /Tools/get_points.jl

# pts_spiral, pts_clusterin, pts_corn, pts_halfk, pts_moon, pts_outlier = getpoints();

points, nothing, nothing, nothing, nothing, nothing = getpoints();
nothing, points, nothing, nothing, nothing, nothing = getpoints();
nothing, nothing, points, nothing, nothing, nothing = getpoints();
nothing, nothing, nothing, points, nothing, nothing = getpoints();
nothing, nothing, nothing, nothing, points, nothing = getpoints();
nothing, nothing, nothing, nothing, nothing, points = getpoints();
n = size(points, 1)


#   Dummy variable
# dummy_map = rand(1:K, size(pts_dummy, 1)); changed to:
dummy_map = rand(1:K, size(points, 1));
dummy_ϵ = 1;
#   Create Gaussian similarity function
# S = similarity(pts_dummy[:, 1:2]); changed to :
S = similarity(points[:, 1:2]);

# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1b) Find the mininal spanning tree of the full graph
minimal_spanning_tree = minspantree(S);
#   Compute epsilon
ϵ = maximum(minimal_spanning_tree);

dummy_ϵ = ϵ;

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1c) Compute the epsilon similarity graph
# G_e = epsilongraph(dummy_ϵ, pts_dummy); changed to
G_e = epsilongraph(dummy_ϵ, points);

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1d) Create the adjacency matrix for the epsilon case
W_e = S .* G_e;
# draw_graph(W_e, pts_dummy) changed to
draw_graph(W_e, points)


# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1e) Create the Laplacian matrix and implement spectral clustering.
L, D = createlaplacian(W_e);

#   Spectral method
#     (Hint: use eigsvals() and eigvecs())

K = 2

eigenvalues, eigenvectors = eigs(L, nev = K, which = :SR);
eigenvalues = sort(eigenvalues);
#   Sort eigenvectors according to the eigenvalues. (https://discourse.julialang.org/t/how-to-sort-eigenvectors-from-lowest-to-highest-corresponding-eigenvalue/25586)
eigenvectors = eigenvectors[:, sortperm(eigenvalues)];

# get the first K = 2 eigenvectors
eigenvectors = eigenvectors[:, 1:K]; # get the first K = 2 columns of the matrix



#   K-means method to cluster rows of these eigenvectors 
# clustered_eigenvalues, clustered_eigenvectors = kmeans(pts_spiral, K, maxiter = 1000, display=:iter);
clustered_eigenvalues, clustered_eigenvectors = kmeans(eigenvectors, K, maxiter = 1000, display=:iter)

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1f) Run K-means on input data
# R = kmeans(pts_dummy', K); changed to:
# data_assign = R.assignments; # TODO: What does this line do? 
eigenvalues_clustering, eigenvectors_clustering = kmeans(points, K, n) 
# spec_assign = R.assignments; # TODO: What does this line do too?



# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1h) Visualize spectral and k-means clustering results
# draw_graph(W_e, pts_dummy, data_assign)
# draw_graph(W_e, pts_dummy, spec_assign)

draw_graph(W_e, points, clustered_eigenvectors)
draw_graph(W_e, points, eigenvectors_clustering)


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


