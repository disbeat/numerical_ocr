function TP2
%TP2 Run the practical assignment no 2
%
%  Computação Adaptativa
%  Trabalho Prático 2
%
%  Grupo 10
%  - Alexandre Sousa - 2004107017
%  - Marco Simões - 2006125280
%  - Sérgio Santos - 2006125508
%
%  16/10/2009

    warning off NNET:Obsolete

    disp ' '
    disp '--- ASSOCIATIVE MEMORY ---'
    
    disp 'Load training data'
    load('PTreino900.mat');
    trainingData = PTreino;

    disp 'Load perfect data'    
    load('PerfectArial.mat');
    trainingTarget = repmat( Perfect, 1, size(trainingData,2) / size(Perfect,2) );

    disp 'Train the associative memory: pinv'
    [filterW, error] = associativeMemory(trainingData,trainingTarget);
    disp( ['Error (sum of squares): ' num2str(error) ] );
    
    disp ' '
    disp 'Train the associative memory: transposed'
    [filterWH, error] = associativeMemory(trainingData,trainingTarget,1);
    disp( ['Error (sum of squares): ' num2str(error) ] );
    
    
    disp ' '
    disp '--- CLASSIFICATION ---'


    % Without filter
    load('PTreino900.mat');
    trainingData = PTreino;
    
    % With filter
    disp 'Load training data'
    trainingDataFilter = trainingTarget; 
    trainingDataFilterH = applyFilter(trainingData, filterWH);

    networks = getNetworks(trainingData);
    networksFilter = getNetworks(trainingDataFilter);
    networksFilterH = getNetworks(trainingDataFilterH);
    
    disp ' '
    disp '--- TESTS ---'
    
    load('PTeste.mat');
    testingData = PTeste;
    load('PDefect.mat');
    testingDefectData = PDefect;
    
    % Add filter pinv
    testingDataFilter = applyFilter(testingData, filterW);
    testingDefectDataFilter = applyFilter(testingDefectData, filterW);
    
    % Add filter transposed
    testingDataFilterH = applyFilter(testingData, filterWH);
    testingDefectDataFilterH = applyFilter(testingDefectData, filterWH);
    
    

    for networkId = 1:length(networks)
        disp ' '
        disp( networkId);
        
        disp 'WITHOUT FILTER'
        disp 'Normal test'
        simulate(networks(networkId), testingData);
        disp 'Defect test'
        simulate(networks(networkId), testingDefectData);
        
        disp ' '
        disp 'WITH FILTER'
        disp 'Normal test pinv'
        simulate(networksFilter(networkId), testingDataFilter);
        disp 'Defect test pinv'
        simulate(networksFilter(networkId), testingDefectDataFilter);
        
        disp 'Normal test transposed'
        simulate(networksFilterH(networkId), testingDataFilterH);
        disp 'Defect test transposed'
        simulate(networksFilterH(networkId), testingDefectDataFilterH);
    end
    
    
end

function networks = getNetworks(trainingData)
% Networks to be tested
    networks = ...
        [
          trainNetwork(trainingData, 'newp', 'hardlim',  'learnp',   'sse')
%           trainNetwork(trainingData, 'newp', 'hardlims', 'learnp',   'sse')
%           trainNetwork(trainingData, 'newp', 'purelin',  'learnp',   'sse')
%           trainNetwork(trainingData, 'newp',  'logsig',   'learnp',   'sse')
%           trainNetwork(trainingData, 'newff', 'hardlim',  'learnh',   'sse')
%           trainNetwork(trainingData, 'newff', 'hardlims', 'learnh',   'sse')

%           trainNetwork(trainingData, 'newff', 'purelin',  'learnh',   'sse')
%           trainNetwork(trainingData, 'newff', 'logsig',   'learnh',   'sse')
%           trainNetwork(trainingData, 'newff', 'purelin',  'learnhd',  'sse')
%           trainNetwork(trainingData, 'newff', 'logsig',   'learnhd',  'sse')  
%           trainNetwork(trainingData, 'newff', 'purelin',  'learngd',  'sse')
%           trainNetwork(trainingData, 'newff', 'logsig',   'traingd',  'sse')
          
        ];
    
end

function generateStats(classification, target)
% Calculate percentages and present results
    nCases = length(classification);    
    
    notClassified = length( find( classification == -1 ) );
    notPercentage = (notClassified/nCases)*100;
    correctClassified = length(find(classification == target));
    correctPercentage = (correctClassified/nCases)*100;
    incorrectPercentage = 100-correctPercentage-notPercentage;
    
    disp(sprintf('N\t\tUND\t\tINC\t\tCOR'));
    disp(sprintf('%d\t\t%.0f%%\t\t%.0f%%\t\t%.0f%%', ...
         nCases,notPercentage,incorrectPercentage,correctPercentage));


end

function simulate(net, testingData)
% Simulate and present stats for a given network and testing data
    nCases = size(testingData,2);
    testingInx = 1:nCases;

    testingTarget = generateTestingTarget(nCases);
    classification = classify(testingData, testingInx, net);

    generateStats(classification, testingTarget);
end

function target = generateTestingTarget(nCases)
% FORMAT:
% 1 2 3 4 5 6 7 9 0
% 1 2 3 4 5 6 7 9 0
% ...
    target = mod(1:nCases,10);
    target( target == 0 ) = 10;
end



function result = applyFilter(data, filterW)
% Apply the associative memory filter on the data

    numlinhasP = size(data,1);
    netAM = newff(ones(numlinhasP,1)*[0 1], numlinhasP, {'purelin'});
    netAM.IW{1, :} = filterW;
    
    numlinhasW = size(filterW,1);
    
    b = zeros(numlinhasW,1);
    netAM.b{1} = b;
    
    result = sim(netAM, data);

%     % Normalize filter results
%     result = result + abs(min(min(result)));
%     result = round(result / max(max(result)));
%     result = min(max(round(result),0),1);    
    
end


