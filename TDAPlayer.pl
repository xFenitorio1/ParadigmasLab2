% Constructor para un jugador
% player(ID, Name, Color, Wins, Losses, Draws, RemainingPieces, Player).
player(ID, Name, Color, Wins, Losses, Draws, RemainingPieces, [ID, Name, Color, Wins, Losses, Draws, RemainingPieces]).


% ---------------------------------------------------------------------

% update_stats(Game, Result, UpdatedGame)
% Actualiza las estadísticas de los jugadores según el resultado del juego.
update_stats([GameID, Board, Player1, Player2, CurrentTurn, History], Result, [GameID, Board, UpdatedPlayer1, UpdatedPlayer2, CurrentTurn, History]) :-
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
	
% -----------------------------