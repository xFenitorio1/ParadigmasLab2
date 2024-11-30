:- consult('piece_21343296_GerardoPerezEncina.pl').
:- consult('player_21343296_GerardoPerezEncina.pl').
:- consult('board_21343296_GerardoPerezEncina.pl').
:- consult('game_21343296_GerardoPerezEncina.pl').

main:-
	player(1, "Juan", "red", 0, 0, 0, 10, P1),
	player(2, "Mauricio", "yellow", 0, 0, 0, 10, P2),
	piece("red", RedPiece),
	piece("yellow", YellowPiece),
		board(EmptyBoard2),
		% Crear nuevo juego
		game(2, EmptyBoard2, P1, P2, 1, G0v),
		% Realizar movimientos
		player_play(G0v, P1, 3, G1v),    % Juan juega en columna 0
		player_play(G1v, P2, 0, G2v),    % Mauricio juega en columna 1
		player_play(G2v, P1, 1, G3v),    % Juan juega en columna 0
		player_play(G3v, P2, 0, G4v),    % Mauricio juega en columna 1
		player_play(G4v, P1, 1, G5v),    % Juan juega en columna 0
		player_play(G5v, P2, 0, G6v),    % Mauricio juega en columna 1
		player_play(G6v, P1, 1, G7v),    % Juan juega en columna 0 (victoria vertical)
		player_play(G7v, P2, 0, G8v),
		% Verificaciones
		write('¿Se puede jugar en el tablero vacio? '),
		can_play(EmptyBoard2), nl,
		game_get_board(G8v, CurrentBoard2),
		write('¿Se puede jugar despues de 7 movimientos? '),
		can_play(CurrentBoard2), nl,
		write('Jugador actual despues de 7 movimientos: '),
		get_current_player(G8v, CurrentPlayer2),
		write(CurrentPlayer2), nl,
		write('Verificacion de victoria vertical: '),
		check_vertical_win(CurrentBoard2, VerticalWinner2),
		write(VerticalWinner2), nl,
		write('Verificacion de victoria horizontal: '),
		check_horizontal_win(CurrentBoard2, HorizontalWinner2),
		write(HorizontalWinner2), nl,
		write('Verificacion de victoria diagonal: '),
		check_diagonal_win(CurrentBoard2, DiagonalWinner2),
		write(DiagonalWinner2), nl,
		write('Verificacion de ganador: '),
		who_is_winner(CurrentBoard2, Winner2),
		write(Winner2), nl,
		write('¿Es empate? '),
		is_draw(G8v, IsDraw2), nl,
		end_game(G8v, EndedGame2),
		write('Historial de movimientos: '),
		game_history(EndedGame2, History2),
		write(History2), nl,
		write('Estado final del tablero: '),
		game_get_board(EndedGame2, FinalBoard2),
		write(FinalBoard2), nl.