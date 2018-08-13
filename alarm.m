% Metody teoretyczne



clear

N=1; T=2; % falsz, prawda



% zadawanie wartosci prawdopodobienstw



% wlamanie



pw(T)=0.001;

pw(N)=1-pw(T);



% uderzenie pioruna



pu(T)=0.002;

pu(N)=1-pu(T);



% alarm przy warunku wlamania i uderzenia pioruna



pwawu(T,N,N)=0.008;

pwawu(T,N,T)=0.2;

pwawu(T,T,N)=0.9;

pwawu(T,T,T)=0.95;

pwawu(N,N,N)=1-pwawu(T,N,N);

pwawu(N,N,T)=1-pwawu(T,N,T);

pwawu(N,T,N)=1-pwawu(T,T,N);

pwawu(N,T,T)=1-pwawu(T,T,T);



% telefon od Stefana przy warunku alarm



pwsa(T,N)=0.1;

pwsa(T,T)=0.9;

pwsa(N,N)=1-pwsa(T,N);

pwsa(N,T)=1-pwsa(T,T);



% telefon od Barbary przy warunku alarm



pwba(T,N)=0.02;

pwba(T,T)=0.65;

pwba(N,N)=1-pwba(T,N);

pwba(N,T)=1-pwba(T,T);



% tablica prawdopodobienstw lacznych



for A=1:2

    for B=1:2

        for S=1:2

            for U=1:2

                for W=1:2

                    p(A,B,S,U,W)=pwba(B,A)*pwsa(S,A)*pwawu(A,W,U)*pw(W)*pu(U);

                end

            end

        end

    end

end



% Sprawdzenie czy suma wszystkich prawdopodobienstw jest rowna 1



sum(sum(sum(sum(sum(p)))))



% Obliczenie P(A|B,S,U,W)=P(A,B,S,U,W)/P(B,S,U,W)



pwabsuw=p(2,2,2,2,2)/sum(p(:,2,2,2,2)) 

pwnabsuw=p(1,2,2,2,2)/sum(p(:,2,2,2,2))



% Obliczenie P(A)



pa=sum(sum(sum(sum(p(2,:,:,:,:)))))

pna=sum(sum(sum(sum(p(1,:,:,:,:)))))



% Obliczenie P(A|S)=P(A,S)/P(S)



pwas=sum(sum(sum(p(2,:,2,:,:))))/sum(sum(sum(sum(p(:,:,2,:,:)))))

pwnas=sum(sum(sum(p(1,:,2,:,:))))/sum(sum(sum(sum(p(:,:,2,:,:)))))



% -------------------------------------------------------

% Metody Monte Carlo



K=10000; % jednorazowa porcja taktow

srp_as=0; % poczatkowy wynik P(A|S)

srp_a=0; % poczatkowy wynik P(A)

close

hold on

plot([1 1000],[pwas pwas])

plot([1 1000],[pa pa],'r')

axis([0 1000 0 0.1]) % zadanie skali rysunku



% Obliczenie P(A|B,S,U,W)=P(A,B,S,U,W)/P(B,S,U,W)



for j=1:1000  

    w=rand(1,K)<pw(T);

    u=rand(1,K)<pu(T);

    aNN=rand(1,K)<pwawu(T,N,N);

    aNT=rand(1,K)<pwawu(T,N,T);

    aTN=rand(1,K)<pwawu(T,T,N);

    aTT=rand(1,K)<pwawu(T,T,T);

    a=(w&u&aTT)|(w&~u&aTN)|(~w&u&aNT)|(~w&~u&aNN);

    sN=rand(1,K)<pwsa(T,N);

    sT=rand(1,K)<pwsa(T,T);

    s=(a&sT)|(~a&sN);



    bN=rand(1,K)<pwba(T,N);

    bT=rand(1,K)<pwba(T,T);

    b=(a&bT)|(~a&bN);


  

% Obliczenie P(A|S)



    as=a&s;

    pwas_mc=sum(as)/sum(s); % obliczenie czestosci dla biezacej porcji taktow

    sr_as(j)=srp_as+(pwas_mc-srp_as)/j; % obliczenie czestosci dla wszystkich dotychczasowych taktow (znany wzor iteracyjny)

    srp_as=sr_as(j);

    plot([1:j],sr_as,'b');

      

% Obliczenie P(A)



    pa_mc=sum(a)/K;

    sr_a(j)=srp_a+(pa_mc-srp_a)/j;

    srp_a=sr_a(j);

    plot([1:j],sr_a,'r')



    pause(0.001)

end









