%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Marsa Taheri, 2020
% This code is part of the AstroCalMod GUI code for generating the IP3
% waveform used to generate IP3-dependent Calcium responses.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pkamp = str2double(handles.PeakAmp_entry.String);
d_rise = str2double(handles.RiseDur_entry.String);
r_rise = str2double(handles.RiseRate_entry.String);
d_decay = str2double(handles.DecDur_entry.String);
TotalTime = str2double(handles.TotalTime_entry.String);
IP3inputTime = str2double(handles.IP3input_entry.String);
dt=0.01;
t = 0:dt:TotalTime;

IP3trace = ip_function_TH(d_rise, d_decay, r_rise, pkamp,...
    IP3inputTime, t);

axes(handles.axes_PlotIP3input);
plot(t, IP3trace,'linewidth', 2.5, 'color', [0 0.55 0.35])
set(handles.axes_PlotIP3input, 'ylim', [0 max([0.7, max(IP3trace)])+0.25], 'xlim', [0 TotalTime],...
    'box', 'off', 'xtick', [], 'ytick', [], 'color', [0.941 0.941 0.941],...
    'ycolor', [0.941 0.941 0.941], 'xcolor', [0.941 0.941 0.941])%,...
text(min([-50, -TotalTime/8]), max([0.7, max(IP3trace)])+0.1,...
    '[IP_3]', 'color', [0 0.55 0.35], 'FontUnits', 'normalized', 'Fontsize', 0.27)
text(min([-50, -TotalTime/8]), 0.15 , '0 \muM', 'color', [0 0.55 0.35],...
    'FontUnits', 'normalized', 'Fontsize', 0.21)
maxIP3idx = find(IP3trace == max(IP3trace),1,'last');
maxIP3loc = t(maxIP3idx);
text(maxIP3loc, max(IP3trace)+0.15, [num2str(max(IP3trace)), ' \muM'],...
    'color', [0 0.55 0.35], 'FontUnits', 'normalized', 'Fontsize', 0.21)
