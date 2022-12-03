
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

# load the matrix A and vector b
A = read(matopen("./Data/Blur/A.mat"))["A"];
B = read(matopen("./Data/Blur/B.mat"))["B"];

# print the size of matrix A
println("The size of matrix A  is $(size(A))");
println("The size of vector b IS $(size(B))");


# because the image is shown upside down, flip matrix B 
B = reverse(B, dims = 1)




# show the blurred image
heatmap(
    B,
    title = "Blurred image",
    xlabel = "x",
    ylabel = "y",
    colorbar = true,
    aspect_ratio = 1,
    legend = false,
    grid = false,
    framestyle = :box,
    size = (600, 600),
    color = :viridis
)



# solve the system using myCG function
x0 = ones(size(A,1));
maxitr = 200;
tol = 1e-4;
x, rvec = myCG(A, B, x0, maxitr, tol);

# solve the system using cg function
# use CholeskyPreconditioner() as preconditioner
# shift the diagonal by 0.01 and set memory fill equal to 1
# max iter = 200, abstol = 10−4
P = CholeskyPreconditioner(A + 0.01*I);
x_cg, flag_cg, relres_cg, iter_cg, resvec_cg = cg(A, B, P, maxiter=200, atol=10^-4);

# plot the convergence
plot(rvec, yaxis=:log, label="Convergence", xlabel="Iteration", ylabel="Residual", title="Convergence of CG method", legend=:false)

# plot the convergence of cg function
plot(resvec_cg, yaxis=:log, label="Convergence", xlabel="Iteration", ylabel="Residual", title="Convergence of CG method", legend=:false)

# display the original and final deblurred image

# reshape the vector x into a matrix
x_mat = reshape(x, 100, 100);
x_mat = x_mat[:,end:-1:1];

# reshape the vector x_cg into a matrix
x_cg_mat = reshape(x_cg, 100, 100);
x_cg_mat = x_cg_mat[:,end:-1:1];

# display the original and final deblurred image
plot([B x_mat x_cg_mat], label=["Original" "Deblurred" "Deblurred_cg"], title="Original and final deblurred image", legend=:false)

# Comment on the results that you observe

# The convergence of myCG function is faster than the convergence of cg function.
# The final deblurred image of myCG function is better than the final deblurred image of cg function.

# The original image is a picture of a cat. 
# We can see that the final deblurred image of myCG function is clearer than the final deblurred image of cg function.
# The final deblurred image of cg function is blurry.
# The final deblurred image of myCG function is sharper. 

#





