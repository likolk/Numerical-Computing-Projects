include("simplexSolve.jl")
include("simplex.jl")
include("standardize.jl")
include("auxiliary.jl")
include("printSol.jl")
include("testSimplex.jl")

using Plots


# TODO: try toggling-untoggling the commenting to see the different Plots


# we need to define the type of the problem
type = "max"
#  we need to define the matrix A
A = [4 3; 4 1; 4 2]
#  we need to define the vector h
h = [12 8 8]
#  we need to define the vector c
c = [3 4]
# we need to define m
m = 3
n = size(A)[2]
# the vector sign contains the signs of the constraints
sign = [0 0 0]
# A = A'
A = A'

# to find the max, we need to solve the above system of inequalities,

# iterate through a 
for i = 1:3
    for j = 1:2
        A[i, j] = -A[i, j]
    end
end

# iterate through h
for i = 1:3
    h[i] = -h[i]
end

# iterate through c
for i = 1:2
    c[i] = -c[i]
end

# use simplex
z, x_B, index_B = simplex(type, A, h, c, sign)

#  we need to print the solution
x_B, index_B = printSol(z, x_B, index_B, m, n)

#  we need to plot the solution
# plot 4x1 + 3x2 <= 12
plot(x -> (12 - 4x)/3, 0, 3, label = "4x1 + 3x2 ≤ 12", legend = :topright, xlabel = "x1", ylabel = "x2")




# # plot x2 <= 265 - x1

# plot(x -> (12 - 4x)/3, 0, 3, label = "4x1 + 3x2 ≤ 12", legend = :topright, xlabel = "x1", ylabel = "x2")

# # plot also 4x1 + x2 <= 8
# plot!(x -> (8 - 4x), 0, 3, label = "4x1 + x2 ≤ 8")

# # plot also 4x1 + 2x2 <= 8
# plot!(x -> (8 - 4x)/2, 0, 3, label = "4x1 + 2x2 ≤ 8")

# # plot also x1 >= 0
# plot!(x -> 0, 0, 3, label = "x1 ≥ 0")



# #  we need to print the solution
x_B, index_B = printSol(z, x_B, index_B, m, n)











