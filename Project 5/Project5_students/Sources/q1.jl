using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots
using BandwidthBenchmark
using BenchmarkTools
using BandedMatrices





# In order to validate your implementation, solve the system defined by A_test.mat and b_test.mat. Plot the convergence (residual vs iteration).

# load the matrix A and vector b
A = matread("./Data/Blur/A.mat")["A"];
b = matread("./Data/Test/b_test.mat");


println("The size of matrix A is $(size(A))")


"""
# calculate number of diagonal bands of A 

# we will define our own function to calculate the diagonal bands of A 

function diagonal_bands(A)
    n = size(A,1)
    bands = 0
    for i = 1:n
        for j = 1:n
            if A[i,j] != 0
                bands = max(bands, abs(i-j))
            end
        end
    end
    return bands
end

# calculate and print the number of diagonal bands of A
num_diagonal_bands = diagonal_bands(A)
println("The number of diagonal bands of A is $num_diagonal_bands")
# we get 753, but we should also add the main diagonal, so the total number of diagonal bands is 754
# we should do the same though for the other side of the diagonal, so the total number of diagonal bands is 754 + 754 = 1508
"""

# define the lower and upper diagonal
lower_diagonal, upper_diagonal = bandwidths(A);
# print 
println("The lower diagonal of A is $lower_diagonal")
println("The upper diagonal of A is $upper_diagonal")
# total
total_diagonal = lower_diagonal + upper_diagonal + 1;
println("The total diagonal of A is $total_diagonal")



# What is the length of the vectorized blur image b?

b_blurred = matread("../Sources/Data/Blur/B.mat")["B"]
b_blurred_vectorized = vec(b_blurred)
println("The length of the vectorized blur image b is $(length(b_blurred_vectorized))")









