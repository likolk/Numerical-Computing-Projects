# USI, ICS, Lugano
# Numerical Computing
"""
        epsilongraph(ϵ, pts)

Construct an epsilon similarity graph based on the size of the neighborhood ϵ (calculated from Prim's algorithm) and the coordinates list pts.
"""
function epsilongraph(epsilon, pts)

    n = size(pts, 1);
    G = zeros(n, n);
    # ----------------------------
    #     Your implementation
    # ----------------------------
    # iterating over the rows and the columns, 
    for i = 1:n
        for j = 1: n
            K = 2
            # the distance between two vertices is computed in the first place.
            dist = norm(pts[i, 1:K] - pts[j, 1:K])
             #  Afterwards, the computed distance between those two vertices is compared to the previously-found epsilon value, 
            #  where epsilon can be a number or a threshold
            if dist < epsilon
                # and in case it is less than epsilon, a matrix G is defined, where G(i, j) == G(j, i) ==  1.
                G[i, j] = 1
                G[j, i] = 1
            end
        end
    end
    return sparse(G)
end