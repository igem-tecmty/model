clear
clc
%Calculate flow rates based on capillary numbers of two inmiscible 
%fluids and graphing multiple iterations
%
%Calculates the Flow rates of both the continuous and disperse phase for
%droplet generation
%Governing equations are based on[1], as well as calculations from [2].
%
%     [1] P. Zhu and L. Wang, “Passive and active droplet generation 
%         with microfluidics: a review,” Lab Chip, vol. 17, no. 1, 
%         pp. 34–75, 2017.
%     [2] C. N. Baroud, F. Gallaire, and R. Dangla, “Dynamics of 
%         microfluidic droplets,” Lab Chip, vol. 10, no. 16, pp. 
%         2032–2045, 2010.
% Author: Ricardo García Ramírez 31. July 2019
% ricardogr[at]uvic.ca, a00759652[at]itesm.mx  
%
aq_vol_flow_val = [];
co_vol_flow_val = [];
droplet_volume_val = [];
i_val = [];
q_val = [];
q = 0;
%Capillary numbers are defined as i for the disperse phase and j for the
%continuous phase, the script makes iterations for these values and
%displays them in a graph as scatter points
% In order to change the properties of the fluids, it is needed to change
% the values from the Ca_num_func values for both the disperse and
% continuous phases
for j = 1e-3
    for i = 1e-6:1e-6:1e-5;    
    [aq_vol_flow, co_vol_flow,droplet_volume] = Ca_num_func(1.81e-3,i,j);
    aq_vol_flow_val = [aq_vol_flow_val,aq_vol_flow];
    droplet_volume_val = [droplet_volume_val,droplet_volume];
    co_vol_flow_val = [co_vol_flow_val,co_vol_flow];
    i_val = [i_val,i];
    %Added a ratio of flows to compare with droplet volume
    q = co_vol_flow/aq_vol_flow;
    q_val = [q_val,q];
end
end
%Graph the flow rates as scatter points
figure('Name','Flow Rates Droplet Generation','NumberTitle','off');
ax1 = subplot(1,1,1); % top subplot
hold on
%stem(co_vol_flow_val, aq_vol_flow_val, 'r')
plot(co_vol_flow_val, aq_vol_flow_val, 'bo')
title('Flow Rate for Droplet Generation')
xlabel('Continuous phase Flow Rate (µL/min)')
ylabel('Disperse phase Flow Rate in (µL/min)')