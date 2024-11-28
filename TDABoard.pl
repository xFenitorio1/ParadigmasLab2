% Tablero de prueba
board([[0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0]]).

% ---------------------------------------------------------------------
% can_play(Board)
% Verifica si alguna columna contiene un 0 (espacio vacío).
can_play(Board) :-
    member(Column, Board),       
    member(0, Column),            
    !.                           

% ---------------------------------------------------------------------

play_piece(Board, ColumnIndex, Piece, NewBoard) :-
    reverse(Board, ReversedBoard),                   
    place_in_column(ReversedBoard, ColumnIndex, Piece, NewReversedBoard),
    reverse(NewReversedBoard, NewBoard),
    !.


place_in_column([Row|RestRows], ColumnIndex, Piece, [NewRow|RestRows]) :-
    nth0(ColumnIndex, Row, 0),                          
    replace_in_list(Row, ColumnIndex, Piece, NewRow).   
place_in_column([Row|RestRows], ColumnIndex, Piece, [Row|NewRestRows]) :-
    place_in_column(RestRows, ColumnIndex, Piece, NewRestRows).


replace_in_list([_|Tail], 0, Element, [Element|Tail]).
replace_in_list([Head|Tail], Index, Element, [Head|NewTail]) :-
    Index > 0,
    NewIndex is Index - 1,
    replace_in_list(Tail, NewIndex, Element, NewTail).

% ---------------------------------------------------------------------
% Verifica si hay un ganador vertical revisando directamente las columnas del tablero.
check_vertical_win(Board, Winner) :-
    (vertical_win(Board, red, Winner) ; 
     vertical_win(Board, yellow, Winner)),  
    !.                                  
check_vertical_win(_, 0).


vertical_win(Board, Ficha, Ficha) :-
    column_index(Board, 0, Ficha, 0).   

column_index(Board, Columna, Ficha, 0) :-
    Columna < 6,                       
    extract_column(Board, Columna, Column),
    check_consecutive(Column, Ficha, 0, Ficha).


extract_column([], _, []).
extract_column([Row|Rest], Columna, [Element|ColumnRest]) :-
    nth0(Columna, Row, Element),
    extract_column(Rest, Columna, ColumnRest).

% ---------------------------------------------------------------------
% Verifica si hay un ganador horizontal en cualquier fila.
check_horizontal_win(Board, Winner) :-
    check_rows(Board, Winner).


check_rows([Row|_], Winner) :-
    check_consecutive(Row, 0, 0, Winner),
    Winner \= 0, !. 
check_rows([_|Rest], Winner) :-
    check_rows(Rest, Winner).
check_rows([], 0).


check_consecutive([], _, _, 0). 
check_consecutive([Piece|Tail], Piece, Count, Winner) :-
    Piece \= 0,                          
    NewCount is Count + 1,               
    (NewCount = 4 -> Winner = Piece ;    
     check_consecutive(Tail, Piece, NewCount, Winner)).
check_consecutive([Piece|Tail], _, _, Winner) :-
    Piece \= 0,                         
    check_consecutive(Tail, Piece, 1, Winner).
check_consecutive([_|Tail], _, _, Winner) :-
    check_consecutive(Tail, 0, 0, Winner).

%----------------------------------------------------

check_diagonal_win(Board, Winner) :-
    (check_diagonal_descending(Board, Winner) ;
     check_diagonal_ascending(Board, Winner)), 
    !.

check_diagonal_win(_, 0).


check_diagonal_descending(Board, Winner) :-
    between(0, 2, Row),  % Filas iniciales permitidas para descenso.
    between(0, 3, Col),  % Columnas iniciales permitidas para descenso.
    check_diagonal(Board, Row, Col, 1, Winner),
    !.


check_diagonal_ascending(Board, Winner) :-
    between(3, 5, Row),  
    between(0, 3, Col),  
    check_diagonal(Board, Row, Col, -1, Winner),
    !.


check_diagonal(Board, Row, Col, Direction, Winner) :-
    check_consecutive_in_diagonal(Board, Row, Col, Direction, 0, none, Winner).


check_consecutive_in_diagonal(_, _, _, _, 4, Piece, Piece) :-
    Piece \= 0, 
    !.
	
check_consecutive_in_diagonal(Board, Row, Col, Direction, Count, CurrentPiece, Winner) :-
    Row >= 0, Row < 6, 
    Col >= 0, Col < 7,  
    nth0(Row, Board, RowData), 
    nth0(Col, RowData, Piece),  .
    (
        Piece \= 0, Piece == CurrentPiece ->  
            NewCount is Count + 1,        
            NewPiece = CurrentPiece        
    ;
        Piece \= 0 ->  
            NewCount = 1,                 
            NewPiece = Piece               
    ;
        NewCount = 0,                      
        NewPiece = none                   
    ),
    NewRow is Row + Direction, 
    NewCol is Col + 1,          
    check_consecutive_in_diagonal(Board, NewRow, NewCol, Direction, NewCount, NewPiece, Winner).

%----------------------------------------------------

who_is_winner(Board, Winner) :-
    (check_vertical_win(Board, Winner), Winner \= 0) ;
    check_horizontal_win(Board, Winner);
    (check_diagonal_win(Board, Winner), Winner \= 0).