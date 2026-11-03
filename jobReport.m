function jobReport(Jc,bJc,Jfe,bJfe,Jfp,bJfp,figureNumber,toSave)
% jobReport reports job outcomes in the baseline and alternative scenarios.

arguments (Input)
    Jc % baseline clean electricity jobs, thousands
    bJc % clean electricity jobs under BAAJA, thousands
    Jfe % baseline fossil electricity jobs, thousands
    bJfe % fossil electricity jobs under BAAJA, thousands
    Jfp % baseline fossil fuel production jobs, thousands
    bJfp % fossil fuel production jobs under BAAJA, thousands
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)

end

% quantiles
q1 = 0.025; % low quantile to report
q2 = 0.975; % high quantile to report

% clean electricity
fprintf('-------------------------------- ANNUAL JOBS --------------------------------\n')
fprintf('Increase in clean electricity jobs:\n')
fprintf('\tMean = %.3g thousand (%.2g%%).\n',...
    mean(bJc) - Jc, 100*(mean(bJc)/Jc - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] thousand ([%.2g, %.2g]%%).\n',...
    quantile(bJc - Jc,q1), quantile(bJc - Jc,q2), ...
    100*(quantile(bJc,q1)/Jc - 1), 100*(quantile(bJc,q2)/Jc - 1))

% fossil fuel electricity
fprintf('Increase in fossil fuel electricity jobs:\n')
fprintf('\tMean = %.3g thousand (%.2g%%).\n',...
    mean(bJfe) - Jfe, 100*(mean(bJfe)/Jfe - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] thousand ([%.2g, %.2g]%%).\n',...
    quantile(bJfe - Jfe,q1), quantile(bJfe - Jfe,q2), ...
    100*(quantile(bJfe,q1)/Jfe - 1), 100*(quantile(bJfe,q2)/Jfe - 1))

% fossil fuel production
fprintf('Increase in fossil fuel production jobs:\n')
fprintf('\tMean = %.3g thousand (%.2g%%).\n',...
    mean(bJfp) - Jfp, 100*(mean(bJfp)/Jfp - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] thousand ([%.2g, %.2g]%%).\n',...
    quantile(bJfp - Jfp,q1), quantile(bJfp - Jfp,q2), ...
    100*(quantile(bJfp,q1)/Jfp - 1), 100*(quantile(bJfp,q2)/Jfp - 1))

% total fossil fuel
fprintf('Increase in total fossil fuel jobs:\n')
fprintf('\tMean = %.3g thousand (%.2g%%).\n',...
    mean(bJfp + bJfe) - Jfp - Jfe, 100*(mean(bJfp + bJfe)/(Jfp + Jfe) - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] thousand ([%.2g, %.2g]%%).\n',...
    quantile(bJfp + bJfe - Jfp - Jfe,q1), quantile(bJfp + bJfe - Jfp - Jfe,q2), ...
    100*(quantile(bJfp + bJfe,q1)/(Jfp + Jfe) - 1), 100*(quantile(bJfp + bJfe,q2)/(Jfp + Jfe) - 1))

% jobs ratio
fprintf('Mean increase in fossil fuel jobs per unit mean increase in clean electricity jobs: %.3g.\n',...
    mean(bJfp + bJfe - Jfp - Jfe)/mean(bJc - Jc))

% jobs probabilities
fprintf('Probability that jobs increase for fossil fuel production: %.3g%%.',...
    100*mean(bJfp > Jfp))
    fprintf(' Fossil fuel electricity generation: %.3g%%. ',100*mean(bJfe > Jfe))
    fprintf(' Clean electricity generation: %.3g%%.\n',100*mean(bJc > Jc))
fprintf('Probability that job increases are higher for fossil fuels than for clean electricity: %.3g%%.\n',...
    100*mean(bJfp + bJfe - Jfp - Jfe > bJc - Jc))

% job plot
if figureNumber > 0
    figure(figureNumber), clf
    bg = bar([1 2 3],[mean(Jfp) mean(bJfp); [mean(Jfe) mean(bJfe)]; [mean(Jc) mean(bJc)]]); grid on
    x1 = bg(1).XEndPoints; % bar midpoints for first data series
    x2 = bg(2).XEndPoints; % bar midpoints for second data series
    text(x1(1),mean(Jfp)/2,sprintf('%.3g',mean(Jfp)),'color','white','horizontalalignment','center')
    text(x1(2),mean(Jfe)/2,sprintf('%.3g',mean(Jfe)),'color','white','horizontalalignment','center')
    text(x1(3),mean(Jc)/2,sprintf('%.3g',mean(Jc)),'color','white','horizontalalignment','center')
    text(x2(1),mean(bJfp)/2,sprintf('%.3g',mean(bJfp)),'color','white','horizontalalignment','center')
    text(x2(2),mean(bJfe)/2,sprintf('%.3g',mean(bJfe)),'color','white','horizontalalignment','center')
    text(x2(3),mean(bJc)/2,sprintf('%.3g',mean(bJc)),'color','white','horizontalalignment','center')
    eLow = (mean([bJfp, bJfe, bJc]) - quantile([bJfp, bJfe, bJc],q1));
    eHigh = (quantile([bJfp, bJfe, bJc],q2) - mean([bJfp, bJfe, bJc]));
    hold on, er = errorbar(x2(1:3),mean([bJfp, bJfe, bJc]),eLow,eHigh);    
    er.Color = 'k';
    er.LineStyle = 'none';
    er.LineWidth = 2;
    xticklabels({'Fossil fuel production','Fossil fuel electricity','Clean electricity'})
    ylabel({'Annual jobs (thousands)'})
    legend('2025 as it was','2025 under BAAJA')
    if toSave
        exportgraphics(gcf,'jobs.png','resolution',600);
    end
end

end