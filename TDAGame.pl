
% ---------------------------------------------------------------------
%TDA de Game
game(Game, Board, Player1, Player2, CurrentTurn, [Game, Board, Player1, Player2, CurrentTurn]).



% ---------------------------------------------------------------------

game_history([_, _, _, _, History], History).


% ---------------------------------------------------------------------

% Verifica si el estado actual del juego es empate
% is_draw(Game, IsDraw).
is_draw([_, Board, Player1, Player2, _], true) :-
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

% update_stats(Game, Result, UpdatedGame)
% Actualiza las estadísticas de los jugadores según el resultado del juego.
update_stats([GameID, Board, Player1, Player2, CurrentTurn], Result, [GameID, Board, UpdatedPlayer1, UpdatedPlayer2, CurrentTurn]) :-
    ( Result = 'win_p1' ->
        update_stat(Player1, 'win', UpdatedPlayer1),
        update_stat(Player2, 'loss', UpdatedPlayer2)
    ; Result = 'win_p2' ->
        update_stat(Player1, 'loss', UpdatedPlayer1),
        update_stat(Player2, 'win', UpdatedPlayer2)
    ; Result = 'draw' ->
        update_stat(Player1, 'draw', UpdatedPlayer1),
        update_stat(Player2, 'draw', UpdatedPlayer2)
    ).

% update_stat(Player, Result, UpdatedPlayer)
% Actualiza las estadísticas individuales de un jugador.
update_stat([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], 'win', [ID, Name, Color, NewWins, Losses, Draws, RemainingPieces]) :-
    NewWins is Wins + 1.

update_stat([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], 'loss', [ID, Name, Color, Wins, NewLosses, Draws, RemainingPieces]) :-
    NewLosses is Losses + 1.

update_stat([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], 'draw', [ID, Name, Color, Wins, Losses, NewDraws, RemainingPieces]) :-
    NewDraws is Draws + 1.
	
% ---------------------------------------------------------------------

% get_current_player(Game, CurrentPlayer)
% Obtiene el jugador cuyo turno está en curso.
get_current_player([_, _, Player1, _, 1], Player1). % Si el turno es del jugador 1.
get_current_player([_, _, _, Player2, 2], Player2). % Si el turno es del jugador 2.

% ---------------------------------------------------------------------

% game_get_board(Game, Board)
% Obtiene el tablero actual del juego.
game_get_board([_, Board, _, _, _], Board).


% ---------------------------------------------------------------------

% end_game(Game, EndGame)
% Finaliza el juego actualizando las estadísticas de los jugadores según el resultado.
end_game(Game, EndGame) :-
    Game = [GameID, Board, Player1, Player2, CurrentTurn],  % Extraer componentes del juego.
    ( who_is_winner(Board, Winner) ->                      % Determinar el ganador.
        determine_result(Winner, Result)                  % Mapear Winner a un resultado (win_p1, win_p2, draw).
    ; Result = 'draw'                                      % En caso de empate.
    ),
    update_stats(Game, Result, EndGame).                   % Actualizar las estadísticas con el resultado.

% determine_result(Winner, Result)
% Determina el resultado del juego basado en el ganador.
determine_result(Player, 'win_p1') :-
    Player = red.  % Si el ganador es rojo, es victoria para el Jugador 1.
determine_result(Player, 'win_p2') :-
    Player = yellow.  % Si el ganador es amarillo, es victoria para el Jugador 2.