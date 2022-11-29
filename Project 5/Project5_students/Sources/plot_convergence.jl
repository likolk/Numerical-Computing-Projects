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


include("/Users/cuenc/Documents/Semester 7/NC/Projects/nc_projects/Project 5/Project5_students/Sources/conjugate_gradient_solver.jl");

# In order to validate your implementation, solve the system defined by A_test.mat and b_test.mat. Plot the convergence (residual vs iteration).

A = read(matopen("./Data/Test/A_test.mat"))["A_test"];
b = read(matopen("./Data/Test/b_test.mat"))["b_test"];

# # print the size of matrix A 
println("The size of matrix A in exercise 3 is $(size(A))");
println("The size of vector b in exercise 3 is $(size(b))");

# solve the system using myCG function
#  TODO: Convergence is wrong 
x0 = zeros(size(A, 1));
maxitr = 1000;
tol = 1e-6;
x, rvec = myCG(A, b, x0, maxitr, tol);
plot(rvec, title="Convergence of CG", xlabel="Iteration", ylabel="Residual", label="CG")





# plot the eigenvalues of A_test.mat.

# get the eigenvalues of A_test.mat
# eigvals_A = eigen(A);
# desired_eigenvalues = eigvals_A.values;

# # plot the eigenvalues of A_test.mat.
# plot(desired_eigenvalues, title="Eigenvalues of A_test", xlabel="Iteration", ylabel="Eigenvalues", label="Eigenvalues")














