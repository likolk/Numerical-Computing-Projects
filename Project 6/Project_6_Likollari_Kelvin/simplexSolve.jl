function simplexSolve(type, B, D, c_B, c_D, h, x_B, x_D, index_B, index_D, itMax)
    # Solving a maximization problem with the simplex method

    # Initialize the number of iterations
    nIter = 0

    # Compute B^{-1}*D & B^{-1}*h
    BiD = B \ D
    Bih = B \ h

    # TODO: Compute the reduced cost coefficients
    r_D = c_D - c_B * BiD

    tol = length(r_D) # the optimality condition is satisfied if all reduced cost coefficients are positive/negative (depending on the problem)

    # TODO: Check the optimality condition, in order to skip the loop if the solution is already optimal
    # The optimality condition for a maximisation problem is given by rD ≤ 0, while for a minimisation is rD ≥ 0.
    if strcmp(type, "max")
        optCheck = sum(r_D .<= 0)
    elseif strcmp(type, "min")
        optCheck = sum(r_D .>= 0)
    else
        error("Incorrect type specified. Choose either a maximisation [max] | minimisation [min] problem.")
    end
    while (optCheck != tol)
        # TODO: Find the index of the entering variable
        if strcmp(type, "max")
            # we have to get the index of the variable with the highest reduced cost coefficient. 
            # we can use argmax or findmax to get the index of the maximum value in the array.
            # we will use findmax, because it returns both the maximum value and the index of the maximum value.
            idxIN = findmax(r_D)[2]
        elseif strcmp(type, "min")
            # likewise for the minimization problem.
            idxIN = findmin(r_D)[2]
        else
            error("Incorrect type specified. Choose either a maximisation [max] | minimisation [min] problem.")
        end

        in = D[:, idxIN]
        c_in = c_D[1, idxIN]
        index_in = index_D[1, idxIN]

        # TODO: Evaluate the coefficients ratio for the column corresponding to the entering variable
        # If the optimality condition is not met, we have to decide which variable to take into the basis, 
        # by selecting the one with the highest reduced cost coefficient in case of a maximisation (or the one with the lowest for a minimisation). 
        #  In case multiple variables have the same value, we could end up swapping the same two variables over and 
        # over again, this problem is known as cycling and it could potentially hinder the capacity of the simplex method to achieve convergence to the optimal value.
        # The iterative rule of the simplex algorithm consists instead in identifying the 
        # variable that has to be taken out of the basis, by computing the ratio:
        # Among all the ratios obtained we then need to select the one with the smallest positive value. When the optimality
        # condition is met, the algorithm stops at the optimal solution of the linear program.
        # the ratio will thus be given by:
        ratio = Bih ./ BiD

        # TODO: Find the smallest positive ratio
        # we need to find the smallest positive ratio, because we want to select the variable that has the smallest
        # positive value among all the ratios obtained. In case multiple variables have the same value, we could end up swapping the same two variables over and over again,
        # this problem is known as cycling and it could potentially hinder the capacity of the simplex method to achieve convergence to the optimal value.
        idxOUT = argmin(ratio[ratio .> 0])
        #idxOUT =  findmin(ratio[ratio .> 0])[2]
        # we use .> 0 to select only the positive values.
        # the dot operator is used to apply the function to each element of the array.

 
        out = B[:, idxOUT]
        c_out = c_B[1, idxOUT]
        index_out = index_B[1, idxOUT]

        # TODO: Update the matrices by exchanging the columns
        B[:, idxOUT] = in
        D[:, idxIN] = out
        c_B[1, idxOUT] = c_in
        c_D[1, idxIN] = c_out
        index_B[1, idxOUT] = index_in
        index_D[1, idxIN] = index_out

        # Compute B^{-1}*D & B^{-1}*h
        BiD = B \ D
        Bih = B \ h

        # TODO: Compute the reduced cost coefficients
        r_D = c_D - c_B * BiD

        # TODO: Check the optimality condition
        if strcmp(type, "max")
            optCheck = sum(r_D .<= 0)
        elseif strcmp(type, "min")
            optCheck = sum(r_D .>= 0)
        else
            error("Incorrect type specified. Choose either a maximisation [max] | minimisation [min] problem.")
        end

        # Detect inefficient loop if nIter .> total number of basic solutions
        nIter = nIter + 1
        if(nIter > itMax)
           error("Incorrect loop, more iterations than the number of basic solutions")
        end

        # TODO: Compute the new x_B
        x_B = Bih
    end

    return x_B, c_B, index_B
end
