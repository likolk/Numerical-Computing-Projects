
using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots
using DataFrames
using StatsPlots
using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT


include("/Users/cuenc/Documents/Semester 7/NC/Projects/nc_projects/Project 5/Project5_students/Sources/conjugate_gradient_solver.jl");

# In order to validate your implementation, solve the system defined by A_test.mat and b_test.mat. Plot the convergence (residual vs iteration).

A = read(matopen("./Data/Test/A_test.mat"))["A_test"];
b = read(matopen("./Data/Test/b_test.mat"))["b_test"];

# # print the size of matrix A 
println("The size of matrix A in exercise 3 is $(size(A))");
println("The size of vector b in exercise 3 is $(size(b))");

# make matrix A have the same dimensions as matrix B 
A = A[1:100, 1:100];
b = b[1:100];


# solve the system using myCG function
x0 = ones(size(A,1));
maxitr = 1000;
tol = 1e-6;
x, rvec = myCG(A, b, x0, maxitr, tol);

# plot the convergence
# plot(rvec, yaxis=:log, label="Convergence", xlabel="Iteration", ylabel="Residual", title="Convergence of CG method", legend=:false)













# plot the eigenvalues of A_test.mat
plot(eigvals(A), yaxis=:log, label="Eigenvalues", xlabel="Iteration", ylabel="Residual", title="Eigenvalues of A_test.mat", legend=:false)




# calculate the condition number of A_test.mat
cond_A = cond(A);
println("The condition number of A_test.mat is $(cond_A)");
# # calculate the eigenvalues of A_test.mat
# eige = eigen(A);
# eigenvalues = eige.values;
# # convert to lower triangular 
# eigenvalues = eigenvalues[1:100, 1:100];
# eigenvalues = cond(eigenvalues');
# println("The eigenvalues of A_test.mat are $(eigenvalues)");
# # plot the eigenvalues of A_test.mat
# # plot(eigvals_A, label="Eigenvalues", xlabel="Iteration", ylabel="Eigenvalues", title="Eigenvalues of A_test.mat", legend=:false)
# plot(eigenvalues, label="Eigenvalues", xlabel="Iteration", ylabel="Eigenvalues", title="Eigenvalues of A_test.mat", legend=:false)







# why the residual decreases monotonically









