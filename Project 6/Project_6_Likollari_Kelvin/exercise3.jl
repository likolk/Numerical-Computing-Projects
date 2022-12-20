# include("simplexSolve.jl")
include("simplex.jl")
include("standardize.jl")
# include("auxiliary.jl")
# include("printSol.jl")
# include("testSimplex.jl")

"""
In this second part of the assignment, you are required to use the simplex method implementation to solve a 
real-life problem taken from economics (constrained profit maximisation).

A cargo aircraft has 4 compartments (indicated simply as S1, . . . , S4) used to store the goods to be transported. 
Details about the weight capacity and storage capacity of the different compartments can be inferred 
from the data reported in the following table:


Compartment   Weight capacity (kg)   Storage capacity (m3)
S1            18                  11930
S2            32                  22552
S3            25                  11209
S4            17                  5870

The following four cargos are available for shipment during the next flight:

Cargo   Weight (kg)   Volume (m3)   Profit (CHF/t)
C1      16            320         135
C2      32            510         200
C3      40            630         410
C4      28            125         520

Any proportion of the four cargos can be accepted, and the profit obtained for each cargo 
is increased by 10% if it is put in S2, by 20% if it is put in S3 and by 30% if it is put in S4, due to the better storage conditions. 
The objective of this problem is to determine which amount of the different cargos will be transported and how to allocate it 
among the different compartments, while maximising the profit of the owner of the cargo plane. Specifically you have to:



# Formulate the problem above as a linear program: what is the objective function?
# What are the constraints? Write down all equations, with comments explaining what you are doing.


# the constraints are depicted in the following system of equations:
# 16x1 + 32x2 + 40x3 + 28x4 <= 18
# 320x1 + 510x2 + 630x3 + 125x4 <= 11930

# 16x1 + 32x2 + 40x3 + 28x4 <= 32
# 320x1 + 510x2 + 630x3 + 125x4 <= 22552

# 16x1 + 32x2 + 40x3 + 28x4 <= 25
# 320x1 + 510x2 + 630x3 + 125x4 <= 11209

# 16x1 + 32x2 + 40x3 + 28x4 <= 17
# 320x1 + 510x2 + 630x3 + 125x4 <= 5870

# 0.1x2 + 0.2x3 + 0.3x4 <= 1
# x1, x2, x3, x4 >= 0



"""
# solve the above problem. 
compartments = ["S1", "S2", "S3", "S4"]
cargos = ["C1", "C2", "C3", "C4"]
compartment_weight_capacity = [18, 32, 25, 17]
compartment_storage_capacity = [11930, 22552, 11209, 5870]
cargo_weight = [16, 32, 40, 28]
cargo_volume = [320, 510, 630, 125]
cargo_profit = [135, 200, 410, 520]
cargo_profit_increase = [0, 0.1, 0.2, 0.3]
maximum_profit = 0
maximum_profit_allocation = []


type = "max"
A = [16 32 40 28; 320 510 630 125; 16 32 40 28; 320 510 630 125; 16 32 40 28; 320 510 630 125; 16 32 40 28; 320 510 630 125; 0 0.1 0.2 0.3; 0 0 0 0]
b = [18; 11930; 32; 22552; 25; 11209; 17; 5870; 1; 0]
c = [135; 200; 410; 520]
sign = [0; 0; 0; 0; 0; 0; 0; 0; 0; 1]
x = simplex(type, A, b, c, sign)


for i = 1:4
    for j = 1:4
        maximum_profit += x[i] * cargo_profit[j] * (1 + cargo_profit_increase[i])
    end
end


for i = 1:4
    maximum_profit_allocation = [maximum_profit_allocation; x[i]]
end

println("The maximum profit is: ", maximum_profit)
println("The allocation of the cargos is: ", maximum_profit_allocation)