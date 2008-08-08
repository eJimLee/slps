:- ensure_loaded('slps.pro').
:- use_module('xbgf1.pro').

%
% Static namespace declarations
%

:- multifile sxmlns/2.

sxmlns(xbgf,'http://planet-sl.org/xbgf').


%
% Convert XML to predicates
%

xml2xbgf(T,define(Ps2))
 :-
    self(name(xbgf:define),T),
    !,
    children(name(bgf:production),T,Ps1),
    maplist(xmlToP,Ps1,Ps2).

xml2xbgf(T,downcase)
 :-
    self(name(xbgf:downcase),T),
    !.

xml2xbgf(T,extract(P2))
 :-
    self(name(xbgf:extract),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,fold(P2))
 :-
    self(name(xbgf:fold),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,id)
 :-
    self(name(xbgf:id),T),
    !.

xml2xbgf(T,inline(N))
 :-
    self(name(xbgf:inline),T),
    !,
    child(name(nonterminal),T,T1),
    content(T1,N).

xml2xbgf(T,introduce(Ps2))
 :-
    self(name(xbgf:introduce),T),
    !,
    children(name(bgf:production),T,Ps1),
    maplist(xmlToP,Ps1,Ps2).

xml2xbgf(T,label(P2))
 :-
    self(name(xbgf:label),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,massage(P2))
 :-
    self(name(xbgf:massage),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,permute(P2))
 :-
    self(name(xbgf:permute),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,prune(N))
 :-
    self(name(xbgf:prune),T),
    !,
    content(T,N).

xml2xbgf(T,remove(P2))
 :-
    self(name(xbgf:remove),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,F3)
 :-
    self(name(xbgf:rename),T),
    !,
    (
      child(name(label),T,X),
      F = renameL,
      C = label
    ;
      child(name(nonterminal),T,X),
      F = renameN,
      C = nonterminal
    ;
      child(name(selector),T,X),
      (
        child(name(in),X,In) ->
            ( 
              content(In,Z0),
              F = renameS([Z0])
            )
          ;
            F = renameS([])
      ),
      C = selector
    ),
    child(name(from),X,From),
    child(name(to),X,To),
    content(From,Z1),
    content(To,Z2),
    F =.. F1,
    append(F1,[Z1,Z2],F2),
    F3 =.. F2.

xml2xbgf(T,reroot(Rs2))
 :-
    self(name(xbgf:reroot),T),
    !,
    children(name(root),T,Rs1),
    maplist(content,Rs1,Rs2).

xml2xbgf(T,restrict(P2))
 :-
    self(name(xbgf:restrict),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,sequence(Ts2))
 :-
    self(name(xbgf:sequence),T),
    !,
    children(element,T,Ts1),
    maplist(xml2xbgf,Ts1,Ts2).

xml2xbgf(T,skip(P2))
 :-
    self(name(xbgf:skip),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,stripL(L))
 :-
    self(name(xbgf:strip),T),
    child(name(label),T,T1),
    !,
    content(T1,L).

xml2xbgf(T,stripLs)
 :-
    self(name(xbgf:strip),T),
    child(name(allLabels),T,_),
    !.

xml2xbgf(T,stripS(S))
 :-
    self(name(xbgf:strip),T),
    child(name(selector),T,T1),
    !,
    content(T1,S).

xml2xbgf(T,stripSs)
 :-
    self(name(xbgf:strip),T),
    child(name(allSelectors),T,_),
    !.

xml2xbgf(T,stripT(T2))
 :-
    self(name(xbgf:strip),T),
    child(name(terminal),T,T1),
    !,
    content(T1,T2).

xml2xbgf(T,stripTs)
 :-
    self(name(xbgf:strip),T),
    child(name(allTerminals),T,_),
    !.

xml2xbgf(T,unchain(N))
 :-
    self(name(xbgf:unchain),T),
    !,
    content(T,N).

xml2xbgf(T,undefine(N))
 :-
    self(name(xbgf:undefine),T),
    !,
    content(T,N).

xml2xbgf(T,unfold(P2))
 :-
    self(name(xbgf:unfold),T),
    !,
    child(name(bgf:production),T,P1),
    xmlToP(P1,P2).

xml2xbgf(T,unite(N1,N2))
 :-
    self(name(xbgf:unite),T),
    !,
    child(name(add),T,Add),
    child(name(to),T,To),
    content(Add,N1),
    content(To,N2).

xml2xbgf(T,verticalL(L))
 :-
    self(name(xbgf:vertical),T),
    child(name(label),T,T1),
    !,
    content(T1,L).

xml2xbgf(T,verticalN(N))
 :-
    self(name(xbgf:vertical),T),
    child(name(nonterminal),T,T1),
    !,
    content(T1,N).


main 
 :- 
    current_prolog_flag(argv,Argv),
    append(_,['--',BgfIn,XbgfIn,BgfOut],Argv),
    ( exists_file(BgfOut) -> delete_file(BgfOut); true ),
    load_structure(BgfIn, [G1], [dialect(xmlns)]),
    xmlToG(G1,G2),
    format(' * normalize~n',[BgfIn]),
    load_structure(XbgfIn, [T1], [dialect(xmlns)]),
    xml2xbgf(T1,T2),
    transformG(T2,G2,G3),
    normalizeG(G3,G4),
    gToXml(G4,G5),
    open(BgfOut, write, OStream),
    xml_write(OStream,G5,[]),
    close(OStream),
    halt.

:- run.
