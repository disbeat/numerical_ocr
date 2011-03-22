%-------------------------------------------------------------
%    DEI - Computacao Adaptativa 2009
%     fun��o adaptada da fun��o com o mesmo nome de
%    Jorge Henriques (Outubro de 2005)
%-------------------------------------------------------------

% Esta fun��o grafica uma, duas ou tr�s entradas dadas cada uma por um vector 256x1 
% imagem bin�ria de um car�cter desenhado numa grelha de 16x16 (obtido pela
% fun��o mpaper).
% A fun��o grafica pode ter um, dois ou tr�s argumentos (nargin d� o seu n�mero).
% Antes de graficar � necess�rio aplicar a fun��o reshape do Matlab que
% transforma cada vector 256x1 numa matriz (recticulado) 16x16, com 0's e
% 1's. Este recticulado � depois desenhado linha a linha. Conforme cada
% c�lula cont�m 0 ou 1, assim se desenha um quadrado vermelho vazio ou um quadrado
% azul com um * dentro.

%    RESHAPE(X,M,N) returns the M-by-N matrix whose elements
%    are taken columnwise from X.  An error results if X does
%   not have M*N elements.
 
%    RESHAPE(X,M,N,P,...) returns an N-D array with the same
%    elements as X but reshaped to have the size M-by-N-by-P-by-...
%    M*N*P*... must be the same as PROD(SIZE(X)).

% Pode-se usar escrevendo na linha de comando do Matlab por exemplo 
%  grafica(P(:,1),P(:,2),P(:,3)), obtendo-se o tra�ado dos tr�s primeiros
%  caracteres desenhados nas 3 primeiras c�lulas da grelha da fun��o
%  mpaper. Pode acontecer que os pequenos quadrados apare�am muito
%  pr�ximos. Neste caso aumenta-se a janela da imagem, com o rato.
%  Outubro 2009.


function xx=grafica(X,Y,Z)

n=nargin;

clf
[nL,nC]=size(X);
M=[];
for i=1:nC
    M=[M reshape(X(:,i),16,16)];
end
X=M;
[nL,nC]=size(X);

hold on
incx= 0.15;
incy=-0.02;
yini=1;
xini=1;

% definir as escalas dos eixos
axis([xini 8.5 0.5 1.05]);

% grafica o primeiro argumento
% plots the first argument
for i=1:nL
    for j=1:nC
        if (X(i,j)==0)
            plot(xini+j*incx,yini+i*incy,'sr');
        else
            plot(xini+j*incx,yini+i*incy,'sk',xini+j*incx,yini+i*incy,'*');
        end
    end
end

% grafica o segundo argumento, se existir
% plots the second argument, if it exists.
if n>1
    %---------------------------------
    Y=reshape(Y,16,16);
    for i=1:nL
        for j=1:nC
            if (Y(i,j)==0)
                plot(xini+(j+nC)*incx,yini+i*incy,'sr');
            else
                plot(xini+(j+nC)*incx,yini+i*incy,'sk',xini+(j+nC)*incx,yini+i*incy,'*');
            end
        end
    end
end

% grafica o terceiro argumenro, se existir
%plots the third argument, if it exists

if n>2
    %---------------------------------
    Z=reshape(Z,16,16);
    for i=1:nL
        for j=1:nC
            if (Z(i,j)==0)
                plot(xini+(j+2*nC)*incx,yini+i*incy,'sr');
            else
                plot(xini+(j+2*nC)*incx,yini+i*incy,'sk',xini+(j+2*nC)*incx,yini+i*incy,'*');
            end
        end
    end
end


