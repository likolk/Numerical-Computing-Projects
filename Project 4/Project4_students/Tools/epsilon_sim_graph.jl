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
    for i = 1:n
        for j = 1: n
            K = 2
            dist = norm(pts[i, 1:K] - pts[j, 1:K])
            if dist < epsilon
                G[i, j] = 1
                G[j, i] = 1
            end
        end
    end
    return sparse(G)
end