using MAT, SparseArrays, LinearAlgebra, Plots



using MAT
# Linear algebra packages
using SymRCM, SparseArrays, LinearAlgebra
# Plot and graphs packages
using Plots, Graphs, GraphPlot, Cairo, Fontconfig, PrettyTables

import Pkg; 
Pkg.add("SymRCM");
Pkg.add("Graphs");
Pkg.add("GraphPlot");
Pkg.add("Cairo");
Pkg.add("Fontconfig");
Pkg.add("Compose");
Pkg.add("Plots")


"""
    page_rank()

Compute pagerank from matrix A, names U and damping factor p.

# Examples
```julia-repl
julia> page_rank("", A, pr)


Compute the PageRank value for all authors and provide a graph of all authors in descending order according to the PageRank. Include your script in the submission.

```
"""
file = matread("housegraph.mat")

function page_rank(U, G, p) 

   # if the number of arguments is < 3 or damping factor is 0.85, end 
    if length(U) < 3 || p == 0.85
    end
    # G = G - diagm(diag(G)) # G is a self-loop so we need to remove it

    n = size(G)[2] # number of nodes
    # c = out-degree, r = in-degree
    c = vec(sum(G, dims=1)) # column sum
    r = vec(sum(G, dims=2)) # row sum
    k = findall(!iszero, c) # non-zero column indices
    D = sparse(k, k, map(x -> 1/x, c[k]), n, n) # D is the diagonal matrix of 1/c
    e = ones(n, 1) # n x 1 vector of ones
    sI = sparse(I, n, n) # n x n identity matrix
    # print default implementation
    println("Default implementation")
    x = (sI - p * G * D) \ e # x is the pagerank vector
    x = x/sum(x) # normalize x
    # Print URLs in page rank order.
    println("Page rank order")
    # x = sort(x, rev=true, dims = 1) # toggle this if you want to get the original/sorted  order
    # # make x a permutation matrix 
    println(x)
    # spy(U, x, title="Page Rank", xlabel="Authors", ylabel="Page Rank");
    
    i = sortperm(vec(x), rev = true);
    header =(["index" "page-rank" "in" "out" "url"], ["i" "x" "r" "c" "U"])
    data = [i x[i] r[i] c[i] U[i]]
    pretty_table(data; header = header, header_crayon = crayon"bold green")
    bar(x, lab="page ranking")
    
    # plot = bar(x, title="PageRank", xlabel="Author", ylabel="PageRank", label="PageRank", legend=:topleft)
    # spy(G, title="Adjacency Matrix", xlabel="Author", ylabel="Author", label="Adjacency Matrix", legend=:topleft)
    return vec(x), c, r # return pagerank vector, out-degree, in-degree


    # x = sort(x, rev=true , dims = 1)
    # # print the page rank values.
    # println("Page rank values:");
    # for i in x
    #     println(i)
    # end
end

# to plot the pagerank graph, we actually need to call the function page_rank
# and then plot the graph using the returned values

A = file["A"]

x, c, r = page_rank("", A, 0.85)
plot(x, lab="page ranking")

# to display them in a table 
header = (["index" "page-rank" "in" "out"], ["i" "x" "r" "c"])
data = [i x[i] r[i] c[i]]
pretty_table(data; header = header, header_crayon = crayon"bold green")

plot(x, lab="page ranking")