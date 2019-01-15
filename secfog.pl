secFog(OpA, A, D) :-
    app(A, L),			
    deployment(OpA, L, D).

deployment(_,[],[]).
deployment(OpA,[C|Cs],[d(C,N,OpN)|D]) :-
    node(N,OpN),
    securityRequirements(C,N),
    trusts2(OpA, OpN),
    deployment(OpA,Cs,D).

trusts(X,X).

trusts2(A,B) :-
    trusts(A,B).
trusts2(A,B) :-
    trusts(A,C),
    trusts2(C,B).
