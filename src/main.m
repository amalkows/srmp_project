clear all;

data = csvread('data.csv', 1, 1);
N = length(data);
std_x = 50;
std_y = 50;

std_v = 0;
std_u = 1.5;

T = data(1, 3);
Fp = [1 T; 0 1];
F = blkdiag(Fp, Fp);
H = [1 0 0 0; 0 0 1 0];
R = diag([std_x^2 std_y^2]);
Qp = std_u^2 * [T; 1] * [T; 1]';
Q = blkdiag(Qp, Qp);

z = data(:, 1:2)';
x_est = [z(1); 0; z(2); 25];
P = diag([std_x^2 std_v^2 std_y^2 std_v^2]);
v = [5;20];
for k = 2:N
  
  T = data(k-1,3);
  Fp = [1 T; 0 1];
  F = blkdiag(Fp, Fp);
  [x_est(:, k), P(:, :, k)] = kalman( x_est(:, k - 1), P(:, :, k - 1), z(:, k), F, H, R, Q );
  v(1, k) = (z(1, k)-z(1,k-1))/data(k-1,3);
  v(2, k) = (z(2, k)-z(2,k-1))/data(k-1,3);

end

time = data(:, 4);
time = time + 2 * 60 * 60 * 1000;
time = datetime(time/1000, 'ConvertFrom', 'posixtime');

figure
plot(time, (x_est(2,:).^2+x_est(4,:).^2).^(1/2)*3.6, time, (v(1,:).^2+v(2,:).^2).^(1/2)*3.6, '.')
xlabel('Czas')
ylabel('Prêdkoœæ [km/h]')
datetick('x','HH:MM')

figure
plot(time, x_est(1,:)/1000, time, z(1,:)/1000, '.')
xlabel('Czas')
ylabel('Po³o¿enie x [km]')
datetick('x','HH:MM')

figure
plot(time, x_est(3,:)/1000, time, z(2,:)/1000, '.')
xlabel('Czas')
ylabel('Po³o¿enie y [km]')
datetick('x','HH:MM')

figure
plot(time, x_est(2,:)*3.6, time, v(1, :)*3.6, '.')
xlabel('Czas')
ylabel('Prêdkoœæ x [km/h]')
datetick('x','HH:MM')

figure
plot(time, x_est(4,:)*3.6, time, v(2, :)*3.6, '.')
xlabel('Czas')
ylabel('Prêdkoœæ y [km/h]')
datetick('x','HH:MM')

figure
plot(x_est(1,:)/1000, x_est(3,:)/1000, z(1,:)/1000, z(2,:)/1000, '.')
xlabel('Po³o¿enie x [km]')
ylabel('Po³o¿enie y [km]')
xlim([0 15]) 
ylim([0 30])
