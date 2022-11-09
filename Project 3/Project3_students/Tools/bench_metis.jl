#   M.L. for Numerical Computing class @USI - malik.lechekhab@usi.ch
"""
    benchmark_metis()

Run a benchmark of different meshes with METIS partitioning method.

# Examples
```julia-repl
julia> benchmark_metis()
```
"""

function benchmark_metis()

    file_commanche_dual, c = getData("commanche_dual");
    file_skirt, d = getData("skirt");

    #   List the meshes to compare
    meshes = ["Commanche", "skirt"]

    #   List the algorithms to compare
    algs=["RECURSIVE", "KWAY"]

    #   Init comparison table
    pAll = Array{Any}(undef, 4, 3) 

    #   Load Adj. Matrices and coordinates
    data = [
        getData("commanche_dual");
        getData("skirt")
    ];

    #   Loop through meshes
   
        

        #16 recursive and 16 direction for helicopter
        pMetis1 = metis_part(file_commanche_dual, 16, :RECURSIVE)
        pMetis2 = metis_part(file_commanche_dual, 16, :KWAY)
        pAll[1, 1] = "16-recursive bisection"
        pAll[1, 2] = count_edge_cut(file_commanche_dual, pMetis1);
        pAll[2, 2] = count_edge_cut(file_commanche_dual, pMetis2);

        # 16 recursive and 16 direct for skirt
        pMetis5 = metis_part(file_skirt, 16, :RECURSIVE)
        pMetis6 = metis_part(file_skirt, 16, :KWAY)
        pAll[2, 1] = "16-way direct bisection"
        pAll[1, 3] = count_edge_cut(file_skirt, pMetis5);
        pAll[2, 3] = count_edge_cut(file_skirt, pMetis6);
  

        # 32 recursive and 32 direct for helicopter
        pMetis3 = metis_part(file_commanche_dual, 32, :RECURSIVE)
        pMetis4 = metis_part(file_commanche_dual, 32, :KWAY)
        pAll[3, 1] = "32-recursive bisection"
        pAll[3, 2] = count_edge_cut(file_commanche_dual, pMetis3);
        pAll[4, 2] = count_edge_cut(file_commanche_dual, pMetis4);


      
        # 32 recursive and 32 direct for skirt
        pMetis7 = metis_part(file_skirt, 32, :RECURSIVE)
        pMetis8 = metis_part(file_skirt, 32, :KWAY)
        pAll[4, 1] = "32-way direct bisection"
        pAll[3, 3] = count_edge_cut(file_skirt, pMetis7);
        pAll[4, 3] = count_edge_cut(file_skirt, pMetis8);


        #   3.  Visualize the results for 16 and 32 partitions.
        # toggle commenting to visualize. please uncomment only one command at a time.
        # draw_graph(file_commanche_dual, c, pMetis1);
        # draw_graph(file_commanche_dual, c, pMetis2);
        # draw_graph(file_commanche_dual, c, pMetis3);
        # draw_graph(file_commanche_dual, c, pMetis4);
        # draw_graph(file_skirt, d, pMetis5);
        # draw_graph(file_skirt, d, pMetis6);
        # draw_graph(file_skirt, d, pMetis7);
        # draw_graph(file_skirt, d, pMetis8);


    #   Print the table and its header 
    # toggle commenting when wanting to generate the graphs or generating the table.
    # header =(("Partitions", "Helicopter", "Skirt"), ("", "", "", "", ""))
    # pretty_table(pAll; header = header, crop = :none, header_crayon = crayon"bold green")


end

