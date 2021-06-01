% Marla Galvan - knapsack Implementation

% ----------------------------------------------------------------------------------------------
% AUXILIAR FUNCTION: 
% Adds Element at the end of the list
% add_last(List, Element, Auxiliar)

add_last([], Y, Y):- !.

add_last([H|T], List, [H|Y]):-
    add_last(T, List, Y).

% ----------------------------------------------------------------------------------------------
% AUXILIAR FUNCTION: 
% % Get maximun number of two numbers A and B, and return it in C
% max(A,B,C)

max(A, B, A) :- A > B.
max(_A, B, B) :- !.

% ----------------------------------------------------------------------------------------------
% AUXILIAR FUNCTION: 
%  Get maximun value in a list, and return it in B
% maxinList(List, B)
maxinList(List, B):-
    maxList(List, 0, B).

maxList([], B, B):-!.

maxList([H|T], Aux, Min) :- 
    H < Aux,
    maxList(T, Aux, Min).

maxList([H|T], Aux, Min) :- 
    H >= Aux,
    maxList(T, H, Min).

% ----------------------------------------------------------------------------------------------
% AUXILIAR FUNCTION: 
%  Get the value at index I, return it in W
% getI(List, I, W)

getI(Ws, I, W):-
    getIndex(Ws, I, 0, W).

getIndex([], _I, _ACCUM, []):- !.

getIndex([W_H| _W_T], I, I, W_H):- !.

getIndex([_W_H| W_T], I, ACCUM, W):-
    NACCUM is ACCUM+1,
    getIndex(W_T, I, NACCUM, W).

% ----------------------------------------------------------------------------------------------
% AUXILIAR FUNCTION: 
%  Get the value at index I, return it in W
% getI(List, I, W)

% ----------------------------------------------------------------------------------------------
% KNAPSACK ALGORITHM

% How to call the function:
% Returns  on BestValue the maximun gain and in Matrix and a array of the linearization of the matrix
% knapsack([WeightOfObjects], [ValueOfObjects], [NumberOfObjects], [BackpackSize], BestValue, BestObjects) 

%knapsack([1,2,3,4], [1,3,4,6], 4, 6, BestValue, Matrix). % -> 9
%knapsack([1,3,4,5], [1,4,5,7], 4, 7, BestValue, Matrix). % -> 9
%knapsack([1,2,3], [10,15,40], 3, 6, BestValue, Matrix).  % -> 65
%knapsack([10,20,30], [60,100,120], 3, 50, BestValue, Matrix).  % -> 220

% Basecase: 
knapsack(0, 0, 0, 0, 0, 0):- !.

%-----------------------------------------------------------------------------------------------------------------------------------------------
% Calling of the function with auxiliar parameters
knapsack(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects):-
    NNumberOfObjects is NumberOfObjects,
    NBackpackSize is BackpackSize+1,
    kanpsack_rec(WeightOfObjects, ValueOfObjects, NNumberOfObjects, NBackpackSize, BestValue, [], 0, 0, BestObjects).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% IF I == SIZE
kanpsack_rec(_WeightOfObjects, _ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, NumberOfObjects, BackpackSize, BestObjects):- 
    maxinList(BestObjects, BestValue).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% IF I or J == 0 T[I,J] = 0
kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, 0, 0, BestObjectsAux):-
    kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, [0 | BestObjects ], 0, 1, BestObjectsAux).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% I != 0 && J == 0
kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, I, 0):-
    add_last(BestObjects, [0], NewBestObjects),
    kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, NewBestObjects, I, 1, _BestObjectsAux).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% IF  J == SIZE
kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, I, BackpackSize, BestObjectsAux):-
    NewI is I+1,
   kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, NewI, 0, BestObjectsAux).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% I == 0 && J != 0
kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, 0, J, BestObjectsAux):-
    NewJ is J+1,
    add_last(BestObjects, [0], NewBestObjects),
    kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, NewBestObjects, 0, NewJ, BestObjectsAux).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% IF I !=0 && J != 0
kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, I, J, BestObjectsAux):-
    WTindex is I-1,
    getI(WeightOfObjects, WTindex, W),
    W > J,
    NewIndex is (((BackpackSize)*I)+J)-(BackpackSize),
    getI(BestObjects, NewIndex, T),
    NewJ is J+1,
    add_last(BestObjects, [T], NewBestObjects),
    kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, NewBestObjects, I, NewJ, BestObjectsAux).

%-----------------------------------------------------------------------------------------------------------------------------------------------
% IF I != 0 && J != 0
kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, BestObjects, I, J, BestObjectsAux):-
    NewIndexA is (((BackpackSize)*I)+J)-(BackpackSize),
    getI(BestObjects, NewIndexA, A),
    Iminus1 is I-1,
    getI(ValueOfObjects, Iminus1, Val),
    getI(WeightOfObjects, Iminus1, Wt),
    NewIndexB is ((((BackpackSize)*I)+(J))-(BackpackSize))-Wt,
    getI(BestObjects, NewIndexB, B1),
    B is B1 + Val,
    max(A, B, C),
    NewJ is J+1,
    add_last(BestObjects, [C], NewBestObjects),
    kanpsack_rec(WeightOfObjects, ValueOfObjects, NumberOfObjects, BackpackSize, BestValue, NewBestObjects, I, NewJ, BestObjectsAux).


