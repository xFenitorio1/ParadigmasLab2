 
%Predicado: player/1
%Tipo: Constructor
%Dominio: Id (Número) X Nombre (String) X Color (String) X Victorias (Número) X Derrotas (Número) X Empates (Número) X FichasRestantes (Número) X Jugador (Lista)
%Recorrido: Jugador
%Tipo de Algoritmo: Ninguno (asignación directa)
%Descripción: Este predicado crea una representación de un jugador como una lista
%que contiene su ID, nombre, color de ficha, estadísticas (victorias, derrotas, empates)
%y el número de fichas restantes.

player(ID, Name, Color, Wins, Losses, Draws, RemainingPieces, [ID, Name, Color, Wins, Losses, Draws, RemainingPieces]).

% ---------------------------------------------------------------------


%Predicado: update_stats/3
%Tipo: Modificador
%Dominio: Game (Lista) X Result (String) X UpdatedGame (Lista)
%Recorrido: UpdatedGame
%Tipo de Algoritmo: Evaluación condicional
%Descripción: Actualiza las estadísticas de los jugadores según el resultado del juego,
%modificando el número de victorias, derrotas o empates de cada jugador.

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

%Predicado: update_stat/3
%Tipo: Modificador
%Dominio: Player (Lista) X Result (String) X UpdatedPlayer (Lista)
%Recorrido: UpdatedPlayer
%Tipo de Algoritmo: Evaluación condicional
%Descripción: Actualiza las estadísticas individuales de un jugador según el resultado.

update_stat([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], 'win', [ID, Name, Color, NewWins, Losses, Draws, RemainingPieces]) :-
    NewWins is Wins + 1.

update_stat([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], 'loss', [ID, Name, Color, Wins, NewLosses, Draws, RemainingPieces]) :-
    NewLosses is Losses + 1.

update_stat([ID, Name, Color, Wins, Losses, Draws, RemainingPieces], 'draw', [ID, Name, Color, Wins, Losses, NewDraws, RemainingPieces]) :-
    NewDraws is Draws + 1.