function [normRatings] = meanNorm(ratings,r)
%Mean Normalization Normalizes the mean of the input matrix rating
%   meanNorm(ratings,r); get mean of row and subtract from row vector
dimRate=size(ratings);
mu=mean(ratings,2); % mean along the row or the joke of the ratings mtrx
normRatings = ratings-mu;
end

