# USI, ICS, Lugano
# Numerical Computing
"""
        epsilongraph(ϵ, pts)

Construct an epsilon similarity graph based on the size of the neighborhood ϵ (calculated from Prim's algorithm) and the coordinates list pts.
"""
function epsilongraph(ϵ, pts)

    n = size(pts, 1);
    G = zeros(n, n);
    # ----------------------------
    #     Your implementation
    # ----------------------------
    # according to the slides, to generate the similarity matrix,
    # we need to calculate the distance between each point and all other points.
    # then we need to compare the distance with the epsilon value.
    # if the distance is smaller than epsilon, we set the similarity to 1.

    for i = 1:n
        for j = 1: n
            # the distance will be the absolute value between Pts(i) and Pts(j)
            distance = abs(pts[i] - pts[j])
            if distance < ϵ
                G[i,j] = 1
                G[j,i] = 1
            end
        end
    end
    return sparse(G)
end