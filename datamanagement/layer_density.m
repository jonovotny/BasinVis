function [ density ] = layer_density( top, thickness, phi_0, c, dens_water, dens_grain )
%layer_density Summary of this function goes here
%   Detailed explanation goes here
    center = top + thickness/2;
    phi = phi_0 * exp(-center/c);
    density = thickness * ((phi * dens_water)+((100-phi) * dens_grain))/100;
end

