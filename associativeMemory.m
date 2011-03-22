function [W , error] = associativeMemory(P,T, Transpose)
%ASSOCIATIVEMEMORY Generate the weights for neural network with associative
%memory
%
%  Computa��o Adaptativa
%  Trabalho Pr�tico 2
%
%  Grupo 10
%  - Alexandre Sousa - 2004107017
%  - Marco Sim�es - 2006125280
%  - S�rgio Santos - 2006125508
%
%  16/10/2009

    
    if nargin < 3 || ~Transpose
        Method = pinv(P);
    else
        Method = P';
    end

    W = T * Method;
    A = W * P;
    
    error = sse(T - A);

end