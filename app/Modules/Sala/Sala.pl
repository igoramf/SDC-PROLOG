% Exemplo de uso:
%
% - Para cadastrar uma nova sala: cadastra_sala(1, 10).
% - Para listar salas disponíveis: lista_salas_disponiveis(SalasDisponiveis).
% - Para associar uma sala a um filme e horário: associar_sala_filme_horario(1, 'Taxi Driver', '19:00').
% - Para verificar a disponibilidade de um assento: verificar_disponibilidade_assentos(1, 1, 5).
% - Para exibir os assentos disponíveis de uma sala: exibir_assentos_disponiveis(1).
% - Para associar um filme a uma sala: associar_filme_sala(2, 'Taxi Driver', 'Drama', 140).


% Definição da estrutura de uma sala
:- dynamic sala/5.
% sala(Número, Capacidade, FilmeExibicao, HorarioExibicao, AssentosDisponiveis)

% Cadastrar uma nova sala
cadastra_sala(N, Capacidade) :-
    retractall(sala(N, _, _, _, _)),
    assert(sala(N, Capacidade, sem_filme, sem_horario, [])),
    indexar_assentos(N, Capacidade).

% Listar salas disponíveis
lista_salas_disponiveis(SalasDisponiveis) :-
    findall(Sala, sala_disponivel(Sala), SalasDisponiveis).

sala_disponivel(sala(N, Capacidade, sem_filme, sem_horario, _)).

% Associar uma sala a um filme e horário
associar_sala_filme_horario(N, Filme, Horario) :-
    retract(sala(N, Capacidade, sem_filme, sem_horario, Assentos)),
    assert(sala(N, Capacidade, Filme, Horario, Assentos)).

% Função para indexar os assentos disponíveis em uma sala
indexar_assentos(_, 0).
indexar_assentos(N, Capacidade) :-
    indexar_fileira(N, Capacidade, Assentos),
    retract(sala(N, Capacidade, sem_filme, sem_horario, _)),
    assert(sala(N, Capacidade, sem_filme, sem_horario, Assentos)),
    NovoCapacidade is Capacidade - 1,
    indexar_assentos(N, NovoCapacidade).

indexar_fileira(_, 0, []).
indexar_fileira(N, Capacidade, [true | Resto]) :-
    Capacidade > 0,
    NovaCapacidade is Capacidade - 1,
    indexar_fileira(N, NovaCapacidade, Resto).

% Função para verificar a disponibilidade de assentos em uma sala
verificar_disponibilidade_assentos(N, Fila, Assento) :-
    sala(N, _, _, _, Assentos),
    nth1(Fila, Assentos, Fileira),
    nth1(Assento, Fileira, true).

% Função para exibir os assentos disponíveis de forma visual
exibir_assentos_disponiveis(N) :-
    sala(N, _, _, _, Assentos),
    write('Assentos Disponíveis na Sala '), write(N), nl,
    exibir_assentos(Assentos, 1).

exibir_assentos([], _).
exibir_assentos([Fileira | Resto], Fila) :-
    write('Fila '), write(Fila), write(': '),
    exibir_fileira(Fileira),
    NovoFila is Fila + 1,
    exibir_assentos(Resto, NovoFila).

exibir_fileira([]) :- nl.
exibir_fileira([true | Resto]) :-
    write('O '),
    exibir_fileira(Resto).
exibir_fileira([false | Resto]) :-
    write('X '),
    exibir_fileira(Resto).

