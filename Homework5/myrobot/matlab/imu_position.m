velocityX = cumtrapz(AccelX).*GyroX;
velocityY = cumtrapz(AccelY).*GyroY;
positionX = cumtrapz(velocityX);
positionY = cumtrapz(velocityY);

[b,a] = butter(1, 0.4);
wX = (filter(b,a,GyroZ))*180;

yobs = AccelY + velocityX.*wX;

figure(1)
plot(yobs)
title('Y Obs')

figure(2)
plot(AccelY)
title('Y Acceleration')

% %IMU Position
% d = size(AccelX);
% time = 1:d;
% X = velocityX* + 1/2*AccelX*d^2;

plot(positionX, positionY)
title('IMU Position Data')
xlabel('UTMX')
ylabel('UTMY')






