function [X,Rc,Rfe,Rfp,Jc,Jfe,Jfp,dCO2,eCO2,CH4,xCO2,MV,ML] = ...
    setDerivedParameters(E,C,eta,P,D,lamd,lame,mu,pif,pie,gamc,gamfe,gamfp,deltaV,deltaL)
% setDerivedParameters sets numerical values for parameters derived from the fundamental inputs.

arguments (Input)
    E % total electricity generation, EJ
    C % clean electricity generation, EJ
    eta % fleet-average fossil fuel electricity generation efficiency
    P % total fossil fuel production, EJ
    D % total domestic fossil fuel direct use, EJ
    lamd % carbon dioxide intensity of fossil fuel direct use, Gt/EJ
    lame % carbon dioxide intensity of fossil fuel electricity, Gt/EJ
    mu % methane intensity at GWP100 of fossil fuel production, (Gt CO2e)/EJ
    pif % average fossil fuel price, billion $/EJ
    pie % average wholesale electricity price, billion $/EJ
    gamc % job intensity of clean electricity generation, thousand jobs/EJ
    gamfe % job intensity of fossil fueled electricity generation, thousand jobs/EJ
    gamfp % job intensity of fossil fuel production, thousand jobs/EJ    
    deltaV % mortality intensity of fossil fuel air pollution from Vohra et al., thousand lives/EJ    
    deltaL % mortality intensity of fossil fuel air pollution from Lelieveld et al., thousand lives/EJ    
end

arguments (Output) % all scalars
    X % fossil fuel exports, EJ
    Rc % clean electricity revenue, billion $
    Rfe % fossil electricity revenue, billion $
    Rfp % fossil fuel production revenue, billion $
    Jc % clean electricity jobs, thousands
    Jfe % fossil electricity jobs, thousands
    Jfp % fossil fuel production jobs, thousands
    dCO2 % domestic energy-related CO2 emissions from direct use, Gt
    eCO2 % domestic energy-related CO2 emissions from electricity, Gt
    CH4 % domestic CH4 emissions from fossil fuel production, Gt
    xCO2 % exported energy-related CO2 emissions, Gt
    MV % American mortality attributable to fossil fuel air pollution (Vohra et al.), thousand lives
    ML % American mortality attributable to fossil fuel air pollution (Lelieveld et al.), thousand lives
end

X = P - D - (E - C)/eta; % fossil fuel exports, EJ
Rc = pie*C; % clean electricity revenue, billion $
Rfe = pie*(E - C); % fossil electricity revenue, billion $
Rfp = pif*P; % fossil fuel production revenue, billion $
Jc = gamc*C; % clean electricity jobs, thousands
Jfe = gamfe*(E - C); % fossil electricity jobs, thousands
Jfp = gamfp*P; % fossil fuel production jobs, thousands
dCO2 = lamd*D; % CO2 emissions from domestic fossil fuel direct use, Gt
eCO2 = lame*(E - C)/eta; % CO2 emissions from domestic fossil fuel electricity, Gt
CH4 = mu*P; % CO2e emissions from methane from fossil fuel production at GWP100, Gt
xCO2 = lamd*X; % CO2 emissions from fossil fuel exports, Gt
MV = deltaV*(D + (E - C)/eta); % mortality attributable to US fossil fuel air pollution based on Vohra et al., thousand deaths
ML = deltaL*(D + (E - C)/eta); % mortality attributable to fossil fuel air pollution based on Lelieveld et al., thousand deaths

end






