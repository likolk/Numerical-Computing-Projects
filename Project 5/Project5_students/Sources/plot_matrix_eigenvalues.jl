# Plot the eigenvalues of A test.mat and comment on the condition number and convergence rate.
using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT
using StatsPlots
using DataFrames
using Plots
using DoubleFloats


# load 2 mat files 
A = matopen("./Data/Test/A_test.mat");
B = matopen("./Data/Test/b_test.mat");




