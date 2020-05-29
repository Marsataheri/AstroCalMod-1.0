%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Marsa Taheri, 2020
% This code is part of the AstroCalMod GUI code for generating the timeline
% for simulation of the CPA experiment.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PhaseIend = str2double(handles.edit_CaFreeStart.String);
PhaseIIend = str2double(handles.edit_CPAStart.String);
PhaseIIIend = str2double(handles.edit_CaFreeEnd.String);

set(handles.CPATimeLine_axes, 'FontUnits', 'normalized', 'Fontsize', 0.1,...
    'XLim', [0 str2double(handles.CPASimTime_entry.String)],...
    'YLim', [0.45, 0.55]);
axes(handles.CPATimeLine_axes); 
cla(handles.CPATimeLine_axes)

hold(handles.CPATimeLine_axes, 'on')

line([PhaseIend, PhaseIIIend], [0.52, 0.52], 'linewidth', 3, 'color', [0.6 0 0])
line([PhaseIIend, str2double(handles.CPASimTime_entry.String)], [0.455, 0.455],...
    'linewidth', 3, 'color', [1 0.6 0.2])
text(mean([PhaseIend, PhaseIIend]), 0.55, 'Calcium Free', 'fontsize', 11,...
    'color', [0.6 0 0],'FontUnits', 'normalized', 'Fontsize', 0.42)
text(mean([PhaseIIend, str2double(handles.CPASimTime_entry.String)]), 0.48,...
    'CPA', 'fontsize', 11, 'color', [0.9 0.5 0.15], 'FontUnits', 'normalized', 'Fontsize', 0.42)

