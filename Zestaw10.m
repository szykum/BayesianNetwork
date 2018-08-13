% Metody teoretyczne

clc

clear

N=1; T=2; % falsz, prawda

pW(T)=0.002;
pU(T)=0.5;
pT(T)=0.06;

pW(N)=1-pW(T);
pU(N)=1-pU(T);
pT(N)=1-pT(T);

pwSWU(T,N,N)=0.02;
pwSWU(T,N,T)=0.2;
pwSWU(T,T,N)=0.07;
pwSWU(T,T,T)=0.3;

pwSWU(N,N,N)=1-pwSWU(T,N,N);
pwSWU(N,N,T)=1-pwSWU(T,N,T);
pwSWU(N,T,N)=1-pwSWU(T,T,N);
pwSWU(N,T,T)=1-pwSWU(T,T,T);


pwAT(T,N)=0.01;
pwAT(T,T)=0.1;

pwAT(N,N)=1-pwAT(T,N);
pwAT(N,T)=1-pwAT(T,T);



pwZSA(T,N,N)=0.11;
pwZSA(T,N,T)=0.9;
pwZSA(T,T,N)=0.4;
pwZSA(T,T,T)=0.95;

pwZSA(N,N,N)=1-pwZSA(T,N,N);
pwZSA(N,N,T)=1-pwZSA(T,N,T);
pwZSA(N,T,N)=1-pwZSA(T,T,N);
pwZSA(N,T,T)=1-pwZSA(T,T,T);



for Z=1:2

    for S=1:2

        for A=1:2

            for W=1:2

                for U=1:2
                  
                   for T=1:2
                   
                      p(Z,S,A,W,U,T)=pwAT(A,T)*pwSWU(S,W,U)*pwZSA(Z,S,A)*pW(W)*pU(U) *pT(T);

                    end
                end

            end

        end

    end

end

sum(sum(sum(sum(sum(sum(p))))))

% P(S)

pS=sum(sum(sum(sum(sum(p(:,2,:,:,:,:))))))

%  P(U|Z) = P(U,Z)/P(Z)

pwUZ=sum(sum(sum(sum(sum(p(2,:,:,:,2,:)))))) / sum(sum(sum(sum(sum(p(2,:,:,:,:,:))))))

% P(U|Z,T) = P(U,Z,T)/P(Z, T)

%pwUZT=sum(sum(sum(sum(sum(p(2,:,:,:,2,2)))))) / sum(sum(sum(sum(sum(p(2,:,:,:,:,2))))))

%P(A|Z,T) = P(A,Z,T)/P(Z, T)
pwAZT=sum(sum(sum(sum(sum(p(2,:,2,:,:,2)))))) / sum(sum(sum(sum(sum(p(2,:,:,:,:,2))))))

% -------------------------------------------------------




% Metody Monte Carlo


K=10000; % jednorazowa porcja taktow
srp_uz=0; % poczatkowy wynik P(A|S)
srp_s=0; % poczatkowy wynik P(A)
srp_uzt=0;
srp_azt=0;

close
hold on

plot([1 1000],[pS pS])
plot([1 1000],[pwUZ pwUZ],'r')
%plot([1 1000],[pwUZT pwUZT],'g')
plot([1 1000],[pwAZT pwAZT],'g')
axis([0 1000 0 0.65]) % zadanie skali rysunku





for j=1:1000

    w=rand(1,K)<pW(T);
    u=rand(1,K)<pU(T);
    
    sNN=rand(1,K)<pwSWU(T,N,N);
    sNT=rand(1,K)<pwSWU(T,N,T);
    sTN=rand(1,K)<pwSWU(T,T,N);
    sTT=rand(1,K)<pwSWU(T,T,T);
    s=(w&u&sTT)|(w&~u&sTN)|(~w&u&sNT)|(~w&~u&sNN);

    
    t=rand(1,K)<pT(T);

    
    aN=rand(1,K)<pwAT(T,N);
    aT=rand(1,K)<pwAT(T,T);
    a=(t&aT)|(~t&aN);

    zNN=rand(1,K)<pwZSA(T,N,N);
    zNT=rand(1,K)<pwZSA(T,N,T);
    zTN=rand(1,K)<pwZSA(T,T,N);
    zTT=rand(1,K)<pwZSA(T,T,T);
    z=(s&a&zTT)|(s&~a&zTN)|(~s&a&zNT)|(~s&~a&zNN);

    
    
    % Obliczenie P(S)
    pa_mc=sum(s)/K;
    sr_s(j)=srp_s+(pa_mc-srp_s)/j;
    srp_s=sr_s(j);
    plot([1:j],sr_s)


    
    % Obliczenie P(U|Z)
    uz=u&z;
    pwas_mc=sum(uz)/sum(z); % obliczenie czestosci dla biezacej porcji taktow
    sr_uz(j)=srp_uz+(pwas_mc-srp_uz)/j; % obliczenie czestosci dla wszystkich dotychczasowych taktow (znany wzor iteracyjny)
    srp_uz=sr_uz(j);
    plot([1:j],sr_uz,'r');

    
    
   % Obliczenie P(U|Z,T)

    uzt=u&z&t;
    zt=z&t;
    pwas_mc=sum(uzt)/sum(zt); % obliczenie czestosci dla biezacej porcji taktow
    sr_uzt(j)=srp_uzt+(pwas_mc-srp_uzt)/j; % obliczenie czestosci dla wszystkich dotychczasowych taktow (znany wzor iteracyjny)
    srp_uzt=sr_uzt(j);
    
   %plot([1:j],sr_uzt,'g');
   
   
   % Obliczenie P(A|Z,T)

    azt=a&z&t;
    zt=z&t;
    pwas_mc=sum(azt)/sum(zt); % obliczenie czestosci dla biezacej porcji taktow
    sr_azt(j)=srp_azt+(pwas_mc-srp_azt)/j; % obliczenie czestosci dla wszystkich dotychczasowych taktow (znany wzor iteracyjny)
    srp_azt=sr_azt(j);
    
   plot([1:j],sr_azt,'g');

      

    pause(0.001)
  

end







