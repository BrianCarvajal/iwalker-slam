function [ m, c ] = estimateLine(X, Y)
%ESTIMATELINE - Least Squares Fitting function
    %[m, c] = inv(X'*X)*X'*Y;
    Y = Y';
    X = [X' ones(1,length(X))'];
    s = (X'*X)\(X'*Y);
    m = s(1);
    c = s(2);
end

