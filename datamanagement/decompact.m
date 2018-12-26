function [ thickness ] = decompact( phi_0, c, top_p, bottom_p, top_decomp)
%decompact 
%
thickness_p = bottom_p - top_p;
if thickness_p == 0
    thickness = 0;
    return
end
center_p = (bottom_p + top_p)/2;
phi_p = phi_0 * exp(-center_p/c);
syms d;
%thickness = 2 * eval(solve((2*d)*(1-phi_0 * exp(-c * (d+top_decomp))) - (1-phi_p)*thickness_p, d));
solution = vpasolve((2*d) == (100-phi_p) * thickness_p / (100-(phi_0 * exp(-(d + top_decomp)/c))), d);
thickness = 2 * eval(solution);

end

