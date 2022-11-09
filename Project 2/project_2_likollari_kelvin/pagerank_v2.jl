using MAT, SparseArrays, LinearAlgebra, Plots

"""
    page_rank()

Compute pagerank from matrix A, names U and damping factor p.

# Examples
```julia-repl
julia> page_rank("", A, pr)
```
"""
function page_rank(U, G, p)
    
    G = G - diagm(diag(G))

    n = size(G)[2]

    # c = out-degree, r = in-degree
    c = vec(sum(G, dims=1))
    r = vec(sum(G, dims=2))

    k = findall(!iszero, c)
    D = sparse(k, k, map(x -> 1/x, c[k]), n, n)

    e = ones(n, 1)
    sI = sparse(I, n, n)


    # Default implementation
    x = (sI - p * G * D) \ e

    #Normalize
    x = x/sum(x)

    return vec(x), c, r
end

    A = file["A"]

    x, c, r = page_rank("", A, 0.85)
    # plot(x, lab="page ranking")

    # to display them in a table 
    i = sortperm(vec(x), rev = true);
    # sort x in descending order
    x = x[i]; # comment this if you want the pagerank in the original order
    header = (["index" "page-rank" "in" "out"], ["i" "x" "r" "c"])
    data = [i x[i] r[i] c[i]]
    pretty_table(data; header = header, header_crayon = crayon"bold green", title = "Page Rank");
    # add also description on the x and y axis 

    plot(x, lab="Authors' Sorted PageRank")