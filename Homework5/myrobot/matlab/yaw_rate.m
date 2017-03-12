%Yaw Rate
GyroData= GyroZ;
%1-pole butterworth lowpass filter
[b,a] = butter(1, 0.4);
GyroBW = (filter(b,a,GyroData))*180/(2*pi);
Gyro_D = GyroBW;
Gyro_DD = (filter(b,a,GyroBW))*180/(2*pi);

figure (1)
plot(GyroBW);
title('Yaw Rate, 1-pole Butterworth Filter')

%ode23.m
GyroODE = (cumtrapz(unwrap(GyroData)));
%mean(GyroODE)

figure (2)
plot (GyroODE);
title('Yaw Rate, ode23')

%Complementary Filter
yaw_cf = 0.95*GyroBW + 0.05*GyroData
figure (4)
plot (yaw_cf)
title('Complementary Filter')

%Low-pass Filter
tau = 16;
dt = 800;
alpha = (tau)/(tau+dt);
%yaw_rate = (1-alpha)*(angle+gyro*dt) + (alpha)*(acc);

% yaw = 0.98*integratedYawData+ 0.02*yaw(from corrected magnetometer data)






