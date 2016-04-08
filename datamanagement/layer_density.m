function [ density ] = layer_density( top, thickness, phi_0, c, dens_water, dens_grain )
%layer_density Summary of this function goes here
%   Detailed explanation goes here
    center = top + thickness/2;
    phi = phi_0 * exp(-c * center);
    density = thickness * ((phi * dens_water)+((1-phi) * dens_grain));
end

