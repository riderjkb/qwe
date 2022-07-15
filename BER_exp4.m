%A script to compare the BER of BASK, BFSK, BPSK from simulation and theory
%Variables:
%Sig_Length - bit length of the simulated signal
%Eb - bit energy of the simulated signal
Sig_Length = 2000;
Eb = 1;
%Eb/No for theoretical calculations (high resolution)
EtoN_dB = linspace(0,20,100);
EtoN = 10.^(EtoN_dB/10);
%Eb/No for simulation (five data points)
EtoN_dB_sim = linspace(0,20,5);
EtoN_sim = 10.^(EtoN_dB_sim/10);
%No for simulation purposes
No = Eb./EtoN_sim;
%Theoretical BER calculations
BER_BASK_te = (1/2)*erfc(sqrt(EtoN/4));
BER_BFSK_te = (1/2)*erfc(sqrt(EtoN/2));
BER_BPSK_te = (1/2)*erfc(sqrt(EtoN));
for iter = 1:length(EtoN_sim)
%Initialize error as 0
E_BASK = 0;
E_BFSK = 0;
E_BPSK = 0;
%Generate random string of bits with the length specified above
bit = randi([0 1],1,Sig_Length);
%Modulation of BFSK signal
x_BFSK = bit+1j*(~bit);
%Modulation of BASK signal
x_BASK = bit;
%Modulation of BPSK signal
x_BPSK = 2*bit-1;
% Generating noise
N_ril = sqrt(No(iter)/2)*randn(1,Sig_Length);
N_imj = sqrt(No(iter)/2)*randn(1,Sig_Length);
N = N_ril + 1j*(N_imj);
%Adding AWGN noise to the modulated signal
Y_BASK = x_BASK + N;
Y_BFSK = x_BFSK + N;
Y_BPSK = x_BPSK + N;
for iter2 = 1:Sig_Length
%BASK detector
Z_BASK(iter2) = (Y_BASK(iter2));
%Decision circuit BASK
if (Z_BASK(iter2) > 0.5 && bit(iter2) == 0) || (Z_BASK(iter2) < 0.5 && bit(iter2) == 1);
E_BASK = E_BASK + 1;
end
%BFSK detector
Z_BFSK(iter2) = real(Y_BFSK(iter2))-imag(Y_BFSK(iter2));
%Decision circuit BFSK
if (Z_BFSK(iter2) > 0 && bit(iter2) == 0) || (Z_BFSK(iter2) < 0 && bit(iter2) ==1);
E_BFSK = E_BFSK + 1;
end
%BPSK detector
Z_BPSK(iter2) = Y_BPSK(iter2);
%Decision circuit BPSK
if (Z_BPSK(iter2) > 0 && bit(iter2) == 0) || (Z_BPSK(iter2) < 0 && bit(iter2) == 1);
E_BPSK = E_BPSK + 1;
end
end
%Simulated BER calculations
BER_BASK_sim(iter) = E_BASK/Sig_Length;
BER_BFSK_sim(iter) = E_BFSK/Sig_Length;
BER_BPSK_sim(iter) = E_BPSK/Sig_Length;
end
%Making the graph
semilogy(EtoN_dB,BER_BASK_te,'k','color','red');
hold on
semilogy(EtoN_dB_sim,BER_BASK_sim,'k*','color','red');
semilogy(EtoN_dB,BER_BFSK_te,'k','color','green');
semilogy(EtoN_dB_sim,BER_BFSK_sim,'k*','color','green');
semilogy(EtoN_dB,BER_BPSK_te,'k','color','blue');
semilogy(EtoN_dB_sim,BER_BPSK_sim,'k*','color','blue');
legend('BASK theory','BASK simulation','BFSK theory','BFSK simulation','BPSK theory','BPSK simulation','location','best');
axis([min(EtoN_dB) max(EtoN_dB) 10^(-6) 1]);
xlabel('Eb/No (dB)');
ylabel('BER');
title('Comparison of BER performance curves (BER vs. Eb/No)');
grid on;
hold off
