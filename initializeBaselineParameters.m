function [E,C,eta,P,D,lamd,lame,mu,pif,pie,gamc,gamfe,gamfp,deltaV,deltaL] = initializeBaselineParameters(toReport)
% initializeBaselineParameters initializes model parameters for the `2025 as it was' baseline.
%
% Data sources:
% [gen] electricity generation by source: https://www.eia.gov/totalenergy/data/monthly/pdf/sec7_5.pdf
% [coalUse] coal consumption: https://www.eia.gov/totalenergy/data/monthly/pdf/sec6_4.pdf
% [oilUse] oil consumption: https://www.eia.gov/totalenergy/data/monthly/pdf/sec3_23.pdf
% [gasUse] gas consumption: https://www.eia.gov/totalenergy/data/monthly/pdf/sec4_6.pdf
% [heat] coal, oil, gas heat content: https://www.eia.gov/totalenergy/data/monthly/pdf/mer_A_FULL.pdf
% [prim] primary energy overview: https://www.eia.gov/totalenergy/data/monthly/pdf/sec12_6.pdf
% [co2] energy-related CO2 emissions: https://www.eia.gov/environment/emissions/carbon/
% [ch4] CH4 emissions from oil and gas: https://www.sciencedirect.com/science/article/pii/S030142152500254X
% [vohra] Vohra et al. air pollution mortality: https://discovery.ucl.ac.uk/id/eprint/10119672/7/Marais_Vohra-et-al-2021-ER-proof.pdf
% [lelieveld] Lelieveld et al. air pollution mortality: https://www.bmj.com/content/bmj/383/bmj-2023-077784.full.pdf
% [jobs] energy jobs: https://www.energy.gov/sites/default/files/2025-08/National%20USEER_08282025.pdf
% [elecPrice] wholesale electricity prices: https://www.eia.gov/outlooks/steo/report/elec_coal_renew.php
% [prod] coal, oil, gas production: https://www.eia.gov/totalenergy/data/monthly/pdf/sec12_7.pdf
% [coalPrice] coal price: https://www.eia.gov/coal/data/browser/#/topic/23
% [oilPrice] oil price: https://www.eia.gov/petroleum/prices/table.php?show_by=12_series&period=A&table_key=PET_PRI_SPT_S1_A
% [gasPrice] natural gas price: https://www.eia.gov/dnav/ng/hist/rngwhhdA.htm
% [ngplPrice] NGPL price: https://www.eia.gov/dnav/ng/hist/ngm_epg0_plc_nus_dmmbtuA.htm

arguments (Input)
    toReport % binary indicator of whether to issue text reports
end

arguments (Output) % all scalars
    E % total electricity generation, EJ
    C % clean electricity generation, EJ
    eta % fleet-average fossil fuel electricity generation efficiency, dimensionless
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

% 2025 electricity generation [gen]
coal = 737.151; % coal, TWh
oil = 19.206 + 10.697; % petroleum + other fossil gases, TWh
gas = 1807.338; % natural gas, TWh
nuclear = 784.781; % nuclear, TWh
hydro = 247.023; % hydro (does not include losses from pumped hydro), TWh
biomass = 31.809 + 14.378; % wood + waste, TWh
geothermal = 15.669; % geothermal, TWh
solar = 295.671; % solar, TWh
wind = 464.391; % wind, TWh
C = (nuclear + hydro + biomass + geothermal + solar + wind)/277.78; % 1 EJ = 277.78 TWh
E = (coal + oil + gas + nuclear + hydro + biomass + geothermal + solar + wind)/277.78;
if toReport
    fprintf('Clean fraction of 2025 total electricity generation: %.3g%%.\n',100*C/E)
    fprintf('\tNuclear: %.3g%%.\n',100*nuclear/E/277.78)
    fprintf('\tHydro: %.3g%%.\n',100*hydro/E/277.78)
    fprintf('\tBiomass: %.3g%%.\n',100*biomass/E/277.78)
    fprintf('\tGeothermal: %.3g%%.\n',100*geothermal/E/277.78)
    fprintf('\tWind: %.3g%%.\n',100*wind/E/277.78)
    fprintf('\tSolar: %.3g%%.\n',100*solar/E/277.78)
    fprintf('Wind, solar, and geothermal were %.3g%% of 2025 clean electricity generation.\n',...)
        100*(solar + wind + geothermal)/(C*277.8))
    fprintf('Increasing wind, solar, and geothermal generation by %.3g%% would increase total clean generation by 10%%.\n',...
        100*0.1*C*277.78/(solar + wind + geothermal))
end

% fossil generator fleet efficiency
coalHeatContent = 18.774; % heat content of coal used for electricity, billion Btu per thousand short tons [heat]
coalIn = 416995; % electricity coal consumption, thousand short tons [coalUse]
coalIn = coalIn*coalHeatContent/947817; % conversion to EJ; 1 EJ = 947817 billion Btu
oilHeatContent = 5.9; % billion Btu per thousand barrels [heat]
oilIn = 93*365; % electricity oil consumption, thousand barrels [oilUse]
oilIn = oilIn*oilHeatContent/947817; % converstion to EJ
gasHeatContent = 1034; % billion Btu per billion cubic feet [heat]
gasIn = 13054; % electricity gas consumption, billion cubic feet [gasUse]
gasIn = gasIn*gasHeatContent/947817; % converstion to EJ
eta = (E-C)/(coalIn + oilIn + gasIn); % fleet-average fossil fuel electricity generation efficiency

% fossil fuels
P = 1.055*89.732; % total fossil fuel production, EJ [prim]
D = 1.055*79.393 - (E - C)/eta; % domestic fossil fuel direct use, EJ [prim]
if toReport
fprintf('Modeling scope (fossil fuels and electricity, biomass excluded) covers %.3g%% of US primary energy.\n',...
    100*(P + C)/(P + C + 5.2*1.055))
end

% greenhouse gas emission intensities
lame = (0.058/0.04)/((E - C)/eta); % CO2 intensity of fossil fuel electricity generation, Gt/EJ [co2]
lamd = (4.904 - 0.058/0.04)/D; % CO2 intensity of fossil fuel direct use, Gt/EJ [co2]
mu = 0.9468/(1.055*86.8); % CO2e intensity of US fossil fuel methane at GWP100, Gt/EJ [ch4]

% energy prices
pie = 13.06; % wholesale electricity price, billion $/EJ [elecPrice]
coalProduction = 10.876; % 2025 coal production, quad [prod]
coalProduction = coalProduction/coalHeatContent; % quad -> billion short tons
oilProduction = 28.369; % 2025 oil + NGPL production, quad [prod]
oilProduction = oilProduction/oilHeatContent; % quad -> billion barrels
ngplProduction = 9.785; % 2025 oil + NGPL production, quad [prod]
gasProduction = 40.702; % 2025 gas production, quad [prod]
coalPrice = 46.45; % 2025 coal price, $/short ton = billion $/billion short tons [coalPrice]
oilPrice = 69.14; % 2025 Brent crude oil price, $/barrel = billion $/billion barrels [oilPrice]
ngplPrice = 6.75; % 2025 NGPL price, $/million Btu = billion $/quad [gasPrice]
gasPrice = 3.52; % 2025 Henry Hub natural gas price, $/million Btu = billion $/quad [ngplPrice]
pif = (coalProduction*coalPrice ...
    + oilProduction*oilPrice ...
    + ngplProduction*ngplPrice ...
    + gasProduction*gasPrice)/P; % fossil fuel price, billion $/EJ

% job intensities
gamc = (57900 + 70200 + 370600 + 133000)/1000/C; % clean electricity job intensity, nuclear + hydro + geothermal + solar + wind, thousand jobs/EJ [jobs]
gamfe = (60400 + 12500 + 127800)/1000/(E - C); % fossil electricity job intensity, coal + oil + gas, thousand jobs/EJ [jobs]
gamfp = (64400 + 548500 + 252600)/1000/P; % fossil fuel production job intensity, coal + oil + gas, thousand jobs/EJ [jobs]

% mortality intensities of fossil fuel air pollution
deltaV = 355/81.6; % Vohra et al. mortality intensity of US fossil fuel use in 2012, thousand deaths/EJ [vohra]
deltaL = 84.379/84.9; % Lelieveld et al. mortality intensity of US fossil fuel use in 2019, thousand deaths/EJ [lelieveld]

end






