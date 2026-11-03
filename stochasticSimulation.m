function [bE,bC,bP,bD] = stochasticSimulation(acLow,acHigh,aeLow,aeHigh,apLow,apHigh,b,eSig,E,C,P,D,N,toReport)
% stochasticSimulation uses Monte Carlo simulation to model energy flows in
% an alternate-history 2025 with BAAJA in full effect.

arguments (Input)
    acLow % low value of clean electricity relative change scalar
    acHigh % high value of clean electricity relative change scalar
    aeLow % low value of electricity demand relative change scalar
    aeHigh % high value of electricity demand relative change scalar
    apLow % low value of fossil fuel production relative change scalar (indicator of BAAJA overall effectiveness)
    apHigh % high value of fossil fuel production relative change scalar (indicator of BAAJA overall effectiveness)
    b % parameter estimates from least-squares fit
    eSig % standard error from least-squares fit, EJ
    E % baseline total electricity generation, EJ
    C % baseline clean electricity generation, EJ
    P % baseline total fossil fuel production, EJ
    D % baseline total domestic fossil fuel direct use, EJ
    N % number of Monte Carlo samples
    toReport % binary indicator of whether to issue text reports
end

arguments (Output)
    bE % total electricity generation under BAAJA, EJ
    bC % clean electricity generation under BAAJA, EJ
    bP % fossil fuel production under BAAJA, EJ
    bD % domestic fossil fuel direct use under BAAJA, EJ
end

% random number generation of relative change scalars
ac = trirnd(acLow,acHigh,N,1); % clean electricity
ae = aeLow + (aeHigh - aeLow)/(acHigh - acLow)*(ac - acLow) + 0.01*trirnd(-1,1,N,1); % electricity generation
ap = trirnd(apLow,apHigh,N,1); % fossil fuel production
ad = 1 + b(1) + b(2)*(ap - 1) + eSig*randn(N,1); % domestic fossil fuel direct use

% report
if toReport
    fprintf('Mean ac = %.4g, ae = %.4g, ap = %.4g, ad = %.4g.\n',...
        mean(ac),mean(ae),mean(ap),mean(ad))
    fprintf('Probability that ac < 1: %.3g%%.\n',100*mean(ac < 1))
    fprintf('Probability that ae < 1: %.3g%%.\n',100*mean(ae < 1))
end    

% simulation
bE = ae*E; % total electricity generation, EJ
bC = ac*C; % clean electricity generation, EJ
bP = ap*P; % fossil fuel production, EJ
bD = ad*D; % domestic fossil fuel direct use, EJ

end