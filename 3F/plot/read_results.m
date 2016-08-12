header = 6;

Data = dlmread(res_fn);
Data = Data(header + 1:end, :);

thm       = Data(:,1);
torque    = Data(:,2);
torque_dq = Data(:,4);
Lambda    = Data(:,5:7);
Lambda_dq = Data(:,8:9);
Wm        = Data(:,10); 
Wcm       = Data(:,11);
Fx        = Data(:,12);
Fy        = Data(:,13);
