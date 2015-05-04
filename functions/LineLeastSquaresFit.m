function [P, C] = LineLeastSquaresFit(X, Y)
%LINELEASTSQUARESFIT - Fit a line from X and Y samples
%
%   Applies the Least Square Fit method to the data (X,Y) to fit a line.  
%   Returns the estimated parameters P and the covariance matrix C
%
%   P = LINELEASTSQUARESFIT(X,Y) - Returns the paremeters P that best 
%                                  fits the data: Ye = P(1)*X + P(2)
%       
%   [P C] = LINELEASTSQUARESFIT(X,Y) - Also returns the covariance matrix

    Y = Y';
    M = [X' ones(1,length(X))'];
    
    % least squares fit
    P = (M'*M)\(M'*Y); % = inv(M'*M)*M'*Y
    
    if nargout == 2
        % covariance matrix
        Ye = X'*P(1) + P(2);
        s = std(Y-Ye);    
        C = (s^2)*inv(M'*M);
    end
end

