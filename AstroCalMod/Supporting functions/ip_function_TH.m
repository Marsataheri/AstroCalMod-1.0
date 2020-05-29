%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is a modification of the model code from the following 2 papers
% and on ModelDB (http://senselab.med.yale.edu/modeldb/default.asp),
% Model no. 189344:
% 
% Taheri M, Handy G, Borisyuk A, White JA (2017) Front Syst Neurosci.
% and
% Handy G, Taheri M, White JA, Borisyuk A (2017) J Comput Neurosci.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ip_value = ip_function_TH(d_rise, d_decay, r_rise, amp, stim_time, t)

% calculate the max that will be achieved
s_0=amp/(1-exp(-r_rise*(d_rise)));

% calculate the needed r_deg for d_decay to be achieved 
% checks to make sure max_ip is at least 0.005
if amp>0.005
    r_deg=-1/d_decay*log(0.005/amp);
else
    r_deg=-1/d_decay*log(0.005);
end


% either calculate ip3 at a specific time or for a range of times
if length(t)==1
    if t<stim_time
        ip_value=0;
    elseif t>=stim_time && t <= (stim_time + d_rise)
        ip_value=s_0*(1-exp(-r_rise*(t-stim_time)));
    else
        ip_value=amp*exp(-r_deg*(t-stim_time-d_rise));
    end
else
    zeros(length(t),1);
    ip_value=zeros(length(t),1);
    temp=find(t>=stim_time & t <= (stim_time +d_rise));
    ip_value(temp)=s_0*(1-exp(-r_rise*(t(temp)-stim_time)));
    temp=find(t > (stim_time +d_rise));
    ip_value(temp)=amp*exp(-r_deg*(t(temp)-stim_time-d_rise));
end

end
