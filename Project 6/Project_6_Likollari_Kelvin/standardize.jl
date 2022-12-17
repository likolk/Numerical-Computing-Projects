using LinearAlgebra
"""
In this first part of the assignment, you are required to complete 2 functions which are part of a dummy implementation of the simplex method. 
Specifically you have to complete the TODOs in:

• standardize.jl, which writes a maximisation or minimisation input problem in standard form;
• simplexSolve.jl, which solves a maximisation or minimisation problem using the simplex method.

You are given also some already-implemented functions to help you in your task: 
simplex.jl is a wrapper which calls all the functions necessary to find a solution to the linear program; 
auxiliary.jl solves the auxiliary problem to find a feasible starting basic solution of the linear program; 
printSol.jl is a function which prints the optimal solution found by the simplex algorithm. 
Finally, testSimplex.jl presents a series of 6 problems to check if your implementation is correct, before moving to the next part of the assignment. 
Additional details to aid you in your implementation can be found in the comments inside the code.
"""
function standardize(type, A, h, c, m, sign)
    # return arguments are:
    # (1) A_aug = augmented matrix A, containing also the surplus & slack variables
    # (2) c_aug = augmented coefficients vector c [check compatibility of dimensions with A]
    # (3) h, right hand side vector [remember to flip the signs when changing the inequalities]

    aug_matrix = Int.(I(m)) # matrix corresponding to the slack/surplus variables

    if strcmp(type, "max")
        for i = 1:m
            if sign[i] == 1
                # Using a surplus instead of a slack variable
                aug_matrix[i, :] = -aug_matrix[i, :]
            end
        end
    elseif strcmp(type, "min")
        for i = 1:m
            if sign[i] == -1
                # Using a slack instead of a surplus variable
                aug_matrix[i, :] = -aug_matrix[i, :]
            end
        end
    else
        error("Incorrect type specified. Choose either a maximisation [max] | minimisation [min] problem.")
    end

    # TODO: Correction on the sign of h for auxiliary problem (we want to ensure that h>=0, but we need to flip all the signs)
    for i = 1:m
        if h[i] < 0
            h[i] = -h[i]
            A[i, :] = -A[i, :]
            aug_matrix[i, :] = -aug_matrix[i, :]

            if sign[i] == 0
                sign[i] = 1
            elseif sign[i] == 1
                sign[i] = 0
            end 
        end
    end

    c_aug = hcat(c, zeros(1, m))
    if strcmp(type, "max")
        # TODO: Extend matrix A by adding the slack variables
        # the names slack and surplus variables refer only to different signs
        A_aug = hcat(A, aug_matrix)
    elseif strcmp(type, "min")
        # TODO: Extend matrix A by adding the surplus variables
        A_aug = hcat(-A, aug_matrix)
    else
        error("Incorrect type specified. Choose either a maximisation [max] | minimisation [min] problem.")
    end

    return A_aug, h, c_aug
end