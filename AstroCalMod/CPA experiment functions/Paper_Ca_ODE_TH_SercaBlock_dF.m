%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Marsa Taheri, 2020
% This is the ODE used when SERCA pumps are slowly and linearly blocked by CPA.
% This code is a modification of the model code from the following 2 papers
% and on ModelDB (http://senselab.med.yale.edu/modeldb/default.asp),
% Model no. 189344:
% 
% Taheri M, Handy G, Borisyuk A, White JA (2017) Front Syst Neurosci.
% and
% Handy G, Taheri M, White JA, Borisyuk A (2017) J Comput Neurosci.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function xdot = Paper_Ca_ODE_TH_SercaBlock_dF(t, x0)

CaCyt = x0(1); % calcium concentration in the cytosol
CaT = x0(2);   % total free calcium concentration in the cytosol
h = x0(3);     % deactivating variable for the IP3R

%% Global Parameters
global gamma delta v_ip3r v_leak v_in k_out v_pmca k_pmca
global d1 d2 d3 d5 a2
global v_serca k_serca
global k_soc v_soc
global IP3inputTime d_rise d_decay
global r_rise Amp
global tSERCAblocked v_sercaOrig dtval timeToFullBlock

% finds the IP3 value at the current time
[ ip ] = ip_function_TH(d_rise, d_decay, r_rise, Amp, IP3inputTime, t);

% Uses conservation to find the calcium in the ER
CaER = (CaT-CaCyt)*gamma;

%% Terms for Calcium Dynamics on ER:

% terms for IP3R
minf = ip/(ip + d1);
ninf = CaCyt/(CaCyt + d5);
j_ip3r = v_ip3r*minf^3*ninf^3*h^3*(CaER - CaCyt);

% terms for the h ODE
q2 = d2*(ip+d1)/(ip+d3);
tauh = 1/(a2*(q2+CaCyt));
hinf = q2/(q2+CaCyt);

% Leak Term from ER
j_leak = v_leak*(CaER-CaCyt);

% %SERCA pump is blocked slowly here
slopeBlock= -v_sercaOrig/timeToFullBlock; %0.9 = default SERCA (0.9) - fully blocked (0)
v_serca = slopeBlock*(t-tSERCAblocked+dtval) + v_sercaOrig; 
if v_serca<0
    v_serca=0;
end

j_serca = v_serca*CaCyt^1.75/(CaCyt^1.75 + k_serca^1.75);

%% Terms for Calcium Dynamics on Plasma Membrane:

%PMCA pump
j_pmca = v_pmca*CaCyt^2/(k_pmca^2 + CaCyt^2);

%SOCC 
j_soc=v_soc*k_soc^4./(k_soc^4+CaER.^4);

%Leak Terms (aka J_ECS_add)
j_out = k_out*CaCyt;
j_in = v_in;

%% ODEs
xdot(1) = j_ip3r-j_serca+j_leak + (j_in-j_out+j_soc-j_pmca)*delta; %ODE for [Ca]cyt
xdot(2) = (j_in-j_out+j_soc-j_pmca)*delta; %ODE for [Ca]Total (NOT ER)
xdot(3) = (hinf - h)/tauh; %ODE for h

xdot=xdot';
end

