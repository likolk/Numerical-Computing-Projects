using DelimitedFiles, MAT, Arpack, LinearAlgebra
using Random, SparseArrays, Statistics
using Metis, Graphs, SGtSNEpi, GLMakie
using Colors, CairoMakie, PrettyTables

#   M.L. for Numerical Computing class @USI - malik.lechekhab@usi.ch
"""
    benchmark_recursive()

Run a benchmark of different meshes with different recursive partitioning method.

# Examples
```julia-repl
julia> function benchmark_recursive()
()
```
"""

function benchmark_recursive()
    #   List the meshes to compare
    meshes = ["airfoil1" "netz4504_dual" "stufe" "3elt" "barth4" "ukerbe1" "crack"]

    #   List the algorithms to recursively run and compare
    algs = ["Spectral" "Spectral" "Metis" "Metis" "Coordinate" "Coordinate" "Inertial" "Inertial"]

    #   Init result array
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)

    #   Loop through meshes
    for (i, mesh) in enumerate(meshes)
        #   Define path to mat file
        path = joinpath(dirname(@__DIR__),"Meshes","2D",mesh*".mat");

        #   Read data
        A, coords = read_mat_graph(path);

        #   1st row
        pAll[i, 1] = mesh
        #   Recursive routines # TODO: 01/11/22

        # Utilize the script bench recusrive to recursively bisect the finite element meshes loaded in 8 and 16 subgraphs. Use your inertial and spectral partition-
        # ing implementations, as well as the coordinate partitioning and the METIS bisection routine. Summarize your results
        # in 2 and comment about these results. Finally, visualize the results for p = 16 for the case ”crack”.

        #   1.  Spectral

        # use rec_bisection
        spectral_part_8 = rec_bisection("spectral_part", 3, A)
        spectral_part_16 = rec_bisection("spectral_part", 4, A)
        pAll[i, 2] = count_edge_cut(A, spectral_part_8);
        pAll[i, 3] = count_edge_cut(A, spectral_part_16);
        # was:
        # pAll[i, 2] = rec_bisection("spectral_part", 3, A)
        # pAll[i, 3] = rec_bisection("spectral_part", 4, A)

        #   2.  METIS
        alg = :RECURSIVE
        metis_part_8 = metis_part(A, 8, alg) # 8 and 16 respectively as per Malik's Slack recommendation 
        metis_part_16 = metis_part(A, 16, alg)
        pAll[i, 4] = count_edge_cut(A, metis_part_8);
        pAll[i, 5] = count_edge_cut(A, metis_part_16);
        # was:
        # pAll[i, 4] = metis_part(A, 8, alg)
        # pAll[i, 5] = metis_part(A, 16, alg)


        #   3.  Coordinate
        
        coordinate_part_8 = rec_bisection("coordinate_part", 3, A, coords)
        coordinate_part_16 = rec_bisection("coordinate_part", 4, A, coords)
        pAll[i, 6] = count_edge_cut(A, coordinate_part_8);
        pAll[i, 7] = count_edge_cut(A, coordinate_part_16);
        # was:
        # pAll[i, 6] = rec_bisection("coordinate_part", 3, A, coords)
        # pAll[i, 7] = rec_bisection("coordinate_part", 4, A, coords)
        
        #   4.  Inertial
        inertial_part_8 = rec_bisection("inertial_part", 3, A, coords)
        inertial_part_16 = rec_bisection("inertial_part", 4, A, coords)
        pAll[i, 8] = count_edge_cut(A, inertial_part_8);
        pAll[i, 9] = count_edge_cut(A, inertial_part_16);
        # was:
        # pAll[i, 8] = rec_bisection("inertial_part", 3, A, coords)
        # pAll[i, 9] = rec_bisection("inertial_part", 4, A, coords)

        #   5.  Crack p = 16
        # visualize the results for p = 16 for the case ”crack”
        if mesh == "crack"
            #draw graph 
            g = Graph(A)
            #draw graph with 16 partitions
            draw_graph(g, coords, spectral_part_16)
        end
        
    end

    #   Print result table
    header =(hcat(["Mesh"], algs), ["" "8 parts" "16 parts" "8 parts" "16 parts" "8 parts" "16 parts" "8 parts" "16 parts"])
    # # print(header[2])
    pretty_table(pAll; header = header, crop = :none, header_crayon = crayon"bold cyan")
    # # println(typeof(a))
    # return pAll
end




