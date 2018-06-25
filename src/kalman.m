function [ x, P ] = kalman( x, P, z, F, H, R, Q )
  %Predykcja
  x = F * x;
  P = F * P * F' + Q;
  
  %Aktualizacja
  k = P * H' * inv(H * P * H' + R);
  x = x + k * (z - H * x);
  I = eye(length(x));
  P = (I - k * H) * P;
end

