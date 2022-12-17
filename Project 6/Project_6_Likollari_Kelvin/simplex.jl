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
function simplex(type, A, h, c, sign)
    # Simplex method solver for a linear programming problem
    # Input arguments:
    #   type = "max' for maximization; 'min" for minimization
    #   A    = matrix holding the constraints coefficients
    #   h    = coefficients of the constraints inequalities [rhs vector]
    #   c    = coefficients of the objective function
    #   sign = vector holding information about the constraints if the system()
    #          needs to be standardized [-1: less or equal, 0: equal, 1:vgreater | equal]

    m = size(A, 1)
    n = size(A, 2)

    # TODO: Compute the maximum number of basic solutions of the original problem [i.e., the maximum number of iterations necessary to solve the problem]
    itMax = m * n
    # if the number of iterations is greater than itMax, then the problem is unbounded

    # Writing the problem in standard form
    A_aug, h, c_aug = standardize(type, A, h, c, m, sign)

    # Determining a starting feasible initial basic solution
    B, D, c_B, c_D, x_B, x_D, index_B, index_D = auxiliary(A_aug, c_aug, h, m, n)

    # Solving the linear programming problem with the Simplex method
    x_B, c_B, index_B = simplexSolve(type, B, D, c_B, c_D, h, x_B, x_D, index_B, index_D, itMax)

    # TODO: Compute the value of the objective function,
    # we need to multiply the coefficients of the objective function with the values of the basic variables
    z = c_B' * x_B
    if strcmp(type, "min")
        z = -z
    end

    # moreover, we need to add the value of the artificial variables
    for i = 1:n
        if index_B[i] > m
            z += c_aug[index_B[i]]
        end
    end
    # Output of the solution
    x_B, index_B = printSol(z, x_B, index_B, m, n)

    return z, x_B, index_B
end
