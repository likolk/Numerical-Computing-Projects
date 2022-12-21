include("testSimplex.jl")
using LinearAlgebra
using Plots

costs = [25, 40]
sales = [85, 110]
demand = 265
budget = 7000

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

# goal = max profit

initial_profit = 0

for i = 1:265
    profit = sale1 * i + sale2 * (demand - i) - cost1 * i - cost2 * (demand - i)
    if profit > initial_profit
        initial_profit = profit
    end
end

println("The maximum profit is: ", initial_profit)




# plot the constraints

# plot the constraint 25x1 + 40x2 <= 7000
# solve for x2
# 25x1 + 40x2 = 7000
# 40x2 = 7000 - 25x1
# x2 = (7000 - 25x1)/40

plot!(x -> (7000 - 25x)/40, 0, 20, label = "25x1 + 40x2 ≤ 7000", legend = :topright, xlabel = "x1", ylabel = "x2")


# plot the constraint x1 + x2 <= 265
# solve for x2
# x1 + x2 = 265
# x2 = 265 - x1

plot!(x -> 265 - x, 0, 20, label = "x1 + x2 ≤ 265")

# when we plot those two inequalities, we see that they have an intersection 
# point. 
# the intersection point is the optimal solution of the problem


# # plot also x1 >= 0
# plot!(x -> 0, 0, 20, label = "x1 ≥ 0")

# # plot also x2 >= 0
# plot!(x -> 0, 0, 20, label = "x2 ≥ 0")


# # to calculate the value of the objective function, we need to find the optimal solution
# # since the optimal solution is : 18540, we can say that the value of the objective function is 18540
