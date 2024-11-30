
% ---------------------------------------------------------------------
%Predicado: game/5
%Tipo: Constructor
%Dominio: JuegoID (Número), Tablero (Lista de Listas), Jugador1 (Lista), Jugador2 (Lista), TurnoActual (Número)
%Recorrido: Representación del estado del juego (Lista)
%Descripción: Construye un nuevo estado inicial del juego, incluyendo el identificador del juego, el tablero vacío, los jugadores inicializados, el turno actual y un historial vacío.
game(Game, Board, Player1, Player2, CurrentTurn, [Game, Board, Player1, Player2, CurrentTurn, []]).


% ---------------------------------------------------------------------

%Predicado: game_history/2
%Tipo: Consultor
%Dominio: Juego (Lista), Historial (Lista)
%Recorrido: Historial de movimientos
%Descripción: Extrae el historial de movimientos del estado actual del juego.


game_history([_, _, _, _, _, History], History).


% ---------------------------------------------------------------------

%Predicado: is_draw/2
%Tipo: Consultor
%Dominio: Juego (Lista), Resultado (Booleano)
%Recorrido: `true` si el juego es un empate, `false` en caso contrario.
%Descripción: Determina si el juego ha terminado en empate verificando que no hay movimientos posibles (tablero lleno) o que ambos jugadores no tienen fichas disponibles.

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

%Predicado: get_current_player/2
%Tipo: Consultor
%Dominio: Juego (Lista), JugadorActual (Lista)
%Recorrido: Representación del jugador actual
%Descripción: Determina cuál es el jugador que tiene el turno actual, devolviendo su representación.

% get_current_player(Game, CurrentPlayer)
% Obtiene el jugador cuyo turno está en curso.
get_current_player([_, _, Player1, _, CurrentTurn, _], Player1) :-
    CurrentTurn = 1,
    write('Es el turno del jugador 1 (Player1).'), nl.

get_current_player([_, _, _, Player2, CurrentTurn, _], Player2) :-
    CurrentTurn = 2,
    write('Es el turno del jugador 2 (Player2).'), nl.
% ---------------------------------------------------------------------


%Predicado: game_get_board/2
%Tipo: Consultor
%Dominio: Juego (Lista), Tablero (Lista de Listas)
%Recorrido: Tablero actual del juego
%Descripción: Extrae el tablero actual del estado del juego. Este tablero refleja la disposición de las fichas en el tablero en el turno en curso.


% game_get_board(Game, Board)
% Obtiene el tablero actual del juego.
game_get_board([_, Board, _, _, _, _], Board).


% ---------------------------------------------------------------------

%Predicado: end_game/2
%Tipo: Modificador
%Dominio: Juego (Lista), JuegoFinalizado (Lista)
%Recorrido: Estado final del juego
%Descripción: Finaliza el juego actualizando las estadísticas de los jugadores según el resultado obtenido (victoria o empate). Utiliza el tablero para determinar el ganador y llama a `update_stats/3` para modificar las estadísticas.

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
	
% ----------------------------------------------------------

%Predicado: player_play/4
%Tipo: Modificador
%Dominio: Juego (Lista), Jugador (Lista), Columna (Número), NuevoJuego (Lista)
%Recorrido: Nuevo estado del juego
%Descripción: Realiza un movimiento de un jugador, actualiza el tablero con la ficha correspondiente, reduce las fichas restantes del jugador, cambia el turno y actualiza el historial de movimientos. Determina si hay un ganador o empate después del movimiento.

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
