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

# Read file
file = matread("A_SymPosDef.mat");
# Extract adjacency matrix
A = file["A_SymPosDef"]

function symrcm(A)
    # get the permutation vector
    p = SymRCM.symrcm(A)
    # permute the matrix
    B = A[p,p]
    return A, B
end



# spy(A, title="Original Matrix")
# spy(symrcm(A)[2], title="Permuted Matrix")

# compute the Cholesky factorization of the original matrix


A = sparse(A)

F = cholesky(A)

L = sparse(F.L)


# Lp = sparse(cholesky(symrcm(A)[2]).L)


# spy(L, title="Cholesky Factorization of Original Matrix")

# spy(Lp, title="Cholesky Factorization of Permuted Matrix")


# cholesky factor R = G^T.
# cholesky decomposition A = R^T R, where R is upper triangular, R = LD^1/2


F = cholesky(A)

R = (sparse(F.L))'

R = R * R'


Fp = cholesky(Matrix(symrcm(A)[2]))
Rp = (sparse(Fp.U'))'




cholesky_factor = cholesky(A)
cholesky_factor_p = cholesky(symrcm(A)[2])

# get the lower triangular matrix
L = sparse(cholesky_factor.L)
Lp = sparse(cholesky_factor_p.L)

# get the upper triangular matrix
# to get the upper triangular matrix we need to transpose the lower triangular matrix

U = L'
Up = Lp'


# # get the diagonal matrix
# D = sparse(cholesky_factor.D)
# Dp = sparse(cholesky_factor_p.D)

# get the permutation vector
p = SymRCM.symrcm(A)
# permute the matrix
B = A[p,p]
#
# spy(L, title="Cholesky Factorization of Original Matrix")

# spy(Up, title="Cholesky Factorization of Permuted Matrix")



# to calculate the number of nonzero element in a Matrix, the formula is n + n + (n-2) + (n-2) + (n-2).
# n for the first row and first column.
# n-2 for the rest of the rows and columns.







# Cholesky Factor after RCM on A

C = cholesky(Matrix(B))
C = sparse(C.L)
C = C'

# spy(C, title="Cholesky Factorization of Permuted Matrix")




# Julia function cholesky() takes as input argument a dense matrix. Since matrix A (provided in the file "A_SymPosDef.mat") is in sparse format, you need to convert it to a dense matrix by using either Matrix() or collect(). Thus, the correct command to extract, e.g., the lower triangular factor is:
L = cholesky(Matrix(A)).L;

LL = cholesky(Matrix(symrcm(A)[2])).L
    
# You can then visualize and save the results by using:

# spy(L, title="Cholesky Factorization of Original Matrix")
D = cholesky(Matrix(A))
D = sparse(D.L)
D = D'
spy(D, title="Cholesky Factorization of Original Matrix")