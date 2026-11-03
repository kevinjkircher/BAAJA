function tradeoffPlots(ac,ap,Rc,bRc,ML,bML,C,bC,dCO2,bdCO2,eCO2,beCO2,CH4,bCH4,figureNumber,toSave)
% tradeoffPlots plots tradeoff curves in the deterministic simulation.

arguments (Input)
    ac % clean electricity relative change scalar
    ap % fossil fuel production relative change scalar (indicator of BAAJA overall effectiveness)
    Rc % baseline clean electricity revenue, billion $
    bRc % clean electricity revenue under BAAJA, billion $
    ML % baseline American mortality attributable to fossil fuel air pollution (Lelieveld et al.), thousand lives
    bML % American mortality attributable to fossil fuel air pollution (Lelieveld et al.), thousand lives
    C % baseline clean electricity generation, EJ
    bC % clean electricity generation under BAAJA, EJ
    dCO2 % baseline domestic energy-related CO2 emissions from fossil fuel direct use, Gt
    bdCO2 % domestic energy-related CO2 emissions from fossil fuel direct use under BAAJA, Gt
    eCO2 % baseline domestic energy-related CO2 emissions from fossil fuel electricity, Gt
    beCO2 % domestic energy-related CO2 emissions from fossil fuel electricity under BAAJA, Gt
    CH4 % baseline domestic CH4 emissions from fossil fuel production, Gt
    bCH4 % domestic CH4 emissions from fossil fuel production under BAAJA, Gt
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)

end

% clean electricity revenue per life plot, Lelieveld et al. mortality intensity
purple = [0.4940, 0.1840, 0.5560]; % color spec
vEPA = 11.85; % EPA value of a statistical life, million $/life
v = (bRc - Rc)./(bML - mean(ML)); % implied value of a statistical life, million $/life
iStar = find(max(v,[],2) >= vEPA,1,'first'); % index of first rise above EPA VSL
figure(figureNumber), clf
plot(100*(ac - 1),v), grid on
xline(100*(ac(iStar) - 1),'--','linewidth',2,'color',purple)
yline(vEPA,'--','linewidth',2,'color',purple)
xlim([1,100*(max(ac) - 1)])
ylim([min(min(ylim),0),max(ylim)])
text(min(xlim),vEPA,['EPA recommendation $\approx$ \$', sprintf('%.3g million',vEPA)],'color',purple,...
    'horizontalalignment','left','verticalalignment','bottom')
text(100*(ac(iStar) - 1),mean(ylim),[sprintf('%.2g',100*(ac(iStar) - 1)),'\%'],'color',purple)
r = rectangle('Position',[100*(ac(iStar) - 1),vEPA,100*(max(ac) - ac(iStar)),max(ylim) - vEPA]);
r.FaceColor = purple;
r.FaceAlpha = 0.1;
r.EdgeColor = 'none';
xlabel('Percent increase in clean electricity generation')
ylabel({'Implied value of a statistical life', '(\$ millions)'})
legend([sprintf('%.3g',100*(ap(1) - 1)),'\% increase in fossil fuel production'],...
    [sprintf('%.3g',100*(ap(2) - 1)),'\%'],[sprintf('%.3g',100*(ap(3) - 1)),'\%'],...
    'location','northwest')
if toSave
    exportgraphics(gcf,'valueOfLife.png','resolution',600);
end

% CO2e emissions per clean electricity plot
gas = 0.45/3.6; % CO2e intensity of natural gas combined-cycle electricity, Gt/EJ
c = (bdCO2 + beCO2 + bCH4 - dCO2 - eCO2 - CH4)./(bC - C)*3.6; % implied CO2e intensity, Gt/EJ
iStar = find(ac >= 1.01 & min(c,[],2) <= gas*3.6,1,'first'); % index of first drop below gas CO2e intensity
figure(figureNumber + 1), clf
plot(100*(ac - 1),c), grid on % kg/kWh
xlim([1,100*(max(ac) - 1)])
xline(100*(ac(iStar) - 1),'--','linewidth',2,'color',purple)
ylim([min(min(ylim),0),5])
yline(gas*3.6,'--','linewidth',2,'color',purple)
text(min(xlim),gas*3.6,['Natural gas $\approx$ ',sprintf('%.3g kg/kWh',gas*3.6)],'color',purple,...
    'horizontalalignment','left','verticalalignment','top')
text(100*(ac(iStar) - 1),mean(ylim),[sprintf('%.2g',100*(ac(iStar) - 1)),'\%'],'color',purple)
r = rectangle('Position',[100*(ac(iStar) - 1),0,100*(max(ac) - ac(iStar)),gas*3.6]);
r.FaceColor = purple;
r.FaceAlpha = 0.1;
r.EdgeColor = 'none';
xlabel('Percent increase in clean electricity generation')
ylabel({'Implied CO$_{2e}$ intensity of new','clean electricity generation (kg/kWh)'})
leg = legend([sprintf('%.3g',100*(ap(1) - 1)),'\%'],...
    [sprintf('%.3g',100*(ap(2) - 1)),'\%'],...
    [sprintf('%.3g',100*(ap(3) - 1)),'\% increase in fossil fuel production'],...
    'location','northeast');
leg.Direction = 'reverse';
if toSave
    exportgraphics(gcf,'CO2eIntensity.png','resolution',600);
end

end