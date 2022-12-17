using LinearAlgebra
using Printf
using Statistics
using Plots
using Random
using Test
using JuMP
using GLPK
using Arpack
using SparseArrays

"""
A tailor plans to sell two types of trousers, with production costs of 25 CHF and 40 CHF, respectively. 
The former type can be sold for 85 CHF, while the latter for 110 CHF. 
The tailor estimates a total monthly demand of 265 trousers. Find the number of units of each type 
of trousers that should be produced in order to maximise the net profit of the tailor, if we assume 
that the he cannot spend more than 7000 CHF in raw materials. 
Solve the system of inequalities.

25 CHF   40 CHF 
85 CHF   110 CHF
265 trousers
7000 CHF


"""

"""
Formulate the above problem as a linear program

maximize: 85x1 + 110x2 - 25x1 - 40x2
subject to: 25x1 + 40x2 <= 7000
            x1 + x2 <= 265
            x1, x2 >= 0

"""



costs = [25, 40]
sales = [85, 110]
demand = 265
budget = 7000

# plot the feasible region identified by the system of inequalities
plot("Feasible region", xlabel = "x1", ylabel = "x2", legend = false)



x = [0, 0]
profit = 0
maximum_profit = 0
maximum_profit_x = [0, 0]

for i = 1:265
    x[1] = i
    x[2] = 265 - i
    for j = 1:2
        profit = profit + sales[j] * x[j] - costs[j] * x[j]
    end
    for j = 1:2
        profit = profit - costs[j] * x[j]
    end
    if profit > maximum_profit
        maximum_profit = profit
        maximum_profit_x = x
    end
end

println("The maximum profit is: ", maximum_profit)


# another version of the tailor seller problem 


cost1 = 25
cost2 = 40
sale1 = 85
sale2 = 110
demand = 265
budget = 7000

x1 = 0
x2 = 0
profit = 0
maximum_profit = 0
maximum_profit_x = [0, 0]

for i = 1:265
    x1 = i
    x2 = 265 - i
    profit = sale1 * x1 + sale2 * x2 - cost1 * x1 - cost2 * x2
    if profit > maximum_profit
        maximum_profit = profit
        maximum_profit_x = [x1, x2]
    end
end

println("The maximum profit is: ", maximum_profit)




