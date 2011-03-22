function net = trainNetwork(data, creationFcn, transferFcn, learnFcn, performFcn)
%TRAINNETWORK Create and train a neural network
%
%  Computação Adaptativa
%  Trabalho Prático 2
%
%  Grupo 10
%  - Alexandre Sousa - 2004107017 
%  - Marco Simões - 2006125287
%  - Sérgio Santos - 2006125508
%
%  16/10/2009

    if nargin < 1
       % Load the default training data
       load('PTreino900.mat');
       data = PTreino; 
    end
    
    if nargin < 5
       % Load the default neural network parameters
       
       creationFcn = 'newp';
       % newp       Create perceptron
       % newff      Create feedforward backpropagation network
           
       transferFcn = 'logsig';
       %
       % hardlim    Hard-limit transfer function
       % hardlims   Symmetric hard-limit
       % purelin    Linear transfer function
       % logsig     Log-sigmoid transfer function
            
       learnFcn = 'learnp';
       % learnp     Perceptron weight and bias learning function
       % learnh     Hebb weight learning function
       % learnhd	Hebb with decay weight learning rule
       % learngd    Gradient descent weight/bias learning function
      
       performFcn = 'sse';
       % sse        Sum squared error performance function
       % mse        Mean squared error performance function
    end

    nA = 10;
    [nP, nCases] = size(data);
    
    T = generateTarget(nCases);
    
    if strcmp(creationFcn,'newp')
        net = newp( ones(nP,1)*[0 1], nA , transferFcn, learnFcn );
    else
        net = newff( ones(nP,1)*[0 1] , nA, {transferFcn}, 'trainlm');
    end
    
    % Insert random weights
    W = 0.1*rand(10,256);
    b = 0.1*rand(10,1);
    net.IW{1,1} = W;
    net.b{1,1} = b;
    
    net.performParam.ratio = 0.5;   % learning rate
    net.trainParam.epochs = 1000;   % maximum epochs
    net.trainParam.show = 35;       % show
    net.trainParam.goal = 1e-4;     % goal=objective
    net.performFcn = performFcn;    % criterion

    % Train the neural network
    net = train(net,data,T);

end

function T = generateTarget(nCases)
% CHAR FORMAT:
% 1 2 3 4 5 6 7 9 0
% 1 2 3 4 5 6 7 9 0
% ...

    T = zeros(10,nCases);
    for i = 0 : nCases-1
        T( mod(i,10)+1, i+1 ) = 1;
    end
end