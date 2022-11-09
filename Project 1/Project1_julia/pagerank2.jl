
# Pagerank using the inverse iteration approach.


using MAT, SparseArrays
using LinearAlgebra, Plots
using PrettyTables

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
Pkg.add("PrettyTables")

file = matread("ETH500.mat");
G = file["G"];
U = file["U"];

function pagerank2(U, G)
    # pagerank function using inverse iteration approach.

    # we are passing as inputs the adjacency matrix U, and the matrix G 
    # containing the transitions.

    # the result of the function will be the pagerank vector x.

    damping_factor = 0.85; # the damping factor remains unchanged.
    number_of_nodes = size(G)[2]; # number of nodes.
    c = vec(sum(G, dims=1)); # out-degree of each node, where the out-degree is the number of outgoing links.
    r = vec(sum(G, dims=2)); # in-degree of each node, where the in-degree is the number of incoming links.
    k = findall(!iszero, c); # indices of nodes with non-zero out-degree.
    D = sparse(k, k, map(x -> 1/x, c[k]), number_of_nodes, number_of_nodes); # D is the diagonal matrix with the inverse of the out-degree of each node.
    e = ones(number_of_nodes, 1); # vector of ones.
    sI = sparse(I, number_of_nodes, number_of_nodes); # sparse identity matrix.
    alpha = 0.99; # alpha is the parameter of the inverse iteration approach.
    x = ones(number_of_nodes, 1) / number_of_nodes; # initial guess.
    termination_test = true; # termination test.
    while termination_test
        x = (alpha * sI - damping_factor * G * D) \ x; # inverse iteration approach.
        x = x / sum(x); # normalization.
        termination_test = norm(x - U * x, Inf) > 1e-6; # termination test, which is the infinity norm of the difference between x and U * x, where U is the adjacency matrix of the graph,
        # x is the PageRank vector, Inf is the infinity norm, and 1e-6 is the tolerance.
    end
    # because there is a  DimensionMismatch: matrix A has dimensions (500,1), matrix B has dimensions (500,1)
    # error, we need to reshape x to be a column vector.
    return x = reshape(x, (499, 1));
    # Print results
    #   Print table
    i = sortperm(vec(x), rev = true);
    header =(["index" "page-rank" "in" "out" "url"], ["i" "x" "r" "c" "U"])
    data = [i x[i] r[i] c[i] U[i]]
    pretty_table(data; header = header, header_crayon = crayon"bold green")

    bar(x, lab="page ranking")
    return x
end




#  Uncomment if you want to generate a page rank
# y = pagerank2(U, G)
# plot(y, lab="page ranking")
# plot!(title="Page Rank 2")
# plot!(xlabel="www.supsi.ch")
# spy(G)






   