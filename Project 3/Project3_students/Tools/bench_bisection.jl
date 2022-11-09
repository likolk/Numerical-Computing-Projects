#   M.L. for Numerical Computing class @USI - malik.lechekhab@usi.ch 
"""
    benchmark_bisection()

Run a benchmark of different meshes with different partitioning method.

# Examples
```julia-repl
julia> benchmark_bisection()
```
"""

using PrettyTables
using Crayons
import Pkg;
Pkg.add("PrettyTables")
Pkg.add("Crayons")




function benchmark_bisection()
    #   List the meshes to compare
    meshes = ["grid(12, 100)" "grid(100, 12)" "grid(100, 12, -π/4)" "gridt(50)" "gridt(40)" "smallmesh" "tapir" "eppstein"]

    #   List the algorithms to compare
    algs = ["Coordinate" "Metis" "Spectral" "Inertial"]

    #   Init comparison table
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)

    #   Load Adj. Matrices and coordinates
    data = [
        grid(12, 100);
        grid(100, 12);
        grid(100, 12, -π/4);
        gridt(50);
        gridt(40);
        getData("smallmesh");
        getData("tapir");
        getData("eppstein")
    ];

    #   Loop through meshes
    for (i, mesh) in enumerate(meshes)
        A = data[i][1];
        coords = data[i][2];
        pAll[i, 1] = mesh

        #   Coordinate bisection
        pCoordinate = coordinate_part(A, coords);
        pAll[i, 2] = count_edge_cut(A, pCoordinate);

        #   METIS bisection
        pMetis = metis_part(A, 2, :KWAY);
        pAll[i, 3] = count_edge_cut(A, pMetis);

        #   Spectral bisection
        pSpectral = spectral_part(A);
        pAll[i, 4] = count_edge_cut(A, pSpectral);

        #   Inertial bisection
        pInertial = inertial_part(A, coords);
        pAll[i, 5] = count_edge_cut(A, pInertial);         
    end

    #   Print table
    header =(hcat(["Mesh"], algs), ["" "" "v.5.1.0" "" ""])
    pretty_table(pAll; header = header, crop = :none, header_crayon = crayon"bold green")

end