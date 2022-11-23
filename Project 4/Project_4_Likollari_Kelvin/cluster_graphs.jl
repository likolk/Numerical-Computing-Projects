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

print("test");
# W, pts = read_mat_graph("./Datasets/Meshes/airfoil1.mat");
# W, pts = read_mat_graph("./Datasets/Meshes/barth4.mat");
# W, pts = read_mat_graph("./Datasets/Meshes/3elt.mat");
print("mat file read");

# draw_graph(W, pts)

# for the market we can use params as markeralpha, markercolor,
# markershape, markersize, markerstrokecolor, markerstrokestyle


# similar to cluster points, we define a function cluster_graphs which will take W, pts and the number_of_clusters.

# allocate memory
n = size(W)[1]

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

save("1.png", draw_graph(W, pts));
save("2.png", draw_graph(W, desired_eigenvectors));



#   Plot and compare
# draw_graph(W, desired_eigenvectors)

# marker = (:hexagon, 1.5, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "Airfoil1 Graph (1) ", zcolor = pts, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "Airfoil1 Graph (2) ", zcolor = desired_eigenvectors, marker = marker, legend = false, aspect_ratio = 1)



# 2b) Cluster each graph in K = 4 clusters with spectral 
# and k-means method, compare your results visually for each case.

R = kmeans(pts', K) # kmeans expects the data to be in the form of rows and not columns
data_assign = R.assignments
# similarly

# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "STH", zcolor = data_assign, marker = marker, legend = false, aspect_ratio = 1)

# # R = kmeans(desired_eigenvectors', K) # NOTE!!, this will not display proper graphs in the 
# histogram, therefore, we need to get tje forst 4 eigenvectors 
# # spectral_assign = R.assignments


R = kmeans(eigenvectors_vectors[:, 1:K]', K) # here we are getting the first 4 eigenvectors, which is the same as the first 4 eigenvalues
spectral_assign = R.assignments

# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "STH", zcolor = spectral_assign, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "Spectral Clusters", zcolor = spectral_assign, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "K-Means Clusters - barth4", zcolor = data_assign, marker = marker, legend = false, aspect_ratio = 1)

# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "Spectral Clusters - barth4", zcolor = spectral_assign, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "Spectral Clusters - 3elt", zcolor = spectral_assign, marker = marker, legend = false, aspect_ratio = 1)

# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "K-Means Clusters - 3elt", zcolor = data_assign, marker = marker, legend = false, aspect_ratio = 1)



# when plotting using the Plots.scatter, we need to show edges on embedding,
# control the node sizs and the edge widths 
# marker = (:hexagon, 2, 1.5, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "Spectral Clusters - 3elt", 
# zcolor = spectral_assign, marker = marker, legend = false, 
# aspect_ratio = 1, show_embedding = true, node_size = -2.5, 
# edge_width = -10.5)


#  for airfoil1
# save("3.png", draw_graph(W, pts, data_assign));
# save("4.png", draw_graph(W, pts, spectral_assign));


# save("barth4_spectral.png", draw_graph(W, pts, spectral_assign))
# save("barth4_kmeans.png", draw_graph(W, pts, data_assign))



save("3elt_spectral.png", draw_graph(W, pts, spectral_assign))
save("3elt_kmeans.png", draw_graph(W, pts, data_assign))







# draw_graph(W, pts, data_assign)
# # print("data_assign")
# # readline()
# draw_graph(W, desired_eigenvectors, spectral_assign)
# draw_graph(W, pts, spectral_assign)
# draw_graph(W, desired_eigenvectors, data_assign)

# histogram(data_assign, title = "Data-Assign (K-Means) Histogram", legend = false)
# histogram(spectral_assign, title = "Spectral Assign Histogram", legend = false)


# histogram(data_assign, title = "Data-Assign (K-Means) Histogram - barth4", legend = false)
# histogram(spectral_assign, title = "Spectral Assign Histogram - barth4", legend = false)


# histogram(data_assign, title = "Data-Assign (K-Means) Histogram - 3elt", legend = false)
# histogram(spectral_assign, title = "Spectral Assign Histogram - 3elt", legend = false)



# # 2c) Calculate the number of nodes per clustering


# # draw_graph(W, pts, data_assign)

# # scatter(W, pts, data_assign)


# marker = (:hexagon, 3, 0.6, :gray)
# Plots.scatter(pts[:,1], pts[:,2],title = "My pretty plot", zcolor = data_assign, marker = marker, legend = false, aspect_ratio = 1)







# calculate number of nodes per cluster
for k in 0:K-1
    println("Number of nodes in cluster ", k, " is ", count(c -> c == k, spectral_assign))
    println("Number of nodes in cluster ", k, " is ", count(c -> c == k, data_assign))
end