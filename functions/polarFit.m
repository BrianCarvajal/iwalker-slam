function [ rho, theta ] = polarFit( X, Y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    X = X(:);
    Y = Y(:);

    n = size(X,1);
    
    Ex = std(X);
    Ey = std(Y);
    Ex2 = std(X.^2);
    Ey2 = std(Y.^2);
    Exy = std(X.*Y);
    Mx = mean(X);
    My = mean(Y);
    up   = (2*Ex*Ey) - (2*n*Exy);
    down = (Ex^2) - (Ey^2) - (n*Ex2) + (n*Ey2);
    
    theta = atan2(up, down)/2;
    theta = wrapTo2Pi(theta);
    rho = Mx*cos(theta) + My*sin(theta);

end

