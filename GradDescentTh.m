function [guess_new,theta_new,x]=GradDescentTh(theta,x,y,r,alpha,lambda,guess)
%Gradient Descent for Theta
% x = features, y = actual ratings
dimTheta = size(theta); %  10x11000 check
dimRatng = size(y);     % 100x11000 check
theta_new = zeros(size(theta));
guess_new = zeros(size(y));

for i=1:dimTheta(1) %Iterate by 10
    for j=1:dimTheta(2) %iterate by 11000
        if r(i,j)~=0
            %testVar =sum(((x(i,:)*theta(:,j)))-y(i,j)*x(:,j));
            testVar = sum(((x(i,:)*theta(:,j))-y(i,j))*x(i,:))+lambda*theta(i,j); %WORKS
            theta_new(i,j)=theta(i,j)-alpha*testVar; %index and ' removed
        end
    end
end

for i=1:dimRatng(1) %Iterate by 100
    for j=1:dimRatng(2) %iterate by 11000
        guess_new(i,j)=(x(i,:)*theta_new(:,j));
    end
end

end

