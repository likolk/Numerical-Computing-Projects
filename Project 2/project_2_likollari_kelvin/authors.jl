using MAT, SparseArrays, LinearAlgebra, Plots, Graphs, GraphPlot, Cairo, Fontconfig, PrettyTables, DelimitedFiles, Statistics, Plots

import Pkg; 
Pkg.add("SymRCM");
Pkg.add("Graphs");
Pkg.add("GraphPlot");
Pkg.add("Cairo");
Pkg.add("Fontconfig");
Pkg.add("Compose");
Pkg.add("DelimitedFiles");
Pkg.add("Statistics")
Pkg.add("Plots")


include("drawit.jl")

# Read housegraph.mat
filename = matread("housegraph.mat");


function degree_centrality(A)
    # we do not count ourselves 
    # (i.e. the diagonal of the adjacency matrix)
    # self loops can be defined as the diagonal elements of the adjacency matrix
    for i in 1:size(A)[1]
        A[i,i] = 0
    end
    deg = sum(A, dims=1)
    deg = zeros(sum(deg), 2)
    k = 0; 
    for i in eachindex(A)
        for j in eachindex(A)
            if A[i,j] == 1 # if there is an edge
                k += 1
                deg[k,1] = i # store the node
                deg[k,2] = j 
            end
        end
    end
end

# sort based on the degree 
deg = degree_centrality(filename["A"])
deg = sort(deg, dims=1, rev=true)
for i in 1:5
    println("Author ", i, " Coauthor: ", deg[i,1], " Degree: ", deg[i,2])
end


# drawit(A, m, name, "result.png")
