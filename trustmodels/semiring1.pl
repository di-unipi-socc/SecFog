:- use_module(library(aproblog)).

:- use_semiring(
    sr_plus,   % addition (arity 3)
    sr_times,  % multiplication (arity 3)
    sr_zero,   % neutral element of addition
    sr_one,    % neutral element of multiplication
    sr_neg,    % negation of fact label
    true,      % requires solving disjoint sum problem?
    false).    % requires solving neutral sum problem?

sr_zero((0.0, 0.0)).
sr_one((1.0, 1.0)).
sr_times((Ta, Ca), (Tb, Cb), (Tc, Cc)) :- Tc is Ta*Tb, Cc is Ca*Cb.
sr_plus((Ta, Ca), (Tb, Cb), (Ta, Ca)) :- Ca > Cb.
sr_plus((Ta, Ca), (Tb, Cb), (Tb, Cb)) :- Cb > Ca.
sr_plus((Ta, Ca), (Tb, Cb), (Tc, Ca)) :- Ca == Cb, Tc is max(Ta, Tb).
sr_neg((Ta, Ca), (Tb, Ca)) :- Tb is 1.0-Ta. % confidence of negation stays the same (?)

(0.9, 0.9)::trusts(a,b).
(0.9, 0.8)::trusts(a,b).
(0.3, 0.5)::trusts(a,c).
(0.2, 0.1)::trusts(b,c).


trusts2(X,X).
trusts2(X,Y) :- trusts(X,Y). 
trusts2(X,Y) :- trusts(X,Z), trusts2(Z,Y).

query(trusts2(a,c)).
