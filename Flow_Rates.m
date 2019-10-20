clear
clc
%Calculate flow rates based on capillary numbers of two inmiscible 
%fluids.
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
%   
%
%Input arguments
%
%      wc               width of channel [m]
%      h                height of channel [m]
%      int_tension      interfacial tension between fluids [N/m]
%      Ca_dis           Capillary number for disperse phase [a.u.]
%      Ca_con           Capillary number for continuous phase [a.u.]
%      aq_int_diam      Internal diameter of syringe for disperse phase [m]
%      co_int_diam      Internal diameter of syringe for continuous phase [m]
%
%      %Disperse phase: Water @ 20 degrees
%      aq_density       Density [kg/m^3]
%      aq_kinematic_viscosity Kinematic viscosity [m^2/s]
%
%      %Continous phase: FC40 (5% w/w picosurf)
%      co_density       Density [kg/m^3]
%      co_kinematic_viscosity Kinematic viscosity [m^2/s]
%
%Output arguments
%
%      aq_vol_flow      Disperse phase flow rate[µL/min]
%      co_vol_flow      Continuous phase flow rate[µL/min]
%      droplet_volume   Calculated volume of droplet [pL]
% Author: Ricardo García Ramírez 17. July 2019
% ricardogr[at]uvic.ca, a00759652[at]itesm.mx

wc = 100e-6; %width of channel [m]
h = 10e-6;   %height of channel [m]
int_tension = 26e-3; % [N/m]
Ca_dis = 0.01; %Capillary number for disperse phase boundary condition [a.u.]
Ca_con = 0.1; %Capillary number for continuous phase boundary condition [a.u.]
aq_int_diam = 14.5*1e-3; %Internal diameter of syringe being used for disperse phase
co_int_diam = 14.5*1e-3; %Internal diameter of syringe being used for continuous phase
%disperse phase: Water @ 20 degrees
aq_density = 1000; % [kg/m^3]
aq_kinematic_viscosity = 1e-6; % [m^2/s]
%continuous phase: FC40 (5% w/w picosurf)
co_density = 1020; % [kg/m^3]
% co_kinematic_viscosity = 149.9e-3; % [m^2/s]
%Compute dynamic viscosity
aq_dynamic_viscosity = aq_density*aq_kinematic_viscosity; %[N/m]
co_dynamic_viscosity = 149.9e-3; %[N/m]
%Compute Velocity using boundary Ca
aq_velocity = Ca_dis*int_tension/aq_dynamic_viscosity; % [m/s]
co_velocity = Ca_con*int_tension/co_dynamic_viscosity; % [m/s]
%Compute volume flow
aq_vol_flow = (aq_int_diam/2)^2*pi*aq_velocity*60e3; % [µL/min]
co_vol_flow = (co_int_diam/2)^2*pi*co_velocity*60e3; % [µL/min]
%Compute volume flow that the pump can make, at least 1 µL/min
while aq_vol_flow < 1
    aq_vol_flow = aq_vol_flow*1.01;
    co_vol_flow = co_vol_flow*1.01;
end
%Determine approximate volume of droplet
droplet_volume = (1+ co_vol_flow/aq_vol_flow)*wc^2*h*1e12; % [pL]
%Display volumes
disp("Discrete phase µL/min: " + aq_vol_flow);
disp("Continuous phase µL/min: " + co_vol_flow);
disp("Calculated volume of droplet: " + droplet_volume + " pL");