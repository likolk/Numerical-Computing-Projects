# Cluster 2D real-world graphs with spectral clustering and compare with k-means 
# USI, ICS, Lugano
# Numerical Computing

using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT

include("Tools/add_paths.jl");

# Number of clusters
K = 4;

print("lol");
W_1, pts_1 = read_mat_graph("./Datasets/Meshes/airfoil1.mat");
W_2, pts_2 = read_mat_graph("./Datasets/Meshes/barth4.mat");
W_3, pts_3 = read_mat_graph("./Datasets/Meshes/3elt.mat");

draw_graph(W_1, pts_1)
draw_graph(W_2, pts_2)
draw_graph(W_3, pts_3)


function cluster_graphs(W, pts, number_of_clusters)
    # similar to cluster points, we define a function cluster_graphs which will take W, pts and the number_of_clusters.

    # allocate memory
    n = size(W, 1)

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
    draw_graph(W, desired_eigenvectors, spectral_assign)
    draw_graph(W, pts, spectral_assign)
    draw_graph(W, desired_eigenvectors, data_assign)
    histogram(data_assign, title = "data assign histogram", legend = false)
    histogram(spectral_assign, title = "spectral assign histogram", legend = false)
end


# 2c) Calculate the number of nodes per clustering

display(cluster_graphs(W_1, pts_1, K))
readline()
cluster_graphs(W_2, pts_2, K)
readline()
cluster_graphs(W_3, pts_3, K)







