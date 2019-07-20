%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nicholas Heredia, Mark Bely
% Gradient Descent Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%=========================== Data Read in ==============================%%
prmpt='Use included data file (1) or your own (2)?';
fileChoice=input(prmpt);
if fileChoice==1
    dataFull = xlsread('jester-data-1.xls');
else
    prmpt='Enter the directory of the file you wish to use: ';
    direct = input(direct);
    dataFull = xlsread(direct);
end
ratings = dataFull';

%%=======================Variable Declarations===========================%%
disp('10 Features are set');
prmpt='Please enter an alpha: default \alpha=0.0005: ';
alpha=input(prmpt);
prmpt='Please enter a lambda: default \lambda=0.00001: ';
lambda=input(prmpt); features = 10; error = 1; 
% Alpha = 0.25 seems to diverge the error
% Consider ^^ changing for ^^ faster learning rate

%%==================This is where the fuin begins==================
dataSize = size(dataFull);
numUsers = dataSize(1); numJokes = dataSize(2);

theta = rand(features, numUsers);
featV = rand(numJokes, features);
prmpt='What is the variable for unrated jokes? default=99 ';
var2Elim=input(prmpt);
ratings(ratings==var2Elim)=0;
r_matrx=ratings./ratings;r_matrx(isnan(r_matrx))=0;
guess = zeros(size(ratings));

normRat = meanNorm(ratings,r_matrx);

[guess_new,theta,featV]...
    =GradDescentTh(theta,featV,ratings,r_matrx,alpha,lambda,guess);
errIn=1;
error(errIn) = sum(sum((guess_new - guess).^2));
guess=guess_new;
%guess_new=GradDescentTh(theta,featV,ratings,r_matrx,alpha, lambda, guess);


%%=====================Calculating new User Theta==========================
while (error>10)
    errIn = errIn+1;
    
    [guess_new,theta,featV]=...
        GradDescent_X(theta, featV,ratings,r_matrx,alpha, lambda, guess);
    guess=guess_new.*r_matrx;
    
    [guess_new,theta,featV]=...
        GradDescentTh(theta, featV,ratings,r_matrx,alpha, lambda, guess);
    error(errIn) = sum(sum((guess_new.*r_matrx - guess.*r_matrx).^2));
    
    guess=guess_new.*r_matrx;
    txt = ['Error difference is ',num2str(error(errIn))];
    disp(txt);
    if error(errIn-1)<error(errIn)
        disp('Algorithm has reached local mimima. Proceeding to next phase');
        break;
    end
end

fileID=fopen('Best Error.txt','w');
fprintf(fileID,'%6s %12s\r\n','Cycle','Error');
fprintf(fileID,'%6.2f ',error);

fclose(fileID);
cyc=1:errIn-1;
figure(1);
title('Error Curve');
semilogy(cyc,error);
ylabel('Error, log(error)');
xlabel('Cycles');

userTheta=zeros(features,4);
userRatng=zeros(numJokes,1);

suggJokes = input('How many jokes would you like suggested? ');

for i=1:suggJokes
    txt=(['Referring to the text file; '...
        ' please read and from -10 to 10, rate the joke  ',num2str(i)]);
    rating=input(txt);
    userRatng(i)=rating;
end

userRatng=[2,-5,5,5,6];

% for r=1:4
%     userTheta(i,:)=userRatng(r)./featV(i,:);
% end
errUser=100;
errDif=1;

% userTheta2=mean(userTheta,1); %averages all theta columns to get user Theta
% while (errUser>10 && errDif >0)
%     [guess_new,theta,featV]=...
%             GradDescentTh(theta, featV,ratings,r_matrx,alpha, lambda, guess);
%     errorNew = sum(sum((guess_new.*r_matrx - guess.*r_matrx).^2));
%     errDif=errorNew-errUser;
%     txt = ['Error difference is ',num2str(errUser)];
%     disp(txt);
%     errUser=errorNew;
% end

maxRating = max(userRatng);
indMax=userRatng(userRatng==maxRating);%gets index of max rating
bestJoke=featV(indMax,:); %gets feeatures (x) of best joke


userRecommendCloseness = zeros(numJokes,1);
for rec=6:dataSize(2) %going to find jokes which match highest rating
    userRecommendCloseness(rec)=sum((featV(rec,:)-bestJoke).^2);
end

n = 5;
val = zeros(n,1);
for i=1:n
  [val(i),idx] = min(userRecommendCloseness);
  while (userRecommendCloseness(idx)==0)
      userRecommendCloseness(idx) = [];
      [val(i),idx] = min(userRecommendCloseness);
  end
  val(i)=idx;
  % remove for the next iteration the last smallest value:
  userRecommendCloseness(idx) = [];
end

% for i=1:n
%     
%     [minimum,idx]=min(userRecommendCloseness);
%     while (userRecommendCloseness(idx)==0)
%         userRecommendCloseness(idx)=[];
%         n=n-1;
%         [minimum,idx]=min(userRecommendCloseness);
%     end
%     val(i)=idx;
%     userRecommendCloseness(idx)=[];
% end

%disp('5 Recommended jokes are ',num2str(val));
fileID=fopen('RecommendedJokes.txt','w');
fprintf(fileID,'%6s %12s\r\n','Next_Jokes','joke_ID');
fprintf(fileID,'%6.2f ',val);

        


    
    
    
    
    
    
    