
<img src="https://github.com/di-unipi-socc/SecFog/blob/master/img/secfog.bmp" width="250">

SecFog is a simple declarative prototype that can be used to find multi-service application deployments to
Cloud-Edge infrastructures and to assess their security level based on specific application security requirements, available infrastructure security capabilities, and considering trust degrees in different Edge and Cloud providers. SecFog constitutes a first, well-founded and explainable effort towards this direction.

SecFog is written in the [ProbLog2 language](https://dtai.cs.kuleuven.be/problog/index.html) and it can be used together with existing approaches (e.g., [FogTorchPi](https://github.com/di-unipi-socc/FogTorchPI/tree/multithreaded)) that solve the problem of mapping IoT application services to Cloud-Edge infrastructures according to requirements other than security and trust.

SecFog methodology is described in the following journal paper:

> [Stefano Forti](http://pages.di.unipi.it/forti), [Gian-Luigi Ferrari](http://pages.di.unipi.it/giangi), [Antonio Brogi](http://pages.di.unipi.it/brogi)<br>
> [**Secure Cloud-Edge Deployments, with Trust**](https://doi.org/10.1016/j.future.2019.08.020), <br>	
> Future Generation Computer Systems, vol. 102, pp. 775-788, 2020. 

If you wish to reuse source code in this repo, please consider citing the above mentioned article.

### Example
Considering a single-service application, managing the weather data of a municipality, and an infrastructure composed of two (one Cloud and one Edge) nodes declared as follows:

```prolog
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
```

outputs the resulting secure deployments for the ```weatherApp```, along with a value in the range [0,1] that represents their assessed security level (based on the declared effectiveness of infrastructure capabilities that are exploited by each possible deployment):

```bash
secFog(appOp,weatherApp,[d(weatherMonitor,cloud,cloudOp)]):    0.989901
  secFog(appOp,weatherApp,[d(weatherMonitor,edge,edgeOp)]):    0.8415
```

The AND-OR trees of the two ground programs that lead to the output results can be obtained automatically, by using ProbLog in [```ground``` mode](https://problog.readthedocs.io/en/latest/cli.html#grounding-ground).  

![alt text](https://github.com/di-unipi-socc/SecFog/blob/master/img/weathergrounding.png)

The ProbLog engine performs an AND-OR graph search over the ground program to determine the query results.
For instance, the value associated with ```securityRequirements(weatherMonitor,cloud)``` is obtained as:

![alt text](https://github.com/di-unipi-socc/SecFog/blob/master/img/formulaGit.png)

As for the AND-OR graph of the ground program, also this proof can be obtained automatically, by using Problog in [```explain``` mode](https://problog.readthedocs.io/en/latest/cli.html\#explanation-mode-explain).

A trust network among different stakeholders can also be defined and included in the security assessment of eligible secure deployments:

```prolog
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

%%% trust relation declared ispOp
.8::trusts(ispOp, cloudOp).
.6::trusts(ispOp, edgeOp).
```

The example without considering trust can be run [here](https://dtai.cs.kuleuven.be/problog/editor.html#task=prob&hash=c0256558fc411afe2f70a38b52058378), whilst the one that includes trust propagation can be run [here](https://dtai.cs.kuleuven.be/problog/editor.html#task=prob&hash=25bbacb9ad8e4120ca7a68aa94e5d0a8).
