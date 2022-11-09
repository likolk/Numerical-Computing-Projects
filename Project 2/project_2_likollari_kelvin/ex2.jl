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


function A_construct(n)
    A = zeros(n,n)
    nz = 0;
    for i in 1:n
        for j in 1:n
            if i == 1 || i == n || j == 1 && i != j
                A[i,j] = 1
                nz += 1
            elseif i == j
                A[i, j] = n + i - 1
                nz += 1
            else 
                A[i, j] = 0
            end
        end
    end
    return A
end


