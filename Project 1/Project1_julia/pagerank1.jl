# Pagerank using the power method instead of solving the sparse linear system


using MAT
using SparseArrays
using LinearAlgebra
using Plots
using MAT

import Pkg
Pkg.add("MAT")
Pkg.add("Plots")
Pkg.add("LinearAlgebra")
Pkg.add("SparseArrays")




# define matread to read the data from ETH500.mat file



file = matread("ETH500.mat");
G = file["G"];
U = file["U"];



function pagerank1(U,G) 
    # PageRank algorithm using the power method, instead of solving the sparse linear system.
    # Input: U is the adjacency matrix of a directed graph, G is the transition matrix of the graph.
    # Output: x is the PageRank vector of the graph.
    damping_factor = 0.85;
    number_of_nodes = size(G)[2]; # number of nodes
    out_degree = vec(sum(G, dims=1)); # out-degree of each node, where the out-degree is the number of outgoing links
    G = damping_factor * G * Diagonal(1 ./ out_degree); # normalize the columns of G
    G = G * Diagonal(1 ./ out_degree); 
    G = G + Diagonal(map(iszero, out_degree) ./ number_of_nodes); # add the dangling nodes
    x = ones(number_of_nodes, 1) / number_of_nodes; # initial guess of the PageRank vector
    e = ones(number_of_nodes, 1); # vector of ones
    z = ((1 - damping_factor) * map(!iszero, out_degree) + map(iszero, out_degree)) / number_of_nodes; # teleportation vector
    z = reshape(z, (1, 500)); # reshape z to be a row vector
    while (true)
        x = G * x + e * (z * x); # power method, where x is the PageRank vector, and z is the teleportation vector, 
        # and e is the vector of ones, and G is the transition matrix.
        termination_test = norm(x - U * x, Inf) > 1e-6; # termination test, which is the infinity norm of the difference 
        # between x and U * x, where U is the adjacency matrix of the graph, 
        # x is the PageRank vector, Inf is the infinity norm, and 1e-6 is the tolerance.
        if !termination_test
            break
        end
    end
    return x
end

# in order to get rid of matrix dimension mismatch, we can 
# reshape the vector x to be a column vector, and then
# sort the vector x in descending order, and then
# get the indices of the sorted vector x, and then
# get the corresponding values of the sorted vector x, and then
# get the corresponding values of the in-degree vector r, and then
# get the corresponding values of the out-degree vector c, and then
# get the corresponding values of the url vector U, and then
# print the results in a table, and then
# plot the results in a bar chart.
x = pagerank1(U,G)
i = sortperm(vec(x), rev = true);
x = x[i];
r = vec(sum(G, dims=2));
r = r[i];
c = vec(sum(G, dims=1));
c = c[i];
U = U[i];
header =(["index" "page-rank" "in" "out" "url"], ["i" "x" "r" "c" "U"])
data = [i x r c U]
pretty_table(data; header = header, header_crayon = crayon"bold green")
bar(x, lab="page ranking")


x = pagerank1(U, G);




# to generate a plot for the pagerank
plot(x, lab="page ranking")

#add a comment underneath the graph saying this is the pagerank for usi.ch


#add label above the plot saying "pagerank"
plot!(title="Page Rank")

# add plot below the plot saying "www.usi.ch"
plot!(xlabel="www.supsi.ch")

