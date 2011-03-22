function result = classify(data, inx, net)
%CLASSIFY Classify the given characters using a neural network
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

    if nargin < 3
        net = trainNetwork();
    end
    
    net_result = sim(net, data);
    
    % Set the result into the format needed at ocr_fun
    nCases = length(inx);
    result = ones(1,nCases) * -1;
    
    for n_case = 1 : nCases
        case_result = find(net_result(:,inx(n_case)) == max(net_result(:,inx(n_case))));
        if length(case_result) == 1
            result(n_case) = case_result;
        end
    end

end