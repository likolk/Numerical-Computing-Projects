using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots


# In order to validate your implementation, solve the system defined by A_test.mat and b_test.mat. Plot the convergence (residual vs iteration).

# load the matrix A and vector b
A = matread("./Data/Blur/A.mat")["A"];
b = matread("./Data/Test/b_test.mat");


println("The size of matrix A is $(size(A))")

