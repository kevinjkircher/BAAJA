function [ac,ae,ap,ad,bE,bC,bP,bD] = deterministicSimulation(acLow,acHigh,aeLow,aeHigh,apLow,apHigh,b,E,C,P,D,n)
% deterministicSimulation uses deterministic simulation to model energy 
% flows in an alternate-history 2025 with BAAJA in full effect.

arguments (Input)
    acLow % low value of clean electricity relative change scalar
    acHigh % high value of clean electricity relative change scalar
    aeLow % low value of electricity demand relative change scalar
    aeHigh % high value of electricity demand relative change scalar
    apLow % low value of fossil fuel production relative change scalar (indicator of BAAJA overall effectiveness)
    apHigh % high value of fossil fuel production relative change scalar (indicator of BAAJA overall effectiveness)
    b % parameter estimates from least-squares fit
    E % baseline total electricity generation, EJ
    C % baseline clean electricity generation, EJ
    P % baseline total fossil fuel production, EJ
    D % baseline total domestic fossil fuel direct use, EJ
    n; % number of data points to sweep
end

arguments (Output)
    ac % clean electricity generation relative change scalar
    ae % total electricity generation  relative change scalar
    ap % fossil fuel production relative change scalar
    ad % domestic fossil fuel direct use relative change scalar
    bE % total electricity generation under BAAJA, EJ
    bC % clean electricity generation under BAAJA, EJ
    bP % fossil fuel production under BAAJA, EJ
    bD % domestic fossil fuel direct use under BAAJA, EJ
end

% relative change scalars
ac = linspace(acLow,acHigh,n)'; % clean electricity generation
ae = aeLow + (aeHigh - aeLow)/(acHigh - acLow)*(ac - acLow); % total electricity generation
ap = [apLow (apLow + apHigh)/2 apHigh]; % fossil fuel production
ad = 1 + b(1) + b(2)*(ap - 1); % domestic fossil fuel direct use

% simulation
bE = ae*E; % total electricity generation, EJ
bC = ac*C; % clean electricity generation, EJ
bP = ap*P; % fossil fuel production, EJ
bD = ad*D; % domestic fossil fuel direct use, EJ

end