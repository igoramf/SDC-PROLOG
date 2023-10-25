:- consult('../Util/Util.pl').
:- use_module(library(system)).
:- use_module(library(file_systems)).


directoryDatabase(Directory) :-
    Directory = 'Modules/Database/LocalUsers/'.

%Funções relacionadas a Users
createUserDatabase(Username, Name, Password, Description) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    criar_pasta(Directory, Username),
    criar_pasta(DirectoryUser, 'ingressos'),
    criar_pasta(DirectoryUser, 'sharedWithMe'),
    criar_arquivo(DirectoryUser, Usernametxt),
    escrever_em_arquivo(DirectoryUser, Usernametxt, Username, Name, Password, Description).

deleteUserDatabase(Username) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    delete_directory(DirectoryUser).

getDadosDatabase(Username, Dados) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    concatenar_strings(DirectoryUser, '/', DirectoryUser2),
    concatenar_strings(DirectoryUser2, Usernametxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados).

%Funções relacionadas a login
loginUserDatabase(Username, Password) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    concatenar_strings(DirectoryUser, '/', DirectoryUser2),
    concatenar_strings(DirectoryUser2, Usernametxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    verificar_senha(Dados, Password).

%Funções relacionadas a Ingressos
createIngressoDatabase(Username, FilmeName, IdFilme, Valor, Assento) :-
    directoryDatabase(Directory),
    atomic_list_concat([Directory, '/', Username, '/ingressos/', FilmeName], ListDir),
    atomic_list_concat([ListDir, '/', FilmeName, '.txt'], FilePath),
\+ exists_directory(ListDir), % Verifica se o diretório não existe
    make_directory_path(ListDir), % Cria o diretório e seus pais, se necessário
    open(FilePath, write, Stream),
    format(Stream, "~w~n", [IdFilme]),
    format(Stream, "~w~n", [FilmeName]),
    format(Stream, "~w~n", [Valor]),
    format(Stream, "~w~n", [Assento]),
    close(Stream).

deleteIngressoDatabase(Username, Name) :-
    atomic_list_concat([directoryDatabase, Username, '/ingressos/', ListName], DirectoryPath),
    delete_directory(DirectoryPath).

%Funções relacionadas a Filmes
createFilmeDatabase(NomeFilme, IdFilme, Valor) :-
    atomic_list_concat(['Modules/Database/', '/Filmes/', NomeFilme], ListDir),
    atomic_list_concat([ListDir, '/', NomeFilme, '.txt'], FilePath),
\+ exists_directory(ListDir), % Verifica se o diretório não existe
    make_directory_path(ListDir), % Cria o diretório e seus pais, se necessário
    open(FilePath, write, Stream),
    format(Stream, "~w~n", [IdFilme]),
    format(Stream, "~w~n", [NomeFilme]),
    format(Stream, "~w~n", [Valor]),
    close(Stream).

deleteFilmeDatabase(NomeFilme) :-
    atomic_list_concat([directoryDatabase, '/filmes/', ListName], DirectoryPath),
    delete_directory(DirectoryPath).
