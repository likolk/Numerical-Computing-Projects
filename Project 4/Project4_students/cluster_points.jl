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

pts_spiral, nothing, nothing, nothing, nothing, nothing = getpoints();
# nothing, pts_clusterin, nothing, nothing, nothing, nothing = getpoints();
# nothing, nothing, pts_corn, nothing, nothing, nothing = getpoints();
# nothing, nothing, nothing, pts_halfk, nothing, nothing = getpoints();
# nothing, nothing, nothing, nothing, pts_moon, nothing = getpoints();
# nothing, nothing, nothing, nothing, nothing, pts_outlier = getpoints();

#   Dummy variable
# dummy_map = rand(1:K, size(pts_dummy, 1)); changed to:
dummy_map = rand(1:K, size(pts_spiral, 1));
dummy_ϵ = 1;
#   Create Gaussian similarity function
# S = similarity(pts_dummy[:, 1:2]); changed to :
S = similarity(pts_spiral[:, 1:2]);

# 1b) Find the mininal spanning tree of the full graph
minimal_spanning_tree = minspantree(S);
#   Compute epsilon
ϵ = maximum(minimal_spanning_tree);

dummy_ϵ = ϵ;


# 1c) Compute the epsilon similarity graph
# G_e = epsilongraph(dummy_ϵ, pts_dummy); changed to
G_e = epsilongraph(dummy_ϵ, pts_spiral);


# 1d) Create the adjacency matrix for the epsilon case
W_e = S .* G_e;
# draw_graph(W_e, pts_dummy) changed to
draw_graph(W_e, pts_spiral)

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

# use function kmeans() to cluster 
# the rows of these eigenvectors.


# 1f) Run K-means on input data
# R = kmeans(pts_dummy', K); changed to:
R = kmeans(pts_spiral', K);
data_assign = R.assignments;


#   Cluster rows of eigenvector matrix of L corresponding to K smallest eigenvalues. Use kmeans as above.
R = kmeans(pts_dummy', K);
spec_assign = R.assignments;

# 1h) Visualize spectral and k-means clustering results
draw_graph(W_e, pts_dummy, data_assign)
draw_graph(W_e, pts_dummy, spec_assign)