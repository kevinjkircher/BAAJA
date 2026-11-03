function greenhouseGasReport(dCO2,bdCO2,eCO2,beCO2,CH4,bCH4,xCO2,bxCO2,figureNumber,toSave)
% greenhouseGasReport reports greenhouse gas outcomes in the baseline and alternative scenarios.

arguments (Input)
    dCO2 % baseline domestic energy-related CO2 emissions from fossil fuel direct use, Gt
    bdCO2 % domestic energy-related CO2 emissions from fossil fuel direct use under BAAJA, Gt
    eCO2 % baseline domestic energy-related CO2 emissions from fossil fuel electricity, Gt
    beCO2 % domestic energy-related CO2 emissions from fossil fuel electricity under BAAJA, Gt
    CH4 % baseline domestic CH4 emissions from fossil fuel production, Gt
    bCH4 % domestic CH4 emissions from fossil fuel production under BAAJA, Gt
    xCO2 % exported energy-related CO2 emissions, Gt
    bxCO2 % exported energy-related CO2 emissions under BAAJA, Gt
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)

end

% quantiles
q1 = 0.025; % low quantile to report
q2 = 0.975; % high quantile to report

% domestic direct-use CO2
fprintf('-------------------------------- ANNUAL GREENHOUSE GASES --------------------------------\n')
fprintf('Increase in domestic energy-related CO2 emissions from fossil fuel direct use:\n')
fprintf('\tMean = %.3g Gt (%.2g%%).\n',...
    mean(bdCO2) - dCO2, 100*(mean(bdCO2)/dCO2 - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] Gt ([%.2g, %.2g]%%).\n',...
    quantile(bdCO2 - dCO2,q1), quantile(bdCO2 - dCO2,q2), ...
    100*(quantile(bdCO2,q1)/dCO2 - 1), 100*(quantile(bdCO2,q2)/dCO2 - 1))

% domestic electricity CO2
fprintf('Increase in domestic energy-related CO2 emissions from fossil fuel electricity:\n')
fprintf('\tMean = %.3g Gt (%.2g%%).\n',...
    mean(beCO2) - eCO2, 100*(mean(beCO2)/eCO2 - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] Gt ([%.2g, %.2g]%%).\n',...
    quantile(beCO2 - eCO2,q1), quantile(beCO2 - eCO2,q2), ...
    100*(quantile(beCO2,q1)/eCO2 - 1), 100*(quantile(beCO2,q2)/eCO2 - 1))

% domestic CH4
fprintf('Increase in domestic CH4 emissions from fossil fuel production:\n')
fprintf('\tMean = %.3g Gt CO2e at GWP100 (%.2g%%).\n',...
    mean(bCH4) - CH4, 100*(mean(bCH4)/CH4 - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] Gt ([%.2g, %.2g]%%).\n',...
    quantile(bCH4 - CH4,q1), quantile(bCH4 - CH4,q2), ...
    100*(quantile(bCH4,q1)/CH4 - 1), 100*(quantile(bCH4,q2)/CH4 - 1))

% total domestic CO2e
fprintf('Increase in total domestic energy-related CO2e emissions:\n')
fprintf('\tMean = %.3g Gt (%.2g%%).\n',...
    mean(bdCO2 + beCO2 + bCH4) - (dCO2 + eCO2 + CH4), 100*(mean(bdCO2 + beCO2 + bCH4)/(dCO2 + eCO2 + CH4) - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] Gt ([%.2g, %.2g]%%).\n',...
    quantile(bdCO2 + beCO2 + bCH4 - (dCO2 + eCO2 + CH4),q1), quantile(bdCO2 + beCO2 + bCH4 - (dCO2 + eCO2 + CH4),q2), ...
    100*(quantile(bdCO2 + beCO2 + bCH4,q1)/(dCO2 + eCO2 + CH4) - 1), 100*(quantile(bdCO2 + beCO2 + bCH4,q2)/(dCO2 + eCO2 + CH4) - 1))

% export CO2
fprintf('Increase in CO2 emissions associated with fossil fuel exports:\n')
fprintf('\tMean = %.3g Gt (%.2g%%).\n',...
    mean(bxCO2) - xCO2, 100*(mean(bxCO2)/xCO2 - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] Gt ([%.2g, %.2g]%%).\n',...
    quantile(bxCO2 - xCO2,q1), quantile(bxCO2 - xCO2,q2), ...
    100*(quantile(bxCO2,q1)/xCO2 - 1), 100*(quantile(bxCO2,q2)/xCO2 - 1))

% greenhouse gas probabilities
fprintf('Probability that greenhouse gas emissions increase: %.3g%%.\n',...
    100*mean(bdCO2 + beCO2 + bCH4 > dCO2 + eCO2 + CH4))

% greenhouse gas plot
if figureNumber > 0
    figure(figureNumber), clf
    bg = bar([1 2 3 4],[mean(dCO2) mean(bdCO2); [mean(eCO2) mean(beCO2)]; [mean(CH4) mean(bCH4)]; [mean(xCO2) mean(bxCO2)]]); grid on
    x1 = bg(1).XEndPoints; % bar midpoints for first data series
    x2 = bg(2).XEndPoints; % bar midpoints for second data series
    text(x1(1),mean(dCO2)/2,sprintf('%.3g',mean(dCO2)),'color','white','horizontalalignment','center')
    text(x1(2),mean(eCO2)/2,sprintf('%.3g',mean(eCO2)),'color','white','horizontalalignment','center')
    text(x1(3),mean(CH4)/2,sprintf('%.3g',mean(CH4)),'color','white','horizontalalignment','center')
    text(x1(4),mean(xCO2)/2,sprintf('%.2g',mean(xCO2)),'color','white','horizontalalignment','center')
    text(x2(1),mean(bdCO2)/2,sprintf('%.3g',mean(bdCO2)),'color','white','horizontalalignment','center')
    text(x2(2),mean(beCO2)/2,sprintf('%.3g',mean(beCO2)),'color','white','horizontalalignment','center')
    text(x2(3),mean(bCH4)/2,sprintf('%.3g',mean(bCH4)),'color','white','horizontalalignment','center')
    text(x2(4),mean(bxCO2)/2,sprintf('%.2g',mean(bxCO2)),'color','white','horizontalalignment','center')
    eLow = mean([bdCO2, beCO2, bCH4, bxCO2]) - quantile([bdCO2, beCO2, bCH4, bxCO2],q1);
    eHigh = quantile([bdCO2, beCO2, bCH4, bxCO2],q2) - mean([bdCO2, beCO2, bCH4, bxCO2]);
    hold on, er = errorbar(x2(1:4),mean([bdCO2, beCO2, bCH4, bxCO2]),eLow,eHigh);    
    er.Color = 'k';
    er.LineStyle = 'none';
    er.LineWidth = 2;
    xticklabels({'Direct-use CO$_2$','Electricity CO$_2$','CH$_4$ (GWP100)','Export CO$_2$'})
    ylabel({'Annual energy-related', 'greenhouse gas emissions (Gt CO$_{2e}$)'})
    legend('2025 as it was','2025 under BAAJA')
    if toSave
        exportgraphics(gcf,'emissions.png','resolution',600);
    end
end

end

