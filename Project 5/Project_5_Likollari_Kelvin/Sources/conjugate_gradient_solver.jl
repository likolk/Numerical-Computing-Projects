using LinearAlgebra
using SparseArrays
using IterativeSolvers
using Preconditioners
using MAT
using Plots

# function myCG(A, b, x0, maxitr, tol)
#     x = x0
#     rvec = []
#     r = b - A*x
#     p = r
#     rvec = [norm(r)]
#     for i = 1:maxitr
#         Ap = A*p
#         alpha = (r'*r)/(p'*Ap)
#         x = x + alpha*p
#         r = r - alpha*Ap
#         beta = (r'*r)/(rvec[i]^2)
#         p = r + beta*p
#         push!(rvec, norm(r))
#         if norm(r) < tol
#             break
#         end
#     end
#     return x, rvec
# end

    

function myCG(A, b, x0, maxitr, tol)
    x = x0
    rvec = [] # rvec is a vector containing the norm of the residual at every iteration, in the beginning, empty.
    r = b - A * x0
    d = r
    p_old = dot(r, r)
    for i in 1:maxitr
        q = A * d
        alpha = p_old / dot(d, q)
        x = x + alpha * d
        r = r - alpha * q
        push!(rvec, norm(r))
        if norm(r) < tol
            break
        end
        p_new = dot(r, r)
        beta = p_new / p_old
        d = r + beta * d
        p_old = p_new
    end
    return x, rvec
end
    
