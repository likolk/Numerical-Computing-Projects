# Cluster 2D real-world graphs with spectral clustering and compare with k-means 
# USI, ICS, Lugano
# Numerical Computing

using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT
using StatsPlots
using DataFrames

include("Tools/add_paths.jl");

# Number of clusters
K = 4;

print("lol");
W, pts = read_mat_graph("./Datasets/Meshes/airfoil1.mat");
# W, pts = read_mat_graph("./Datasets/Meshes/barth4.mat");
# W, pts = read_mat_graph("./Datasets/Meshes/3elt.mat");

draw_graph(W, pts)



# function cluster_graphs(W, pts, number_of_clusters)
    # similar to cluster points, we define a function cluster_graphs which will take W, pts and the number_of_clusters.

# allocate memory

# 2a) Create the Laplacian matrix and plot the graph

L, D = createlaplacian(W); # L = Laplacian matrix, D = diagonal matrix
#   Eigen-decomposition
#     use eigsvals() and eigvecs())
# we use eigen and then get the values because eigsvals is not a method 
# for sparse matrices
eigenvalues = eigen(L);
eigenvalues_values = eigenvalues.values
eigenvectors = sortperm(eigenvalues_values)
eigenvectors_vectors = eigenvalues.vectors[:, eigenvectors]
desired_eigenvectors = eigenvectors_vectors[:, 2:3]
#   Plot and compare
draw_graph(W, desired_eigenvectors)
# 2b) Cluster each graph in K = 4 clusters with spectral 
# and k-means method, compare your results visually for each case.
R = kmeans(pts', K)
data_assign = R.assignments
# similarly

# TODO:
R = kmeans(desired_eigenvectors', K)
spectral_assign = R.assignments

draw_graph(W, pts, data_assign)
# print("data_assign")
# readline()
draw_graph(W, desired_eigenvectors, spectral_assign)
draw_graph(W, pts, spectral_assign)
draw_graph(W, desired_eigenvectors, data_assign)
histogram(data_assign, title = "data assign histogram", legend = false)
histogram(spectral_assign, title = "spectral assign histogram", legend = false)

# end


# 2c) Calculate the number of nodes per clustering


# draw_graph(W, pts, data_assign)

# scatter(W, pts, data_assign)


marker = (:hexagon, 3, 0.6, :gray)
Plots.scatter(pts[:,1], pts[:,2],title = "My pretty plot", zcolor = data_assign, marker = marker, legend = false, aspect_ratio = 1)





