#   M.L. for Numerical Computing class @USI - malik.lechekhab@usi.ch 
"""
    spectral_part(A)

Compute the bi-partions of graph `A` using spectral method.

# Examples
```julia-repl
julia> spectral_part(A)
 1
 ⋮
 2
```
"""

# arpack library
using Arpack
using LinearAlgebra
import Pkg;
Pkg.add("Arpack");
Pkg.add("LinearAlgebra");

function spectral_part(A)
    n = size(A)[1]

    if n > 4*10^4
        @warn "graph is large. Computing eigen values may take too long."     
    end
    
    #   1.  Construct the Laplacian matrix.

    # construct the Laplacian matrix

    D = sum(A, dims=1) 
    L = diagm(vec(D)) - A


    #   2.  Compute its eigendecomposition.

    # get the 2 smallest eigenpairs by eigenvalues and store them in an array 
    # (eigenvalues, eigenvectors). set maximum iterations to 
    # 100000 and tolerance to 1e-6
    
        # (λ, v) = eigs(L, nev=2, which=:SM, maxiter=100000, tol=1e-6)
        eig_pairs, v = eigs(L, nev = 2, which=:SM, maxiter=1000000, tol=1e-6)


    # get the eigenvectors
    # v1 = eig_pairs.vectors[:,1]
    # v2 = eig_pairs.vectors[:,2]


    #   3.  Label the vertices with the entries of the Fiedler vector.

    fiedler_vector = v[:, 2];
 
    # 4. Partition them around their median value, or 0.

    treshold_value = 0;
    
    array1 = []
    array2 = []

    for i in 1:n
        if fiedler_vector[i] < treshold_value
            push!(array1, fiedler_vector[i])
        else
            push!(array2, fiedler_vector[i])
        end
    end

    indicator_vector = zeros(n)
    for i in 1:n
        if fiedler_vector[i] < treshold_value
            indicator_vector[i] = 1
        else
            indicator_vector[i] = 2
        end
    end
    return indicator_vector

    gplot(A, nodelabel=1:n, nodelabeldist=0.1, edgewidth=0.1, nodefillc=p)

end