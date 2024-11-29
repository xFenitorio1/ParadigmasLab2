% ---------------------------------------------------------------------
%TDA de Game
game(Game, Board, Player1, Player2, CurrentTurn, [Game, Board, Player1, Player2, CurrentTurn, []]).


% ---------------------------------------------------------------------

game_history([_, _, _, _, _, History], History).


% ---------------------------------------------------------------------

% Verifica si el estado actual del juego es empate
% is_draw(Game, IsDraw).
is_draw([_, Board, _, _, _], true) :-
    \+ can_play(Board), 
	!. 


is_draw([_, _, Player1, Player2, _], true) :-
    no_pieces_left(Player1),
    no_pieces_left(Player2), 
	!.  

is_draw(_, false).  % En caso contrario, no es empate.


% no_pieces_left(Player).
no_pieces_left([_, _, _, _, _, _, RemainingPieces]) :-
    RemainingPieces = 0.
	
% ---------------------------------------------------------------------

% get_current_player(Game, CurrentPlayer)
% Obtiene el jugador cuyo turno está en curso.
get_current_player([_, _, Player1, _, CurrentTurn, _], Player1) :-
    CurrentTurn = 1,
    write('Es el turno del jugador 1 (Player1).'), nl.

get_current_player([_, _, _, Player2, CurrentTurn, _], Player2) :-
    CurrentTurn = 2,
    write('Es el turno del jugador 2 (Player2).'), nl.
% ---------------------------------------------------------------------

% game_get_board(Game, Board)
% Obtiene el tablero actual del juego.
game_get_board([_, Board, _, _, _, _], Board) :-
    write('Tablero actual: '), write(Board), nl.  % Verificación adicional


% ---------------------------------------------------------------------

% end_game(Game, EndGame)
% Finaliza el juego actualizando las estadísticas de los jugadores según el resultado.
end_game(Game, EndGame) :-
    Game = [GameID, Board, Player1, Player2, CurrentTurn, History],  % Extraer componentes del juego.
    ( 
        who_is_winner(Board, Winner), Winner \= 0 ->       % Determinar el ganador (si existe).
        determine_result(Winner, Result)                  % Mapear Winner a un resultado (win_p1, win_p2).
    ;
        Result = 'draw'                                   % En caso de empate.
    ),
	!,
    update_stats([GameID, Board, Player1, Player2, CurrentTurn, History], Result, EndGame). % Actualizar estadísticas.


% determine_result(Winner, Result)
% Determina el resultado del juego basado en el ganador.
determine_result(Player, 'win_p1') :-
    Player = "red",  % Si el ganador es rojo, es victoria para el Jugador 1.
	!.
determine_result(Player, 'win_p2') :-
    Player = "yellow",
	!. % Si el ganador es amarillo, es victoria para el Jugador 2.
	
	
	
% player_play(Game, Player, Column, NewGame)
% Realiza un movimiento y actualiza el estado del juego.
player_play([GameID, Board, Player1, Player2, CurrentTurn, History], Player, Column, NewGame) :-

    get_current_player([GameID, Board, Player1, Player2, CurrentTurn, History], CurrentPlayer),
    nth0(0, CurrentPlayer, CurrentPlayerID),  
    nth0(0, Player, PlayerID),               
    %write('Es el turno del jugador con ID: '), write(CurrentPlayerID), nl,
    %write('Jugador actual: '), write(CurrentPlayer), nl,
    CurrentPlayerID = PlayerID,  % Validar que sea el turno del jugador correcto

    not(no_pieces_left(CurrentPlayer)),
    %write('El jugador tiene fichas disponibles.'), nl,

    player_color(Player, PlayerColor),
    play_piece(Board, Column, PlayerColor, UpdatedBoard),
   % write('Tablero actualizado: '), write(UpdatedBoard), nl,

    reduce_pieces(Player, UpdatedPlayer),
   % write('Fichas restantes del jugador: '), write(UpdatedPlayer), nl,


    update_turn(CurrentTurn, NextTurn),
  %  write('Turno siguiente: '), write(NextTurn), nl,


    update_history([GameID, UpdatedBoard, Player1, Player2, CurrentTurn, History], Player, Column, UpdatedGameWithHistory),
   % write('Historial actualizado: '), write(UpdatedGameWithHistory), nl,


    who_is_winner(UpdatedBoard, Winner),
    ( 
        Winner \= 0 ->  % Si el ganador es distinto de 0 (no es empate)
            determine_result(Winner, Result),
            update_stats(UpdatedGameWithHistory, Result, FinalGame),
     %       write('Ganador: '), write(Winner), nl,
            NewGame = FinalGame
        ;
        is_draw(UpdatedGameWithHistory, true) ->  % Si es empate
            update_stats(UpdatedGameWithHistory, 'draw', FinalGame),
      %      write('Empate'), nl,
            NewGame = FinalGame
        ;

        (
            CurrentTurn = 1 -> 
                NewGame = [GameID, UpdatedBoard, UpdatedPlayer, Player2, NextTurn, UpdatedGameWithHistory];
            CurrentTurn = 2 -> 
                NewGame = [GameID, UpdatedBoard, Player1, UpdatedPlayer, NextTurn, UpdatedGameWithHistory]
        )
    ).
	
player_color([_, _, Color, _, _, _, _], Color).

reduce_pieces([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], [ID, Name, Color, Wins, Losses, Draws, NewRemainingPieces]) :-
    RemainingPieces > 0,
    NewRemainingPieces is RemainingPieces - 1.

update_turn(CurrentTurn, NextTurn) :-
    (CurrentTurn = 1 -> NextTurn = 2; NextTurn = 1).


update_history([GameID, Board, Player1, Player2, CurrentTurn, History], Player, Column, [GameID, Board, Player1, Player2, CurrentTurn, UpdatedHistory]) :-
    UpdatedHistory = [[Player, Column] | History]. 