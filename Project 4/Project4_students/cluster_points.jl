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
nothing, nothing, points, nothing, nothing, nothing = getpoints();
# nothing, nothing, nothing, points, nothing, nothing = getpoints();
# nothing, nothing, nothing, nothing, points, nothing = getpoints();
# nothing, nothing, nothing, nothing, nothing, points = getpoints();

# the above chunk of lines can be replaced with a single liner as follows:
# pts_spiral, pts_clusterin, pts_corn, pts_halfk, pts_moon, pts_outlier = getpoints();

# allocoate memory 
n = size(points, 1)
#  or 
# n = size(points)[1]


# Define a function which will take the algorithm, the nubmer of clusters 
# and the file name 

# similarity function
S = similarity(points[:, 1:2]);

# -------------------------------------------------------------------------------------------------------
# 1b) Find the mininal spanning tree of the full graph
minimal_spanning_tree = minspantree(S)

#  Compute epsilon. We will decide epsilon to be the 
# max edge weight in the adjacency matrix of the minimum spanning 
# tree of the gaussian similarity function..
epsilon = maximum(maximum(minimal_spanning_tree)) # max of the max of the columns

# 1c) Compute the epsilon similarity graph
G_e = epsilongraph(epsilon, points);
# draw the graph

# draw_graph(G_e, clustering_algorithm, "epsilongraph.png")   

# 1d) Create the adjacency matrix 
W_e = S .* G_e;
# draw the graph
# save("two_spirals.png", draw_graph(W_e, points))
# save("cluster_in_cluster.png", draw_graph(W_e, points))
# save("corners.png", draw_graph(W_e, points))
# save("half_kernel.png", draw_graph(W_e, points))
# save("crescent_full_moon.png", draw_graph(W_e, points))
# save("outlier.png", draw_graph(W_e, points))
# visualize 

# marker = (:hexagon, 2, 1.5, :red)
# Plots.scatter(points[:,1], points[:,2],title = "Adjacency matrix - Two sets", zcolor = W_e, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :red)
# Plots.scatter(points[:,1], points[:,2],title = "Adjacency matrix - Cluster in cluster", zcolor = W_e, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :red)
# Plots.scatter(points[:,1], points[:,2],title = "Adjacency matrix - Corners", zcolor = W_e, marker = marker, legend = false, aspect_ratio = 1)



# marker = (:hexagon, 2, 1.5, :red)
# Plots.scatter(points[:,1], points[:,2],title = "Adjacency matrix - Half Kernel", zcolor = W_e, marker = marker, legend = false, aspect_ratio = 1)

# marker = (:hexagon, 2, 1.5, :red)
# Plots.scatter(points[:,1], points[:,2],title = "Adjacency matrix - Crescent & Full Moon", zcolor = W_e, marker = marker, legend = false, aspect_ratio = 1)


# marker = (:hexagon, 2, 1.5, :red)
# Plots.scatter(points[:,1], points[:,2],title = "Adjacency matrix - Outlier", zcolor = W_e, marker = marker, legend = false, aspect_ratio = 1)



# 1e) Create the Laplacian matrix and implement spectral clustering.
L, D = createlaplacian(W_e);
#   Spectral method
#     (Hint: use eigsvals() and eigvecs())
# NOTE: My Julia Compiler claims there exists no method eigsvals so im using eigen and getting the values using the .values attributes instead.
# eigenvals, eigvals also do not work as the TA suggested
eigenvalues = eigen(L);
eigenvalues_values = eigenvalues.values
# the eigenvectors need to be sortperm'ed to match the eigenvalues 
eigenvectors = sortperm(eigenvalues_values)
eigenvectors_vectors = eigenvalues.vectors[:, eigenvectors]

# 1f) Run K-means on input data
#  ' takes the transpose 
# R = kmeans(points, K); # TODO: We need to take the transpose of the points as 
# otherwise we are accessing an index out of bounds
R = kmeans(points', K);
data_assign = R.assignments

# save the results
save("k_means_cluster_5.png", draw_graph(W_e, points, data_assign))

#   Cluster rows of eigenvector matrix of L corresponding to K smallest eigenvalues. Use kmeans as above.
#   (Hint: use kmeans())
# R = kmeans(eigenvectors_vectors[:, 1:2], 2)  #
# spectral_assign = R.assignments
# again like before if we do not transpose our
# vector we get an index out of bounds error
R = kmeans(eigenvectors_vectors[:, 1:2]', 2) 
spectral_assign = R.assignments

# save the results 
save("spectral_cluster_5.png", draw_graph(W_e, points, spectral_assign))

# visualize 
# draw_graph(W_e, clustering_algorithm, data_assign)
# readline()
# draw_graph(W_e, clustering_algorithm, spectral_assign)
# readline()





# . Use the kmeans() function to perform k-means clustering on the input 
# points. 
# Visualize the two clustering results using the function draw graph(). 

# uncomment 2 contiguous lines of the below and the respected 1 line of the lines 27-32 for it to work

# save("two_spirals_6_spectral.png", draw_graph(W_e, points, spectral_assign))
# save("two_spirals_6_kmeans.png", draw_graph(W_e, points, data_assign))

# save("cluster_in_cluster_6_spectral.png", draw_graph(W_e, points, spectral_assign))
# save("cluster_in_cluster_6_kmeans.png", draw_graph(W_e, points, data_assign))

# save("corners_6_spectral.png", draw_graph(W_e, points, spectral_assign))
# save("corners_6_kmeans.png", draw_graph(W_e, points, data_assign))

# save("half_kernel_6_spectral.png", draw_graph(W_e, points, spectral_assign))
# save("half_kernel_6_kmeans.png", draw_graph(W_e, points, data_assign))

# save("crescent_full_moon_6_spectral.png", draw_graph(W_e, points, spectral_assign))
# save("crescent_full_moon_6_kmeans.png", draw_graph(W_e, points, data_assign))

# save("outlier_6_spectral.png", draw_graph(W_e, points, spectral_assign))
# save("outlier_6_kmeans.png", draw_graph(W_e, points, data_assign))


# ------------------------------------------------------------------------------

"""
Here starts 1.7. 
"""




# Cluster the datasets i) Two spirals, ii) Cluster in cluster, 
# and iii) Crescent & full moon in K = 2 clusters, and visualize 
# the results obtained with spectral clustering and k-means 
# directly on the input data. Do the same for i) Corners, and ii) 
# Outlier for K = 4 clusters.




# the two spirals, cluster in cluster and crescent and full moon in k = 2 
# clusters has already been visualized.



R_1_7_k = kmeans(points', 4);
data_assign = R_1_7_k.assignments

# save the results
# this is for kmeans corners 
save("k_means_cluster_1_7.png", draw_graph(W_e, points, data_assign))

#   Cluster rows of eigenvector matrix of L corresponding to K smallest eigenvalues. Use kmeans as above.
#   (Hint: use kmeans())
# R = kmeans(eigenvectors_vectors[:, 1:2], 2)  #
# spectral_assign = R.assignments
# again like before if we do not transpose our
# vector we get an index out of bounds error
R_1_7_s = kmeans(eigenvectors_vectors[:, 1:4]', 4) 
spectral_assign = R_1_7_s.assignments

# save the results 
# this is for spectral cluster corners 
save("spectral_cluster__1_7.png", draw_graph(W_e, points, spectral_assign))



# those are for the outlier
# save("k_means_cluster_1_7_outlier.png", draw_graph(W_e, points, data_assign))
# save("spectral_cluster__1_7_outlier.png", draw_graph(W_e, points, spectral_assign))














