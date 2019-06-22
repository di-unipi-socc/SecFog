:- use_module(library(aproblog)).

:- use_semiring(
sr_plus,   % addition (arity 3)
sr_times,  % multiplication (arity 3)
sr_zero,   % neutral element of addition
sr_one,    % neutral element of multiplication
sr_neg,    % negation of fact label
false,     % requires solving disjoint sum problem?
false).    % requires solving neutral sum problem?

sr_zero((0.0, 0.0)).
sr_one((1.0, 1.0)).
sr_times((Ta, Ca), (Tb, Cb), (Tc, Cc)) :- Ta < 0, Tb < 0, Tc is 0.0, Cc is Ca*Cb.
sr_times((Ta, Ca), (Tb, Cb), (Tc, Cc)) :- Ta > 0, Tc is Ta*Tb, Cc is Ca*Cb.
sr_times((Ta, Ca), (Tb, Cb), (Tc, Cc)) :- Tb > 0, Tc is Ta*Tb, Cc is Ca*Cb.
sr_times((Ta, Ca), (Tb, Cb), (Tc, Cc)) :- (Ta == 0; Tb == 0), Tc is 0, Cc is Ca*Cb.


sr_plus((Ta, Ca), (Tb, Cb), (Ta, Ca)) :- Ca > Cb.
sr_plus((Ta, Ca), (Tb, Cb), (Tb, Cb)) :- Cb > Ca.
sr_plus((Ta, C), (Tb, C), (Tc, C)) :- (Ta + Tb) \== 0.0, Tc is (sign(Ta+Tb) * max(Ta, Tb)).
sr_plus((Ta, C), (Tb, C), (Tc, C)) :- (Ta + Tb) == 0.0, Tc is max(Ta, Tb).


sr_neg((Ta, Ca), (Tb, Ca)) :- Ta > 0, Tb is 1.0-Ta.
sr_neg((Ta, Ca), (Tb, Ca)) :- Ta < 0, Tb is Ta-1.0. 
sr_neg((0, Ca), (0, Ca)). 


trusts(X,X).

trusts2(A,B,D) :-
    D > 0,
    trusts(A,B).
trusts2(A,B,D) :-
    D > 0,
    trusts(A,C),
    NewD is D -1,
    trusts2(C,B,NewD).

(.6,.8)::trusts(v1,v2).
(.4,.5)::trusts(v1,v3).
(.5,.8)::trusts(v1,v4).

(.6,.7)::trusts(v2, v5).
(.3,.5)::trusts(v3, v5).
(-.3,.7)::trusts(v4, v5).

query(trusts2(v1,v5, 3)).