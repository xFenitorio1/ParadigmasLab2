
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