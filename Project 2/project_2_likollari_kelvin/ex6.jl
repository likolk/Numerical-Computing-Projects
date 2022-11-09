using MAT, SparseArrays, LinearAlgebra, Plots, Graphs, GraphPlot, Cairo, Fontconfig, PrettyTables, DelimitedFiles, Statistics, Plots

import Pkg; 
Pkg.add("SymRCM");
Pkg.add("Graphs");
Pkg.add("GraphPlot");
Pkg.add("Cairo");
Pkg.add("Fontconfig");
Pkg.add("Compose");
Pkg.add("DelimitedFiles");
Pkg.add("Statistics")
Pkg.add("Plots")



#read delimeted file

lines = readdlm("karate.txt");

#6a)
# uncomment below to see the results for 6a.

# to find the top5 nodes and their degree 
"""
A = zeros(1,34);
for i in 1:34
    for j in 1:34
        if lines[i,j] == 1
            A[i] += 1
        end
    end
end

deg = sum(A, dims=1)
i = sortperm(vec(deg), rev=true)
top5 = i[1:5]
println("Top 5 nodes and their degree: ", top5, " ", deg[top5])
"""


# below you can see another version of the above algorithm, which is less efficient though. Do not consider it as it has a slight mismatch on the nodes. 
# Try at your own risk.

# node = zeros(1, 34)
# for i in 1:34
#     for j in 1:34
#        if lines[i,j] == 1
#             if node[i] == 1
#                 node[i] += 1
#             else 
#                 node[i] -= 1
#             end
#         else
#             node[i] += 0
#         end
#     end
# end



# top_5_nodes = sortperm(vec(node), rev=true)[1:5]
# println("The top 5 nodes are: ", top_5_nodes) 



# top_5_degrees = []
# # to calculate the degree of each node
# for i in 1:34
#     sum = 0
#     for j in 1:34
#         if lines[i,j] == 1
#             sum += 1
#         end
#     end
#     push!(top_5_degrees, sum)
# end

# top_5_degrees = sortperm(vec(top_5_degrees), rev=true)[1:5]
# println("The top 5 degrees are: ", top_5_degrees)


# ----------------------- The following piece of code is another defective implementation of ex6.a. DO NOT CONSIDER -----------------------------------------------
# for i in eachindex(lines)
#     if lines[i] == " "          # if we find a space, we know that the next number is the node
#         node = lines[i-1] # store the node
#         if node in keys(node_dict) # if the node is already in the dictionary, add 1 to the number of edges connected to it
#             node_dict[node] += 1 
#         else
#             node_dict[node] = 1
#         end
#     end
# end


# # sort the dictionary by the number of edges connected to it
# sorted_node_dict = sort(collect(node_dict), by = x -> x[2], rev = true)
# top_five = [];
# for i in eachindex(sorted_node_dict)
#     if i <= 5
#         push(top_five, sorted_node_dict[i])
#     end
# end
# # print the top 5 nodes
# println("The top 5 nodes are: ")
# for i in eachindex(top_five)
#     println(top_five[i]) + " with " + top_five[i][2] + " edges"
# end

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
#6b)

# Rank the five nodes with the largest eigenvector centrality.3 What are their (properly normalized) eigen- vector centralities?
# compute the pagerank to get the eigenvector centrality
# uncomment below to see the results for 6b.


"""
include("pagerank.jl")
(pr, c, r) = page_rank("", lines, 0.85)
sorted_pr = sortperm(vec(pr), rev = true)
idx = [1:34]
print("The top 5 nodes are: ", sorted_pr[1:5])
# create a graph representation to plot the Graph

x = (pr, c, r)
plot(x, title = "Eigenvector Centrality of the Karate Club Graph")
"""


#6d)

# get the eigenvectors
# add a treshold theta to the eigenvectors, if the value is greater than treshold, then it is in group 1, otherwise it is in group 2.
# if eigenvector is greater than theta, then it is in group 1, otherwise it is in group 2
# uncomment below to run the code.
"""

eigenvectors = eigvecs(lines);
second_eigenvector = eigenvectors[:,2];
sorted_eigenvector = sortperm(second_eigenvector, rev = true)

median_treshold = median(second_eigenvector);

greater_than_treshold = []
less_than_treshold = []

for i in 1:34
    if second_eigenvector[i] >= median_treshold
        # if the length is less than 16 
        if length(greater_than_treshold) < 16
            push!(greater_than_treshold, i)
        else
            push!(less_than_treshold, i)
        end
    else
        if (length(less_than_treshold) < 18)
            push!(less_than_treshold, i)
        else
            push!(greater_than_treshold, i)
        end
    end
end

println(" Values Greater Than Treshold: ", greater_than_treshold)
println("Separator Line")
println(" Values Less Than Treshold: ", less_than_treshold)
"""


