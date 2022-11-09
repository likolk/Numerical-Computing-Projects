# I/O packages
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


# -- uncomment below --
# function A_construct(n)
#     # allocate the memory for the matrix A
#     A = zeros(n,n)

#     for i in 1:n
#         for j in 1:n

#             if i == 1 || i == n || j == 1 || i != j
#                 A[i,j] = 1
#             elseif i == j
#                 A[i, j] = n + i - 1
#             else
#                 A[i, j] = 0
#             end
#         end
#     end
#     return A
# end

# A = A_construct(10)

# spy(A, title="Original Matrix")



# load content from ex2.jl
include("ex2.jl")
function ex2c()
    n = 10;
    (A, nz) = A_construct(n);
    spy(A, title="Original Matrix")
    println("Number of nonzeros in A: ", nz);
end

# to plot the matrix A
A = A_construct(10)
A = sparse(A)
spy(A, title="Non-Zero Structure of Matrix A")