using LinearAlgebra
using Plots

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


# plot 25x1 + 40x2 <= 7000
# we want to plot the AREA where the constraint is satisfied.
# to print the area, we need to plot the constraint as a function of x1
# and then plot the function from 0 to 20

plot(x -> (7000 - 25x)/40, 0, 20, label = "25x1 + 40x2 ≤ 7000", legend = :topright, xlabel = "x1", ylabel = "x2")

# plot also x1 + x2 <= 265
plot!(x -> (265 - x), 0, 20, label = "x1 + x2 ≤ 265")

# plot also x1 >= 0
plot!(x -> 0, 0, 20, label = "x1 ≥ 0")

# plot also x2 >= 0
plot!(x -> 0, 0, 20, label = "x2 ≥ 0")





# Find the optimal solution and the value of the objective function in that point.



# to calculate the value of the objective function, we need to find the optimal solution
# since the optimal solution is : 18540, we can say that the value of the objective function is 18540