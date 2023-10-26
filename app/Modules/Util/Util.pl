:- use_module(library(filesex)).
:- use_module(library(files)).

criar_pasta(Diretorio, NomePasta) :-
    atomic_list_concat([Diretorio, '/', NomePasta], Caminho),
    make_directory_path(Caminho).

concatenar_strings(T1, T2, Resultado) :-
    atom_concat(T1, T2, Resultado).

criar_arquivo(Diretorio, NomeArquivo) :-
    atomic_list_concat([Diretorio, '/', NomeArquivo], Caminho),
    open(Caminho, write, Stream),
    close(Stream).

escrever_em_arquivo(Diretorio, NomeArquivo, Parametro1, Parametro2, Parametro3, Parametro4) :-
    atomic_list_concat([Diretorio, '/', NomeArquivo], Caminho),
    open(Caminho, write, Stream),
    write(Stream, Parametro1), write(Stream, '\n'),
    write(Stream, Parametro2), write(Stream, '\n'),
    write(Stream, Parametro3), write(Stream, '\n'),
    write(Stream, Parametro4), write(Stream, '\n'),
    close(Stream).

ler_user(CaminhoArquivo, Linhas) :-
    open(CaminhoArquivo, read, Stream),
    ler_linhas(Stream, 4, Linhas),
    close(Stream).

ler_linhas(_, 0, []).
ler_linhas(Stream, N, [Linha | RestoLinhas]) :-
    N > 0,
    read_line_to_string(Stream, Linha),
    N1 is N - 1,
    ler_linhas(Stream, N1, RestoLinhas).

converter_para_string(Tipo, String) :-
    atom_codes(Tipo, Codigos),
    string_codes(String, Codigos).

verificar_senha(Lista, Senha) :-
    nth1(3, Lista, ElementoIndice3),
    converter_para_string(ElementoIndice3, ElementoConvert),
    converter_para_string(Senha, SenhaConvert),
    ElementoConvert == SenhaConvert.

delete_directory(Directory) :-
    exists_directory(Directory),    % Verifica se o diretório existe
    delete_directory_and_contents(Directory).

delete_directory(Directory) :-
    \+ exists_directory(Directory),  % Se o diretório não existe
    write('O diretório não existe.').

delete_directory_and_contents(Directory) :-
    forall(directory_files(Directory, File), delete_entry(Directory, File)),
    delete_directory(Directory).

delete_entry(Directory, Entry) :-
    atomic_list_concat([Directory, '/', Entry], Path),
    (   exists_directory(Path)
    ->  delete_directory_and_contents(Path)
    ;   delete_file(Path)
    ).


converte_string_para_inteiro(String, Inteiro) :-
    number_codes(Inteiro, String).