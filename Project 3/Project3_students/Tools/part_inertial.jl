#   M.L. for Numerical Computing class @USI - malik.lechekhab@usi.ch 
"""
    inertial_part(A, coords)

Compute the bi-partions of graph `A` using inertial method based on the `coords` of the graph.

# Examples
```julia-repl
julia> inertial_part(A, coords)
 1
 ⋮
 2
```
"""


function inertial_part(A, coords)
    
    """
    from (https://people.eecs.berkeley.edu/~demmel/cs267/lecture18/lecture18.html) - written as a 
    comment for my own convenience while solving this exercise.

    Inertial Partitioning is very simple as, for a graph with 2D coordinates, it chooses a line such that 
    half the nodes are on one side of the line, and half on the other.
    This can be done as follows (in 2D, but also in 3D)
    1. Choose a straight line L, given by a*(x-xbar) + b*(y-ybar) = 0. This is a straight line through (xbar, ybar) with slope -a/b. Without loss
    of generality we assume tnat a^2 + b^2 = 1.
    2. For each node ni = (xi, yi), compute a coordinate by computing the dot product Si = -b*(xi-xbar) + a*(yi-ybar). Si is the distance from (xbar, ybar) of the projection of 
    (xi, yi) onto the line L.
    3. Find the median value Sbar of the Si's.
    4. Partition the nodes into two sets, one with Si <= Sbar, and one with Si > Sbar. The complexity of the algorithm is 
    linear. It remains to show how to pick the line L. 
    Intuitively, if the nodes are located in a long, thin region of the plane, we would want to pick L along the long axis.
    In mathematical terms, we want to pick a line such that the sum of squares of the lengths of the green lines in the figure are minimized. This is also called doing a 
    total least squares fit of a line to the nodes. In physical terms, if we think of the nodes as unit masses, we choose (x, y)
    to be the axis about which the moment of inertia of the nodes is minimized.
    This is why the method is called inertial partitioning. This means choosing a, b, xbar, ybar so that a^2 + b^2 = 1.
    """
    #   1.  Compute the center of mass.

    # to compute the center of mass points we need to compute the sum of the x and y coordinates and divide by the number of points.
    x_centroid = sum(coords[:,1]) / size(coords[:, 1])[1] # sum the first column of the coords matrix
    y_centroid = sum(coords[:,2])/ size(coords[:, 2])[1] 



    #   2.  Construct the matrix M. (see pdf of the assignment)

    # as we see in the slides, matrix M is defined as an 2x2 square matrix, and at the same time symmetric as stated.
    # M = [Sxx, Sxy; Sxy, Syy]
    # thus we need to calculate Sxx, Sxy, and Syy 

    Sxx_1 = coords[:, 1] .- x_centroid
    Sxx_2 = (Sxx_1) .^ 2
    Sxx = sum(Sxx_2)

    # similar procedure shall be followed for Sxy and Syy 
    Sxy_1 = coords[:,  1] .- x_centroid
    Sxy_2 = coords[:,  2] .- y_centroid
    Sxy_3 = Sxy_1 .* Sxy_2
    Sxy = sum(Sxy_3)

    # Syy 
    Syy_1 = coords[:,  2] .- y_centroid;
    Syy_2 = Syy_1 .^ 2
    Syy = sum(Syy_2);

    # Therefore the final matrix M will be composed of these vectors and is seen below 
    M = [Sxx Sxy; Sxy Syy];

    #   3.  Compute the eigenvector associated with the smallest eigenvalue of M.

    # we calculate the normalized eigenvector u corresponding to the smallest eigenvalue of M.

    # k, smallest_eigenvector = eigs(M, nev = 1, which=:SR)
    e = eigen(M)
    # smallest_normalized_eigenvector = smallest_eigenvector / norm(smallest_eigenvector) # we divide because we would like the eigenvector u to be normalized.
    u = e.vectors[:,2]

    #   4.  Partition the nodes around line L 
    #       (use may use the function partition(coords, eigv))

    """
    # we first try to figure out which is line L
    # Line L will be composed of x and y points 
    """
    x_line_point = x_centroid + u[1];
    y_line_point = y_centroid + u[2];

    # thus the line L will be a vector of x and y
    L = [x_line_point; y_line_point];

    # now we partition the x and y points using the provided partition function
    v1, v2 = partition(coords, L);



    #   5.  Return the indicator vector
    indicator_vector = ones(Int, size(A)[1]);
    # we will have 2 vertex sets, V1 and v2, one for the points above and the other for the points below the line/
    # V1 = []
    # V2 = []

    # for i in 1:size(u)[1]
    #     if partition(coords, L)[i] == 1
    #         # push!(V1, coords[i])
    #         indicator_vector[i] = 1

    #     else
    #         # push!(V2, coords[i])
    #         indicator_vector[i] = 2
    #     end
    # end
    indicator_vector[v1] .= 1
    indicator_vector[v2] .= 2
    # for i in eachindex(coords)
    #     if coords[i] in V1
    #         indicator_vector[i] = 1
    #     else
    #         indicator_vector[i] = 2
    #     end
    # end

    return indicator_vector
end