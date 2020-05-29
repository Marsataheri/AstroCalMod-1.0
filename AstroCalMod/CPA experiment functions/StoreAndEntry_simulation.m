%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Marsa Taheri, 2020

% This code is used to reproduce the CPA-induced store depletion/Ca2+
% capacitive entry experiments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CaCyt, t, Fluor_Hill, CaTot,...
    h_IP3R] = StoreAndEntry_simulation(PhaseIIstart,...
    PhaseIIIstart, PhaseIVstart, TotalTime, IntrinsicParams, x0)

clear global

Official_Params_TH_dF;

global tSERCAblocked v_sercaOrig dtval timeToFullBlock

dt = 0.01; %0.001
exp_t = [0:dt:TotalTime]';
t_RemCaEC = PhaseIIstart; 
t_BlockSERCA = PhaseIIIstart; 
t_AddCaEC = PhaseIVstart;

dtval = dt; %needed for running "Paper_Ca_ODE_TH_SercaBlock_dF.m"
tSERCAblocked = t_BlockSERCA; %needed for running "Paper_Ca_ODE_TH_SercaBlock_dF.m"
timeToFullBlock = 80; 

%% Params & ICs:
%loaded intrinsic parameters:
v_pmca = IntrinsicParams(1);
v_soc = IntrinsicParams(2);
v_serca = IntrinsicParams(3);
v_ip3r = IntrinsicParams(4);
v_leak = IntrinsicParams(5);
v_in = IntrinsicParams(6);
k_out = IntrinsicParams(7);

v_soc_SET = v_soc;
v_sercaOrig = v_serca; %needed for running "Paper_Ca_ODE_TH_SercaBlock_dF.m"

%Since there's no IP3 in this experimental simulation, set IP3 input
%time to after end of stimulation:
IP3inputTime = exp_t(end)+dt;
Amp = 0; d_decay=0; d_rise=0; r_rise = 0;

%% Run simulations:

options = odeset('AbsTol', 10^-6, 'RelTol', 10^-6, 'MaxStep', 0.1);

%-----------------------PHASE I: Baseline-----------------------
%v_soc=1.57; v_in=0.05; v_serca=0.9; %default values
x0I = x0; %Initial Conditions
tPhaseI = exp_t(exp_t <t_RemCaEC);
[tI,x_simI] = ode45(@Paper_Ca_ODE_TH_dF,tPhaseI,x0I,options);

%-----------------------PHASE II: Calcium Free-----------------------
v_soc = 0; v_in = 0;
x0II = x_simI(end,:); %New Initial Conditions
tPhaseII = exp_t(exp_t >=t_RemCaEC & exp_t <t_BlockSERCA);
[tII,x_simII] = ode45(@Paper_Ca_ODE_TH_dF,tPhaseII,x0II,options);

%-----------------------PHASE III-----------------------
%Slow blocking of SERCA:
x0III = x_simII(end,:); %New Initial Conditions
tPhaseIII = exp_t(exp_t >=t_BlockSERCA & exp_t <t_AddCaEC);
[tIII,x_simIII] = ode45(@Paper_Ca_ODE_TH_SercaBlock_dF,tPhaseIII,x0III,options);

%-----------------------PHASE IV-----------------------
v_in = 0.05; v_soc = v_soc_SET;
x0IV = x_simIII(end,:); %New Initial Conditions
tPhaseIV = exp_t(exp_t >=t_AddCaEC);
[tIV,x_simIV] = ode45(@Paper_Ca_ODE_TH_dF,tPhaseIV,x0IV,options);

%%
%---------------Include Info For All Phases-------------
t = [tI; tII; tIII; tIV];
x_sim = [x_simI; x_simII; x_simIII; x_simIV];
CaCyt = x_sim(:,1);
CaTot = x_sim(:,2);
h_IP3R = x_sim(:,3);

%Simple conversion since GCaMP6f is fast relative to astrocyte calcium:
%kGCdis = 3.93; %koff for GCaMP6f; s-1
KGChill = 375*10^(-3); %Kd, converted from nM to microM
nGC = 2.27; %Hill Coefficient
%kGCbind = kGCdis/KGChill; microM-1*s-1
Fluor_Hill = CaCyt.^nGC./(CaCyt.^nGC + KGChill);
