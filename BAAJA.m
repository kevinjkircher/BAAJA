%% introduction
% This script evaluates the potential economic and environmental impacts of
% the Bipartisan American Affordability and Jobs Act draft text that was
% published on September 30, 2026. This script generates the figures and
% numerical estimates reported in the write-up at kevinjkircher.com/baaja.
%
% Kevin J. Kircher, Purdue University, kevinjkircher.com

%% baseline: 2025 as it was
% fundamental inputs
toReport = 1; % indicator of whether to issue text reports
[...
    E, ... % total electricity generation, EJ
    C, ... % clean electricity generation, EJ
    eta, ... % fleet-average fossil fuel electricity generation efficiency, dimensionless
    P, ... % fossil fuel production, EJ
    D, ... % domestic fossil fuel direct use, EJ
    lamd, ... % carbon dioxide intensity of fossil fuel direct use, Gt/EJ
    lame, ... % carbon dioxide intensity of fossil fuel electricity, Gt/EJ
    mu, ... % methane intensity at GWP100 of fossil fuel production, CO2e Gt/EJ
    pif, ... % average fossil fuel price, billion $/EJ
    pie, ... % average wholesale electricity price, billion $/EJ
    gamc, ... % job intensity of clean electricity generation, thousand jobs/EJ
    gamfe, ... % job intensity of fossil fueled electricity generation, thousand jobs/EJ
    gamfp, ... % job intensity of fossil fuel production, thousand jobs/EJ    
    deltaV, ... % mortality intensity attributable to fossil fuel air pollution from Vohra et al., thousand lives/EJ    
    deltaL, ... % mortality intensity attributable to fossil fuel air pollution from Lelieveld et al., thousand lives/EJ    
    ] = initializeBaselineParameters(toReport);

% derived parameter values
[...
    X, ... % fossil fuel exports, EJ
    Rc, ... % clean electricity revenue, billion $
    Rfe, ... % fossil electricity revenue, billion $
    Rfp, ... % fossil fuel production revenue, billion $
    Jc, ... % clean electricity jobs, thousands
    Jfe, ... % fossil fueled electricity jobs, thousands
    Jfp, ... % fossil fuel production jobs, thousands
    dCO2, ... % CO2 emissions from domestic fossil fuel direct use, Gt
    eCO2, ... % CO2 emissions from domestic fossil fuel electricity, Gt
    CH4, ... % CO2e emissions from methane from fossil fuel production at GWP100, Gt CO2e
    xCO2, ... % CO2 emissions associated with fossil fuel exports, Gt
    MV, ... % mortality from US fossil fuel use based on Vohra et al., thousand lives
    ML ... % mortality from US fossil fuel use based on Lelieveld et al., thousand lives
    ] = setDerivedParameters(E,C,eta,P,D,lamd,lame,mu,pif,pie,gamc,gamfe,gamfp,deltaV,deltaL);

%% alternative: 2025 as if BAAJA had been in full effect
% regression relating domestic direct fossil fuel use to total fossil fuel production
toSave = 0; % indicator of whether to save figures
figNum = 1; % number of first figure to plot into (0 -> no plots)
[...
    b, ... % parameter estimates from least-squares fit, 2x1, dimensionless
    eSig, ... % standard error from least-squares fit, dimensionless
    ] = fitDirectUseParameters(toReport,figNum,toSave);

% lower and upper bounds of relative change scalars
acLow = 0.97; % low value of clean electricity relative change scalar
acHigh = 1.1; % high value of clean electricity relative change scalar
aeLow = 1; % low value of electricity demand relative change scalar
aeHigh = 1.05; % high value of electricity demand relative change scalar
apLow = 1.02; % low value of fossil fuel production relative change scalar
apHigh = 1.08; % high value of fossil fuel production relative change scalar

% Monte Carlo simulation of energy flows
N = 1e7; % number of independent random samples
[sE,sC,sP,sD] = stochasticSimulation(acLow,acHigh,aeLow,aeHigh,apLow,apHigh,b,eSig,E,C,P,D,N,toReport);

% derived parameter values
[sX,sRc,sRfe,sRfp,sJc,sJfe,sJfp,sdCO2,seCO2,sCH4,sxCO2,sMV,sML] = ...
    setDerivedParameters(sE,sC,eta,sP,sD,lamd,lame,mu,pif,pie,gamc,gamfe,gamfp,deltaV,deltaL);

% text reports and bar graphs
if figNum > 0, figNum = figNum + 1; end
if toReport
    energyReport(E,sE,C,sC,P,sP,D,sD,X,sX,figNum,toSave)
    if figNum > 0, figNum = figNum + 1; end
    revenueReport(Rc,sRc,Rfe,sRfe,Rfp,sRfp,figNum,toSave)
    if figNum > 0, figNum = figNum + 1; end
    jobReport(Jc,sJc,Jfe,sJfe,Jfp,sJfp,figNum,toSave)
    if figNum > 0, figNum = figNum + 1; end
    greenhouseGasReport(dCO2,sdCO2,eCO2,seCO2,CH4,sCH4,xCO2,sxCO2,figNum,toSave)
    if figNum > 0, figNum = figNum + 1; end
    mortalityReport(MV,sMV,ML,sML,figNum,toSave)
    if figNum > 0, figNum = figNum + 1; end
    tradeoffReport(Rc,sRc,MV,sMV,ML,sML,C,sC,dCO2,sdCO2,CH4,sCH4)
end

%% sensitivity of tradeoff parameters
% deterministic simulation of energy flows, sweeping over fixed ranges
n = 1e3; % number of data points to sweep
[ac,ae,ap,ad,dE,dC,dP,dD] = deterministicSimulation(acLow,acHigh,aeLow,aeHigh,apLow,apHigh,b,E,C,P,D,n);

% derived parameters
[~,dRc,~,~,~,~,~,ddCO2,deCO2,dCH4,~,~,dML] = ...
    setDerivedParameters(dE,dC,eta,dP,dD,lamd,lame,mu,pif,pie,gamc,gamfe,gamfp,deltaV,deltaL);

% tradeoff plots
if figNum > 0
    tradeoffPlots(ac,ap,Rc,dRc,ML,dML,C,dC,dCO2,ddCO2,eCO2,deCO2,CH4,dCH4,figNum,toSave)
end









