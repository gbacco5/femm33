clear all;
close all;
clc;

header = 5;

D = dlmread('../output/results.out');
D = D(header + 1:end, :);

thm = D(:,1);
torque = D(:,2);
Wm  = D(:,10); 
Wcm = D(:,11);

dWmdthm = gradient(Wm)/(thm(2) - thm(1))/pi*180;
dWcmdthm = gradient(Wcm)/(thm(2) - thm(1))/pi*180;

plot(thm,torque,'.-',thm,dWmdthm,'o-')
