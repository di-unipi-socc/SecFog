:- use_module(library(lists)).

secFog(OpA, A, D) :-
    app(A, L),			
    deployment(OpA, L, D).

deployment(_,[],[]).
deployment(OpA,[C|Cs],[d(C,N,OpN)|D]) :-
	node(N,OpN),
    securityRequirements(C,N),
	deployment(OpA,Cs,D).

%%% Application, specified by appOp
app(weatherApp, [weatherMonitor]).
securityRequirements(weatherMonitor, N) :-
    (anti_tampering(N); access_control(N)),
    (wireless_security(N); iot_data_encryption(N)).

%%% Cloud node, specified by cloudOp
node(cloud, cloudOp).
0.99::anti_tampering(cloud).
0.99::access_control(cloud).
0.99::iot_data_encryption(cloud).

%%% Edge node, specified by edgeOp
node(edge, edgeOp).
0.8::anti_tampering(edge).
0.9::wireless_security(edge).
0.9::iot_data_encryption(edge).

query(secFog(appOp,weatherApp,D)).
