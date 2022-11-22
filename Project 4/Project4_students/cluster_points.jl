# Cluster 2D real-world graphs with spectral clustering and compare with k-means 
# USI, ICS, Lugano
# Numerical Computing

using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT
using Plots
using Distances
using Random
using StatsPlots
using DataFrames


include("./Tools/add_paths.jl");

# Specify the number of clusters
K = 2;

# 1a) Get coordinate list from point clouds


#   Coords used in this demo

# points = pts_spiral, pts_clusterin, pts_corn, pts_halfk, pts_moon, pts_outlier.

# points, nothing, nothing, nothing, nothing, nothing = getpoints();
# nothing, points, nothing, nothing, nothing, nothing = getpoints();
# nothing, nothing, points, nothing, nothing, nothing = getpoints();
# nothing, nothing, nothing, points, nothing, nothing = getpoints();
# nothing, nothing, nothing, nothing, points, nothing = getpoints();
# nothing, nothing, nothing, nothing, nothing, points = getpoints();
# the above chunk of lines can be replaced with a single liner as follows:
pts_spiral, pts_clusterin, pts_corn, pts_halfk, pts_moon, pts_outlier = getpoints();

# Define a function which will take the algorithm, the nubmer of clusters 
# and the file name 

# similarity function
S = similarity(clustering_algorithm)

# -------------------------------------------------------------------------------------------------------
# 1b) Find the mininal spanning tree of the full graph
minimal_spanning_tree = minspantree(S)

#  Compute epsilon. We will decide epsilon to be the 
# max edge weight in the adjacency matrix of the minimum spanning 
# tree of the gaussian similarity function..
epsilon = maximum(maximum(minimal_spanning_tree))

# 1c) Compute the epsilon similarity graph
G_e = epsilongraph(epsilon, clustering_algorithm);
# draw the graph

draw_graph(G_e, clustering_algorithm, "epsilongraph.png")   

# 1d) Create the adjacency matrix 
W_e = S .* G_e;
# draw the graph
draw_graph(W_e, clustering_algorithm, "adj-matrix-draw.png")

# 1e) Create the Laplacian matrix and implement spectral clustering.
L, D = createlaplacian(W_e);
#   Spectral method
#     (Hint: use eigsvals() and eigvecs())
# NOTE: My Julia Compiler claims there exists no method eigsvals so im using eigen and getting the values using the .values attributes instead.
eigenvalues = eigen(L);
eigenvalues_values = eigenvalues.values
# the eigenvectors need to be sortperm'ed to match the eigenvalues 
eigenvectors = sortperm(eigenvalues_values)
eigenvectors_vectors = eigenvalues.vectors[:, eigenvectors]

# 1f) Run K-means on input data
R = kmeans(clustering_algorithm', number_of_clusters)
data_assign = R.assignments

#   Cluster rows of eigenvector matrix of L corresponding to K smallest eigenvalues. Use kmeans as above.
#   (Hint: use kmeans())
R = kmeans(eigenvectors_vectors[:, 1:K]', number_of_clusters)
spectral_assign = R.assignments

# visualize 
draw_graph(W_e, clustering_algorithm, data_assign)
readline()
draw_graph(W_e, clustering_algorithm, spectral_assign)
readline()





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


