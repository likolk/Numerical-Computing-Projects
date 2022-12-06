
using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots
using DataFrames
using StatsPlots

include("./conjugate_gradient_solver.jl")

# load the matrix A and vector b
A = read(matopen("./Data/Blur/A.mat"))["A"];
B = read(matopen("./Data/Blur/B.mat"))["B"];

# print the size of matrix A
println("The size of matrix A  is $(size(A))");
println("The size of vector b IS $(size(B))");


# because the image is shown upside down, flip matrix B 
B = reverse(B, dims = 1)




# show the blurred image
heatmap(B, title = "Blurred image", xlabel = "x", ylabel = "y", colorbar = true, aspect_ratio = 1, legend = false, grid = false, framestyle = :box, size = (600, 600), color = :viridis);



# DEBLURRING 
"""

Solve the deblurring problem for the blurred image matrix B.mat and transformation matrix A.mat using 
your routine myCG and Julia’s preconditioned conjugate gradient cg using the Pl option 
(from the IterativeSolvers package). 
As a preconditioner, use CholeskyPreconditioner() from the Preconditioners package 
to get the incomplete Cholesky factors. In order to ensure existence of the IC factor shift the diagonal 
by 0.01 and set the memory fill equal to 1. Solve the system with both solvers using max iter = 200,
 abstol = 10−4. Plot the convergence (residual vs iteration) of each solver and display the original 
 and final deblurred image. Carefully explain and comment on the results that you observe.
Hint: You can use ?function() to retrieve some information on function().

"""

# apply vectorization
b = vec(B);

# solve the deblurring problem using myCG

b = A' * b;
A = A' * A;

r_size, k =  size(A)
x0 = ones(r_size, 1);
tol = 1e-4;
max_iter = 200;


# solve the deblurring problem using myCG
x, rvec= myCG(A, b, x0, tol, max_iter);

# shift the matrix A diagonal entries 
A = A + 0.01 * I;
# solve the deblurring problem using cg
P = Preconditioners.CholeskyPreconditioner(A,1);
xx, r_vec_vec= cg(A, b, P, maxiter = 200, atol = 1e-4);

# plot the convergence of myCG
plot(rvec, title = "Convergence of myCG", xlabel = "Iteration", ylabel = "Residual", colorbar = true, aspect_ratio = 1, legend = false, grid = false, framestyle = :box, size = (600, 600), color = :viridis);

# plot the convergence of cg
plot(r_vec_vec, title = "Convergence of cg", xlabel = "Iteration", ylabel = "Residual", colorbar = true, aspect_ratio = 1, legend = false, grid = false, framestyle = :box, size = (600, 600), color = :viridis);

# show the deblurred image
heatmap(reshape(x, 100, 100), title = "Deblurred image", xlabel = "x", ylabel = "y", colorbar = true, aspect_ratio = 1, legend = false, grid = false, framestyle = :box, size = (600, 600), color = :viridis);
