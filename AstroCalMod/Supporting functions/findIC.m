%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Marsa Taheri, 2020
%
% This code is used to find the Initial Conditions (ICs) with a new set of 
%model parameters.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x0 = findIC(IntrinsicParams, xstart)
%Uses the Intrinsic Params to run simulations without any IP3 inputs, and
%find the steady state values of the Initial Conditions.

x0 = nan(1,3);
%if user did not provide a starting point for ICs, set it to the striatum, WT conditions
if nargin<2
    xstart = [0.0615, 37.4192, 0.7017]; %CaCyt, CaTot, h (values for striatum WT)
end

%Run model without an IP3 input for a long enough time to find ICs:
IP3paramsForIC = ones(1,4)*1e-4;
TotalTimeForIC = 500;
IP3inputTimeForIC = TotalTimeForIC;
[CaCyt, ~, ~, ~, CaTot, h_IP3R] = AstroModel(IP3paramsForIC,...
    TotalTimeForIC, IP3inputTimeForIC, IntrinsicParams, xstart);

%while the initial conditions are changing and not stabilized enough,
%continue calculating ICs:
Nruns=1;
while abs(sum(diff(CaCyt(end-1000:end))))>1e-5 && Nruns<20 %-2e-8
    Nruns = Nruns+1; %Nruns limits the number of iterations for finding ICs
    %reset the initial conditions:
    xstart = [CaCyt(end), CaTot(end), h_IP3R(end)]; %CaCyt, CaTot, h 
    TotalTimeForICnew = 2000;
    [CaCyt, ~, ~, ~, CaTot, h_IP3R] = AstroModel(IP3paramsForIC,...
        TotalTimeForICnew, IP3inputTimeForIC, IntrinsicParams, xstart);
end

if abs(sum(diff(CaCyt(end-1000:end))))>1e-5
    disp('The ICs found may not be fully accurate. Please reconsider parameters.')
end


x0(1) = CaCyt(end);
x0(2) = CaTot(end);
x0(3) = h_IP3R(end);

