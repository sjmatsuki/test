%Read from file to table
moving = readtable('moving3.txt');
static = readtable('static2.txt');

%From table to array
A = table2array(moving);
B = table2array(static);
initial_time = A(1, 1);
time = (A(:, 1) - initial_time);

%Analyze Data Error
mean_E_st = mean(B(:,5));
mean_N_st = mean(B(:,3));

var_E_st = (B(:,5))-mean_E_st;
var_N_st = (B(:,3))-mean_N_st;

static_spot = sqrt(B(:,5).^2 + B(:,3).^2);

figure(5)
histfit(static_spot)
title('Error Distribution for Static Measurements(UTM)')
xlabel('Location')
ylabel('Measurements')

%Plot

figure(1)
plot(A(:,4),A(:,2))
title('Moving in a Straight Line-LatLon')
xlabel('Longitude')
ylabel('Latitude')

figure(2)
plot(B(:,4), B(:,2))
title('Standing Still-LatLon')
xlabel('Longitude')
ylabel('Latitude')

figure(3)
plot(A(:,5), A(:,3))
title('Moving in a Straight Line-UTM')
xlabel('Easting')
ylabel('Northing')

figure(4)
plot(B(:,5), B(:,3))
title('Standing Still-UTM')
xlabel('Easting')
ylabel('Northing')