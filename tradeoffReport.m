function tradeoffReport(Rc,bRc,MV,bMV,ML,bML,C,bC,DCO2,bDCO2,CH4,bCH4)
% tradeoffReport reports tradeoffs in the baseline and alternative scenarios.

arguments (Input)
    Rc % baseline clean electricity revenue, billion $
    bRc % BAAJA clean electricity revenue under BAAJA, billion $
    MV % baseline American mortality attributable to fossil fuel air pollution (Vohra et al.), thousand lives
    bMV % BAAJA American mortality attributable to fossil fuel air pollution (Vohra et al.) under BAAJA, thousand lives
    ML % baseline American mortality attributable to fossil fuel air pollution (Vohra et al.), thousand lives
    bML % BAAJA American mortality attributable to fossil fuel air pollution (Vohra et al.), thousand lives
    C % baseline clean electricity generation, EJ
    bC % BAAJA clean electricity generation under BAAJA, EJ
    DCO2 % baseline domestic energy-related CO2 emissions, Gt
    bDCO2 % BAAJA domestic energy-related CO2 emissions under BAAJA, Gt
    CH4 % baseline domestic CH4 emissions from fossil fuel production, Gt
    bCH4 % BAAJA domestic CH4 emissions from fossil fuel production under BAAJA, Gt
end

arguments (Output)

end

% clean electricity revenue vs. mortality from fossil fuel air pollution
VSL = 11.85; % EPA value of a statistical life, million $/life
fprintf('-------------------------------- TRADEOFFS --------------------------------\n')
fprintf('Mean increase in clean electricity revenue per unit mean increase in mortality (Vohra et al.): %.3g million $/life.\n',...
    mean(bRc - Rc)/mean(bMV - MV))
fprintf('\tEquivalent to %.3g%% of the EPA value of a statistical life.\n',...
    100*mean(bRc - Rc)/mean(bMV - MV)/VSL)
fprintf('Mean increase in clean electricity revenue per unit mean increase in mortality (Lelieveld et al.): %.3g million $/life.\n',...
    mean(bRc - Rc)/mean(bML - ML))
fprintf('\tEquivalent to %.3g%% of the EPA value of a statistical life.\n',...
    100*mean(bRc - Rc)/mean(bML - ML)/VSL)

% clean electricity generation vs. greenhouse gases from fossil fuels
NGCC = 0.45/3.6; % CO2e intensity of natural gas combined-cycle electricity, Gt/EJ
coal = 1/3.6; % CO2e intensity of coal-fired electricity, Gt/EJ
fprintf('Mean increase in domestic greenhouse gas emissions per unit mean increase in clean electricity generation: %.3g Gt/EJ (%.3g kg/kWh).\n',...
    mean(bDCO2 + bCH4 - DCO2 - CH4)/mean(bC - C), mean(bDCO2 + bCH4 - DCO2 - CH4)/mean(bC - C)*3.6) % 10^12 kg/Gt, 3.6*10^-12 EJ/kWh
fprintf('\tEquivalent to %.3g%% of the greenhouse gas intensity of electricity from a typical natural gas power plant or %.3g%% from coal.\n',...
    100*mean(bDCO2 + bCH4 - DCO2 - CH4)/mean(bC - C)/NGCC, ...
    100*mean(bDCO2 + bCH4 - DCO2 - CH4)/mean(bC - C)/coal)

end