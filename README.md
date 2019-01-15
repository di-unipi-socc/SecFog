# SecFog

SecFog helps application operators in determining secure deployments based on specific application security requirements, available infrastructure security capabilities, and considering trust degrees in different Edge and Cloud providers. 

SecFog is written in the [ProbLog2 language](https://dtai.cs.kuleuven.be/problog/index.html) and it can be used together with existing approaches (e.g., [FogTorchPi](https://github.com/di-unipi-socc/FogTorchPI/tree/multithreaded)) that solve the problem of mapping IoT application services to Cloud-Edge infrastructures according to requirements other than security and trust.

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
    0.85::anti_tampering(edge).
    0.9::wireless_security(edge).
    0.9::iot_data_encryption(edge).
```

outputs the resulting secure deployments for the ```weatherApp```, along with a value in the range [0,1] that represents their assessed security level (based on the declared effectiveness of infrastructure capabilities that are exploited by each possible deployment):

```bash
secFog(appOp,weatherApp,[d(weatherMonitor,cloud,cloudOp)]):    0.989901
  secFog(appOp,weatherApp,[d(weatherMonitor,edge,edgeOp)]):    0.8415
```

The AND-OR trees of the two ground programs that lead to the output results can be obtained automatically, by using ProbLog in [```ground``` mode](https://problog.readthedocs.io/en/latest/cli.html#grounding-ground).  The ProbLog engine performs an AND-OR graph search over the ground program to determine the query results.
For instance, the value associated with {\tt\small securityRequirements(weatherMonitor,cloud)} is obtained as:

$
p({\tt anti\_tampering(cloud)}) \times\ p({\tt iot\_data\_encryption(cloud)}) +\\
(1-p({\tt\small anti\_tampering(cloud)})) \times\ p({\tt\small access\_control(cloud)}) \times\ p({\tt\small iot\_data\_encryption(cloud)})
= \\
.99 \times .99 +  (1-.99) \times .99 \times .99
=\\
0.989901
$

As for the AND-OR graph of the ground program, also this proof can be obtained automatically, by using Problog in [```explain``` mode](https://problog.readthedocs.io/en/latest/cli.html\#explanation-mode-explain).
