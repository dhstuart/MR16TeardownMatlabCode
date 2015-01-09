% pitchmarker.m

t = linspace(0, 20, 50);
sig = sin(t) + rand(size(t))*0.2;

% Hilbert transform to give an analytic signal.
% The complex argument will
% now be the instantaneous phase.
n = length(sig);
m = n/2+1;
U = fft(sig) / length(sig);
U((m+1):n) = 0;
cpx = ifft(U);

% Get the phase.
% phase = arg(cpx);
phase = angle(cpx);

% Unwrap the phase.
for i = 2:length(phase)
    k = round((phase(i) - phase(i-1))/(2*pi));
    phase(i) = phase(i) - k*2*pi;
end

% Fit a linear model.
lin_est = [t', repmat(1, length(t), 1)] \ phase';

% The frequency is the rate of change of the phase over time.
freq_est = lin_est(1)/2/pi
T_est = 1 / freq_est