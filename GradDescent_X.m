function [guess_new,theta,x_new]=GradDescent_X(theta,x,y,r,alpha,lambda,guess)
%Gradient Descent For X
% x = features, y = actual ratings
dimfeat = size(x);
dimRatng = size(y);
x_new = zeros(size(x));
guess_new = zeros(size(y));

for i=1:dimfeat(1) %Iterate by 100
    for j=1:dimfeat(2) %iterate by 10
        if r(i,j)~=0
            %testVar = sum(((x(i,:)*theta(:,j))-y(i,j))*theta(:,j));
            testVar = sum(((x(i,:)*theta(:,j)))-y(i,j)*theta(:,j))+lambda*x(i,j); %WORKS
            x_new(i,j)=x(i,j)-alpha*testVar; %index and ' removed 
        end
    end
end

for i=1:dimRatng(1) %Iterate by 100
    for j=1:dimRatng(2) %iterate by 11000
        guess_new(i,j)=(x_new(i,:)*theta(:,j));
    end
end

end

