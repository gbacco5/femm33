clear all;
close all;
clc;

% results filename
res_fn = '../output/results_20160812_090941.out';

read_results % self-explaining

% compute torque from magnetic energies
DWmDthm = gradient(Wm)/(thm(2) - thm(1))/pi*180;
DWcmDthm = gradient(Wcm)/(thm(2) - thm(1))/pi*180;

plot(thm,torque,'.-',thm,DWmDthm,'o-')

figure
plot(thm,Lambda)