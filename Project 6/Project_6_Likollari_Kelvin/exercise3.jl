
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

"""

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



# Create a script which uses the simplex method implemented in the previous exercise to solve the problem. 
# What is the optimal solution? Visualise it graphically and briefly comment the results obtained (are you surprised of this outcome on the basis of your data?).

using JuMP, Clp

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)
@variable(m, x4 >= 0)

@constraint(m, 16x1 + 32x2 + 40x3 + 28x4 <= 18)
@constraint(m, 320x1 + 510x2 + 630x3 + 125x4 <= 11930)
@constraint(m, 16x1 + 32x2 + 40x3 + 28x4 <= 32)
@constraint(m, 320x1 + 510x2 + 630x3 + 125x4 <= 22552)
@constraint(m, 16x1 + 32x2 + 40x3 + 28x4 <= 25)
@constraint(m, 320x1 + 510x2 + 630x3 + 125x4 <= 11209)
@constraint(m, 16x1 + 32x2 + 40x3 + 28x4 <= 17)
@constraint(m, 320x1 + 510x2 + 630x3 + 125x4 <= 5870)
@constraint(m, 0.1x2 + 0.2x3 + 0.3x4 <= 1)

@objective(m, Max, 135x1 + 200x2 + 410x3 + 520x4)

optimize!(m)

println("Optimal solution: ", objective_value(m))
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))
println("x4 = ", value(x4))

