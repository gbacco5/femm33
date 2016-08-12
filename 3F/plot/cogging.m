clear all;
close all;
clc;

m = 3;
% results filename
res_fn = '../output/results_20160812_090941.out';

read_results % self-explaining

% create transformation matrices
T = 2/m*[cos([0:m-1]*2*pi/m)' , sin([0:m-1]*2*pi/m)'];
U = [cos([0:m-1]*2*pi/m)' , sin([0:m-1]*2*pi/m)'];

function [d,q] = dq2ab(a,b,x)
  d = a.*cos(x) - b.*sin(x);
  q = b.*cos(x) + a.*sin(x);
end
function [a,b] = ab2dq(d,q,x)
  d = a.*cos(-x) - b.*sin(-x);
  q = b.*cos(-x) + a.*sin(-x);
end

Lambda_dq_rep = repmat(Lambda_dq,6,1);
Thm = linspace(0,360, 6*length(thm))';
[Lambda_A, Lambda_B] = dq2ab(Lambda_dq_rep(:,1),Lambda_dq_rep(:,2),Thm*pi/180);
Lambda_abc = (U*[Lambda_A';Lambda_B'] )';

% compute torque from magnetic energies
DWmDthm = gradient(Wm)/(thm(2) - thm(1))/pi*180;
DWcmDthm = gradient(Wcm)/(thm(2) - thm(1))/pi*180;

plot(thm,torque,'.-',thm,DWmDthm,'o-')

figure
plot(Thm,Lambda_abc)