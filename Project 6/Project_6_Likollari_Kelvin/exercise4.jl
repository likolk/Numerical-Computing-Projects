include("simplexSolve.jl")
include("simplex.jl")
include("standardize.jl")
include("auxiliary.jl")
include("printSol.jl")

using Plots
"""
Consider now the following simple problem:

max z = 3x1 + 4x2,
    s.t. 4x1 + 3x2 ≤ 12
    4x1 + x2 ≤ 8 
    4x1 + 2x2 ≤ 8 
    x1,x2 ≥ 0.

Use the simplex method to solve this problem. What is the optimal solution? Visualise it graphically and briefly comment the results obtained (are you surprised of this outcome on the basis of your data?).
"""


# Use the simplex method to solve this problem

n = size(A)[2]
#  we need to define the type of the problem
type = "max"
#  we need to define the matrix A
A = [4 3; 4 1; 4 2]
#  we need to define the vector h
h = [12 8 8]
#  we need to define the vector c
c = [3 4]
# we need to define m
m = 3

sign = [0 0 0]
# the vector sign contains the signs of the constraints
# 0 means ≤
# 1 means ≥
# 2 means =



#  we need to standardize the problem

#  we need to solve the problem using simplex
z, x_B, index_B = simplex(type, A, h, c, sign)

# plot x2 <= 265 - x1

plot(x -> (12 - 4x)/3, 0, 3, label = "4x1 + 3x2 ≤ 12", legend = :topright, xlabel = "x1", ylabel = "x2")

# plot also 4x1 + x2 <= 8
plot!(x -> (8 - 4x), 0, 3, label = "4x1 + x2 ≤ 8")

# plot also 4x1 + 2x2 <= 8
plot!(x -> (8 - 4x)/2, 0, 3, label = "4x1 + 2x2 ≤ 8")

# plot also x1 >= 0
plot!(x -> 0, 0, 3, label = "x1 ≥ 0")



#  we need to print the solution
# x_B, index_B = printSol(z, x_B, index_B, m, n)










