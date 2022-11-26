# Plot the eigenvalues of A test.mat and comment on the condition number and convergence rate.
using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT
using StatsPlots
using DataFrames
using Plots
using DoubleFloats


# read file 
A = read(matopen("./Data/Test/A_test.mat"), "A");

# we need to convert A to a number before getting the eigenvalues.
A = double(A)

eigenvalues = eigen(A);
eigenvalues_values = eigenvalues.values
# plot eigenvalues
save("eigenvalues", plot(eigenvalues_values, yscale=:log10, xlabel="Iteration", ylabel="Residual", title="Convergence", legend=:none))

    