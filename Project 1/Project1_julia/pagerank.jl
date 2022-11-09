#   M.L. for Numerical Computing @USI - malik.lechekhab@usi.ch 

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



function pagerank(U, G)

    p = .85;

    n = size(G)[2];

    # out-degree
    c = vec(sum(G, dims=1));
    # in-degree
    r = vec(sum(G, dims=2));

    k = findall(!iszero, c);
    D = sparse(k, k, map(x -> 1/x, c[k]), n, n);

    e = ones(n, 1);
    sI = sparse(I, n, n);


    # Default implementation
    x = (sI - p * G * D) \ e;

    # Normalize
    x = x/sum(x);

    # Print results
    #   Print table
    i = sortperm(vec(x), rev = true);
    header =(["index" "page-rank" "in" "out" "url"], ["i" "x" "r" "c" "U"])
    data = [i x[i] r[i] c[i] U[i]]
    pretty_table(data; header = header, header_crayon = crayon"bold green")

    bar(x, lab="page ranking")
end


# find the pagerank of https://www.usi.ch 

x = pagerank(U, G);



# to generate a plot for the pagerank
plot(x, lab="page ranking")

#add a comment underneath the graph saying this is the pagerank for usi.ch


#add label above the plot saying "pagerank"
plot!(title="Page Rank")

# add plot below the plot saying "www.usi.ch"
plot!(xlabel="www.supsi.ch")



# use spy(A, markersize) to make the dots bigger (Did not use because of difficulty in making it compile)



