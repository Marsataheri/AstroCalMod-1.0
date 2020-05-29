%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Marsa Taheri, 2020
%
% This code is a modification of the model code from the following 2 papers
% and on ModelDB (http://senselab.med.yale.edu/modeldb/default.asp),
% Model no. 189344:
%
% Taheri M, Handy G, Borisyuk A, White JA (2017) Front Syst Neurosci.
% and
% Handy G, Taheri M, White JA, Borisyuk A (2017) J Comput Neurosci.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CaCyt, t, Fluor_Hill, IP3trace,...
    CaTot, h_IP3R] = AstroModel(IP3params, TotalTime,...
    IP3inputTimeNotGlobal, IntrinsicParams, x0)

clear global

Official_Params_TH_dF;

dt = 0.01;%0.001;
exp_t = [0:dt:TotalTime]';

%% I.C.s:
%I.C. for the official params starting from steady state:
v_pmca = IntrinsicParams(1);
v_soc = IntrinsicParams(2);
v_serca = IntrinsicParams(3);
v_ip3r = IntrinsicParams(4);
v_leak = IntrinsicParams(5);
v_in = IntrinsicParams(6);
k_out = IntrinsicParams(7);

%% Run simulations:

%IP3 Params:
IP3inputTime = IP3inputTimeNotGlobal; %overriding the global one in case changed in findIC fxn
ip_input = IP3inputTime; 

Amp=IP3params(1);
d_rise=IP3params(2);
r_rise=IP3params(3);
d_decay=IP3params(4);

options = odeset('AbsTol', 10^-6, 'RelTol', 10^-6, 'MaxStep', 0.1);

[t,x_sim] = ode45(@Paper_Ca_ODE_TH_dF,exp_t,x0,options);
CaCyt = x_sim(:,1); 
CaTot = x_sim(:,2);
h_IP3R = x_sim(:,3);

IP3trace = ip_function_TH(d_rise, d_decay, r_rise, Amp, ip_input, t);

%Simple conversion since GCaMP6f is fast relative to astrocyte calcium:
%kGCdis = 3.93; %koff for GCaMP6f; s-1
KGChill = 375*10^(-3); %Kd, converted from nM to microM
nGC = 2.27; %Hill Coefficient
%kGCbind = kGCdis/KGChill; microM-1*s-1
Fluor_Hill = CaCyt.^nGC./(CaCyt.^nGC + KGChill); 

