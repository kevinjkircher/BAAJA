function revenueReport(Rc,bRc,Rfe,bRfe,Rfp,bRfp,figureNumber,toSave)
% revenueReport reports revenue outcomes in the baseline and alternative scenarios.

arguments (Input)
    Rc % baseline clean electricity revenue, billion $
    bRc % clean electricity revenue under BAAJA, billion $
    Rfe % baseline fossil electricity revenue, billion $
    bRfe % fossil electricity revenue under BAAJA, billion $
    Rfp % baseline fossil fuel production revenue, billion $
    bRfp % fossil fuel production revenue under BAAJA, billion $
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)

end

% quantiles
q1 = 0.025; % low quantile to report
q2 = 0.975; % high quantile to report

% clean electricity
fprintf('-------------------------------- ANNUAL REVENUE --------------------------------\n')
fprintf('Increase in clean electricity revenue:\n')
fprintf('\tMean = $%.3g billion (%.2g%%).\n',...
    mean(bRc) - Rc, 100*(mean(bRc)/Rc - 1))
fprintf('\t95%% confidence interval = $[%.3g, %.3g] billion ([%.2g, %.2g]%%).\n',...
    quantile(bRc - Rc,q1), quantile(bRc - Rc,q2), ...
    100*(quantile(bRc,q1)/Rc - 1), 100*(quantile(bRc,q2)/Rc - 1))

% fossil fuel electricity
fprintf('Increase in fossil fuel electricity revenue:\n')
fprintf('\tMean = $%.3g billion (%.2g%%).\n',...
    mean(bRfe) - Rfe, 100*(mean(bRfe)/Rfe - 1))
fprintf('\t95%% confidence interval = $[%.3g, %.3g] billion ([%.2g, %.2g]%%).\n',...
    quantile(bRfe - Rfe,q1), quantile(bRfe - Rfe,q2), ...
    100*(quantile(bRfe,q1)/Rfe - 1), 100*(quantile(bRfe,q2)/Rfe - 1))

% fossil fuel production
fprintf('Increase in fossil fuel production revenue:\n')
fprintf('\tMean = $%.3g billion (%.2g%%).\n',...
    mean(bRfp) - Rfp, 100*(mean(bRfp)/Rfp - 1))
fprintf('\t95%% confidence interval = $[%.3g, %.3g] billion ([%.2g, %.2g]%%).\n',...
    quantile(bRfp - Rfp,q1), quantile(bRfp - Rfp,q2), ...
    100*(quantile(bRfp,q1)/Rfp - 1), 100*(quantile(bRfp,q2)/Rfp - 1))

% total fossil fuel
fprintf('Increase in total fossil fuel revenue:\n')
fprintf('\tMean = $%.3g billion (%.2g%%).\n',...
    mean(bRfp + bRfe) - Rfp - Rfe, 100*(mean(bRfp + bRfe)/(Rfp + Rfe) - 1))
fprintf('\t95%% confidence interval = $[%.3g, %.3g] billion ([%.2g, %.2g]%%).\n',...
    quantile(bRfp + bRfe - Rfp - Rfe,q1), quantile(bRfp + bRfe - Rfp - Rfe,q2), ...
    100*(quantile(bRfp + bRfe,q1)/(Rfp + Rfe) - 1), 100*(quantile(bRfp + bRfe,q2)/(Rfp + Rfe) - 1))

% revenue ratio
fprintf('Mean increase in fossil fuel revenue per unit mean increase in clean electricity revenue: %.3g.\n',...
    mean(bRfp + bRfe - Rfp - Rfe)/mean(bRc - Rc))

% revenue probabilities
fprintf('Probability that revenues increase for fossil fuel production: %.3g%%.',...
    100*mean(bRfp > Rfp))
    fprintf(' Fossil fuel electricity generation: %.3g%%. ',100*mean(bRfe > Rfe))
    fprintf(' Clean electricity generation: %.3g%%.\n',100*mean(bRc > Rc))
fprintf('Probability that revenue increases are higher for fossil fuels than for clean electricity: %.3g%%.\n',...
    100*mean(bRfp + bRfe - Rfp - Rfe > bRc - Rc))

% revenue plot
if figureNumber > 0
    figure(figureNumber), clf
    bg = bar([1 2 3],[mean(Rfp) mean(bRfp); [mean(Rfe) mean(bRfe)]; [mean(Rc) mean(bRc)]]); grid on
    x1 = bg(1).XEndPoints; % bar midpoints for first data series
    x2 = bg(2).XEndPoints; % bar midpoints for second data series
    text(x1(1),mean(Rfp)/2,sprintf('%.3g',mean(Rfp)),'color','white','horizontalalignment','center')
    text(x1(2),mean(Rfe)/2,sprintf('%.3g',mean(Rfe)),'color','white','horizontalalignment','center')
    text(x1(3),mean(Rc)/2,sprintf('%.3g',mean(Rc)),'color','white','horizontalalignment','center')
    text(x2(1),mean(bRfp)/2,sprintf('%.3g',mean(bRfp)),'color','white','horizontalalignment','center')
    text(x2(2),mean(bRfe)/2,sprintf('%.3g',mean(bRfe)),'color','white','horizontalalignment','center')
    text(x2(3),mean(bRc)/2,sprintf('%.3g',mean(bRc)),'color','white','horizontalalignment','center')
    eLow = mean([bRfp, bRfe, bRc]) - quantile([bRfp, bRfe, bRc],q1);
    eHigh = quantile([bRfp, bRfe, bRc],q2) - mean([bRfp, bRfe, bRc]);
    hold on, er = errorbar(x2(1:3),mean([bRfp, bRfe, bRc]),eLow,eHigh);    
    er.Color = 'k';
    er.LineStyle = 'none';
    er.LineWidth = 2;
    xticklabels({'Fossil fuel production','Fossil fuel electricity','Clean electricity'})
    ylabel('Annual revenue (\$ billions)')
    legend('2025 as it was','2025 under BAAJA')
    if toSave
        exportgraphics(gcf,'revenue.png','resolution',600);
    end
end

end