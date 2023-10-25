:- consult('../Database/Database.pl').

createFilme(NomeFilme, IdFilme, Valor) :-
    createFilmeDatabase(NomeFilme, IdFilme, Valor).

deleteFilme(Username, NomeFilme) :-
    deleteFilmeDatabase(Username, NomeFilme).