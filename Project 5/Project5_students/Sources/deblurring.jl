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

include("./conjugate_gradient_solver.jl")

# load the matrix A and vector b
A = read(matopen("./Data/Blur/A.mat"))["A"];
B = read(matopen("./Data/Blur/B.mat"))["B"];
# print the size of matrix A
println("The size of matrix A  is $(size(A))");
println("The size of vector b IS $(size(B))");



heatmap(
    B,
    title = "Blurred image",
    xlabel = "x",
    ylabel = "y",
    yflip = true,
    colorbar = true,
    aspect_ratio = 1,
    legend = false,
    grid = false,
    framestyle = :box,
    size = (600, 600),
    color = :greys
    # color = :viridis
)



# DEBLURRING 

# apply vectorization
b = vec(B);

# solve the deblurring problem using myCG

b = A' * b;
A = A' * A;

r_size, k =  size(A)
x0 = zeros(r_size, 1);
tol = 10^-4;
max_iter = 200;


# solve the deblurring problem using myCG
x, rvec= myCG(A, b, x0, max_iter, tol);

heatmap(
    reshape(x, size(B)),
    title = "Deblurred image using myCG",
    xlabel = "x",
    ylabel = "y",
    yflip = true,
    colorbar = true,
    aspect_ratio = :equal,
    legend = false,
    grid = false,
    framestyle = :box,
    size = (600, 600),
    color = :greys
    # color = :viridis
)

# solve the deblurring problem using cg
P = Preconditioners.CholeskyPreconditioner(A + 0.01 * I,1);

x, h = cg(A, b, Pl=P, maxiter=max_iter, reltol = ℯ^-max_iter, log=true);
# reltol has been set to e^-max_iter so as to converge up to the whole number of iterations

# show 
heatmap(
    reshape(x, size(B)),
    title = "Deblurred image using cg",
    xlabel = "x",
    ylabel = "y",
    yflip = true,
    colorbar = true,
    aspect_ratio = :equal,
    legend = false,
    grid = false,
    framestyle = :box,
    size = (600, 600),
    color = :greys
    # color = :viridis
)




# plot the convergence of myCG 
plot(rvec,  yaxis=:log, label="Eigenvalues", xlabel="Iteration", ylabel="Residual", title="Convergence of myCG", legend=:false)

# plot the convergence of cg
plot(h,  yaxis=:log, label="Eigenvalues", xlabel="Iteration", ylabel="Residual", title="Convergence of cg", legend=:false)

