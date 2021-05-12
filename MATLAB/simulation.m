clear all
close all

load VDS_TEST_AUDIO_44_1_K.txt

t = linspace(1, length(VDS_TEST_AUDIO_44_1_K), length(VDS_TEST_AUDIO_44_1_K));

figure;
subplot (4,1,1);
plot (t, VDS_TEST_AUDIO_44_1_K)
ylabel('Audio Signal')
hold on

% 44.1 kHz
% 44100/1000*32 = 44.1*32 = 1411.2

E = zeros(length(VDS_TEST_AUDIO_44_1_K),1);
beta2 = 0.98;
NL = zeros(length(VDS_TEST_AUDIO_44_1_K),1);
beta1 = 0.95;
VAD_OUT = zeros(length(VDS_TEST_AUDIO_44_1_K),1);
VAD_OUT(1) = 0;
E(1) = 10000*VDS_TEST_AUDIO_44_1_K(1)*VDS_TEST_AUDIO_44_1_K(1);
NL(1) = 800;
for i = 2:length(VDS_TEST_AUDIO_44_1_K)
    j = mod(i, 1411);
    VAD_OUT(i) = VAD_OUT(i-1);
    NL(i) = NL(i-1);
    E(i) = E(i-1);
    if j == 0
        E(i) = 400*VDS_TEST_AUDIO_44_1_K(i)*VDS_TEST_AUDIO_44_1_K(i);
        if E(i) > 4000
            E(i) = 4000;
        end
    elseif j <= (1411.2 / 2)
        E(i) = E(i-1) + 400 * VDS_TEST_AUDIO_44_1_K(i)*VDS_TEST_AUDIO_44_1_K(i);
        if E(i) > 4000
            E(i) = 4000;
        end
    elseif j == int32(1411.2/2 + 1) 
        if E(i) > NL(i-1)
            NL(i) = beta1 * NL(i-1) + (1-beta1) * E(i);
        else
            NL(i) = beta2 * NL(i-1) + (1-beta2) * E(i);
        end
        if (0.77*E(i)) > NL(i)
            VAD_OUT(i) = 1;
        else
            VAD_OUT(i) = 0;
        end
    end
end

subplot (4,1,4);
plot (t, VAD_OUT)
ylabel('VAD OUT')
ylim([-0.5 1.5])
subplot (4,1,2);
plot (t, E)
ylabel('E');
subplot (4,1,3);
plot (t, NL)
ylabel('NL');