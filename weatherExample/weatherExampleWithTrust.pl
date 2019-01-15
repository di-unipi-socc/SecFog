:- use_module(library(lists)).

secFog(OpA, A, D) :-
    app(A, L),			
    deployment(OpA, L, D).

deployment(_,[],[]).
deployment(OpA,[C|Cs],[d(C,N,OpN)|D]) :-
	node(N,OpN),
    securityRequirements(C,N),
    trusts2(OpA,OpN),
	deployment(OpA,Cs,D).

trusts(X,X).    
                
trusts2(A,B) :-     
    trusts(A,B).    
trusts2(A,B) :-     
    trusts(A,C),
    trusts2(C,B).   

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

%%% trust relations declared by appOp
.9::trusts(appOp, edgeOp).  
.9::trusts(appOp, ispOp).

%%% trust relations declared by edgeOp
.7::trusts(edgeOp, cloudOp1).
.8::trusts(edgeOp, cloudOp2).

%%% trust relation declared by cloudOp1
.8::trusts(cloudOp1, cloudOp2).

%%% trust relation declared by cloudOp2
.2::trusts(cloudOp2, cloudOp).

%%% trust relations declared by ispOp  
.8::trusts(ispOp, cloudOp).
.6::trusts(ispOp, edgeOp).

query(secFog(appOp,weatherApp,D)).
