board([[], 
	[], 
	[], 
	[], 
	[], 
	[], 
	[]]).

% can_play(Board)
% Verifica si alguna columna tiene menos de 6 elementos.
can_play(Board) :-
    member(Column, Board),              
    is_list(Column),                     
    count_elements(Column, 0, Count),     
    Count < 6,
    !.                                  

% count_elements(List, Acc, Count)
% Cuenta los elementos de una lista manualmente.
count_elements([], Count, Count).        
count_elements([_|Tail], Acc, Count) :-   
    NewAcc is Acc + 1,
    count_elements(Tail, NewAcc, Count).




% play_piece(EmptyBoard, Column, Piece, NewBoard)

play_piece(EmptyBoard, Column, Piece, NewBoard) :-
    nth0(Column, EmptyBoard, ColumnList), 
    place_piece(ColumnList, Piece, NewColumnList), 
    replace_column(EmptyBoard, Column, NewColumnList, NewBoard). 

% place_piece(ColumnList, Piece, NewColumnList)
% Coloca la ficha en la posición más baja disponible de la columna.
place_piece(ColumnList, Piece, NewColumnList) :-
    length(ColumnList, Length),  
    Length < 6,
    append(ColumnList, [Piece], NewColumnList).

% replace_column(Board, Column, NewColumnList, NewBoard)
% Reemplaza la columna en el tablero con la nueva columna modificada.
replace_column([_|Tail], 0, NewColumnList, [NewColumnList|Tail]).
replace_column([Head|Tail], N, NewColumnList, [Head|NewTail]) :-
    N > 0,
    N1 is N - 1,
    replace_column(Tail, N1, NewColumnList, NewTail).



% Predicado principal para verificar la victoria vertical
check_vertical_win(Board, Winner) :-
    check_columns(Board, Winner).

% Recorrer las columnas
check_columns([Column|_], Winner) :-
    check_vertical_column(Column, Winner), 
    Winner > 0, 
    !.

check_columns([_|Tail], Winner) :-
    check_columns(Tail, Winner). 

% Verificar si hay 4 fichas consecutivas en una columna
check_vertical_column([Piece|Tail], Winner) :-
    check_consecutive([Piece|Tail], Piece, 1, Winner). 

% Contar fichas consecutivas
check_consecutive([Piece, Piece, Piece, Piece|_], Piece, 4, 1).  
check_consecutive([Piece, Piece, Piece, Piece|_], OtherPiece, 4, 2) :- 
    Piece \= OtherPiece.

check_consecutive([Piece|Tail], Piece, Count, Winner) :-
    Count < 4, 
    NewCount is Count + 1,
    check_consecutive(Tail, Piece, NewCount, Winner).

check_consecutive([_|Tail], Piece, 0, Winner) :- 

    check_consecutive(Tail, Piece, 0, Winner).

check_consecutive(_, _, 4, 1).
check_consecutive(_, _, 4, 2). 





