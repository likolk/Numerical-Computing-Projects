"""
In order to validate your implementation, 
solve the system defined by A test.mat and b test.mat. 
Plot the convergence (residual vs iteration).
"""

using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots


# Load test data
A = read(matopen("./Data/Test/A_test.mat"));
B = read(matopen("./Data/Test/b_test.mat"));

A = double(A)
b = double(B)

# vectorize the image row by row 
b = vec(b)
b = b(:)


x0 = zeros(size(A, 1))
maxitr = 1000
tol = 1e-6

x, rvec = myCG(A, b, x0, maxitr, tol)

# plot convergence
save("convergence", plot(rvec, yscale=:log10, xlabel="Iteration", ylabel="Residual", title="Convergence", legend=:none))














