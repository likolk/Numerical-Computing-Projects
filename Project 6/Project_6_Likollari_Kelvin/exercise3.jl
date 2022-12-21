using Plots
# include("simplexSolve.jl")
include("simplex.jl")
include("standardize.jl")
# include("auxiliary.jl")
# include("printSol.jl")
# include("testSimplex.jl")

# the objective function is:
# max z = 135x1 + 200x2 + 410x3 + 520x4
# the constraints are depicted in the following system of equations:
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
maximum_profit1 = 0 # second calculation for the maximum profit 
maximum_profit_allocation = []


type = "max"
A = [16 32 40 28; 320 510 630 125; 16 32 40 28; 320 510 630 125; 16 32 40 28; 320 510 630 125; 16 32 40 28; 320 510 630 125; 0 0.1 0.2 0.3; 0 0 0 0]
b = [18; 11930; 32; 22552; 25; 11209; 17; 5870; 1; 0]
c = [135; 200; 410; 520]
sign = [0; 0; 0; 0; 0; 0; 0; 0; 0; 1]
x = simplex(type, A, b, c, sign)


optimal_solution = -1



for i = 1:4
    maximum_profit += x[i] * cargo_profit[i]
end

println("The first maximum profit is: ", maximum_profit)

for i = 1:4
    for j = 1:4
        maximum_profit1 += x[i] * cargo_profit[j] * (1 + cargo_profit_increase[i])
        if (maximum_profit > optimal_solution) 
            optimal_solution = maximum_profit
        end
    end
end

println("The optimal profit is: ", optimal_solution);


println("The second version for the maximum profit is: ", maximum_profit1)


for i = 1:4
    maximum_profit_allocation = [maximum_profit_allocation; x[i]]
end

println("The maximum profit is: ", maximum_profit)
println("The maximum profit allocation is: ", maximum_profit_allocation)



plot(x, title = "Optimal allocation of cargos",
    label = "Optimal allocation",
    xlabel = "Cargos",
    ylabel = "Allocation",
    xticks = (1:4, cargos),
    yticks = 0:0.1:1,
    legend = :topleft,
    bar_width = 0.5,
    bar_color = :blue,
    bar_alpha = 0.5,
    bar_edgecolor = :black,
    bar_legend = true,
    size = (800, 600),
    dpi = 300,
    fmt = :png,
    output = "optimal_allocation.png"
)
