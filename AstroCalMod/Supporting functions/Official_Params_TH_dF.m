%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is a modification of the model code from the following 2 papers
% and on ModelDB (http://senselab.med.yale.edu/modeldb/default.asp),
% Model no. 189344:
%
% Taheri M, Handy G, Borisyuk A, White JA (2017) Front Syst Neurosci.
% and
% Handy G, Taheri M, White JA, Borisyuk A (2017) J Comput Neurosci.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global gamma delta v_ip3r v_leak v_in k_out v_pmca k_pmca
global d1 d2 d3 d5 a2
global v_serca k_serca
global k_soc v_soc
global IP3inputTime d_rise d_decay
global r_rise Amp

%% Pump/Receptor/Leak Parameters
gamma=5.4054;

% Leak for ER
v_leak=0.002; 

% Leak for Extracellular Space
v_in=0.05; 
k_out=1.2;

% IP3R Parameters
v_ip3r=0.222;
% Li-Rinzel Parameters
d1=0.13; d2=1.049; d3=943.4e-3; d5=0.08234; 
a2=0.04; %adjusted Li-Rinzel Parameter

% PMCA Terms
v_pmca=10;
k_pmca=2.5;

% SOCC Terms
v_soc=1.57;
k_soc=90;

% SERCA Terms
v_serca=0.9;
k_serca=0.1;
 
% Sneyd Parameter
delta=0.2;
