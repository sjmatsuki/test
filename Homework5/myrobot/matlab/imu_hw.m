%Hard-iron corrections
li= 43626;
%li = 4000;
circleMagX = MagX(1:li);
circleMagY = MagY(1:li);

%Un-calibrated Data
figure (1)
plot(circleMagX, circleMagY, '-ob')
title('Un-calibrated Data')

circleMagZ = MagZ(1:li);

x_max = max(circleMagX);
x_min = min(circleMagX);
y_max = max(circleMagY);
y_min = min(circleMagY);
z_max = max(circleMagZ);
z_min = min(circleMagZ);


alpha = (x_max + x_min)/2; % X axis offset
beta = (y_max + y_min)/2; % Y axis offset
lala = (z_max + z_min)/2;
MagCZ = circleMagZ-lala;

MagCX = circleMagX - alpha;
MagCY = circleMagY - beta;
figure (2)
plot(MagCX, MagCY, '-ob');
title('Hard-iron Corrections')

%Soft Iron Correction/no tilt
r = 0.08;
q = 0.1;
omega = q/r;
R= sqrt((MagCX).^2+sqrt(MagCY).^2);
theta = asin(MagCY/R);

figure(3)
plot(MagCX/omega, MagCY, '-ob');
title('Soft and Hard Iron Corrections')



