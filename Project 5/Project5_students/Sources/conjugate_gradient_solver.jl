using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots

function myCG(A, b, x0, maxitr, tol)  # use cg() function for comparison
    x = x0
    rvec = [] # rvec is a vector containing the norm of the residual at every iteration, in the beginning, empty.
    r = b - A * x0
    d = r
    p_old = dot(r, r)
    for i = 1:maxitr
        s = A * d
        alpha = p_old / dot(d, s)
        x = x + alpha * d
        r = r - alpha * s
        p_new = dot(r, r)
        beta = p_new / p_old
        d = r + beta * d
        p_old = p_new
        # norm of the residual at every iteration
        # rvec[i] = norm(r)
        # check whether the norm of r is less than the tolerance 
        if norm(r) < tol 
            break
        end
    end
    return x, rvec
end




