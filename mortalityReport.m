function mortalityReport(MV,bMV,ML,bML,figureNumber,toSave)
% mortalityReport reports mortality outcomes in the baseline and alternative scenarios.

arguments (Input)
    MV % baseline American mortality attributable to fossil fuel air pollution (Vohra et al.), thousand lives
    bMV % BAAJA American mortality attributable to fossil fuel air pollution (Vohra et al.) under BAAJA, thousand lives
    ML % baseline American mortality attributable to fossil fuel air pollution (Lelieveld et al.), thousand lives
    bML % BAAJA American mortality attributable to fossil fuel air pollution (Lelieveld et al.), thousand lives
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)

end

% quantiles
q1 = 0.025; % low quantile to report
q2 = 0.975; % high quantile to report

% Vohra et al.
mortality911 = 2.977; % number of American deaths on 9/11, thousands
fprintf('-------------------------------- ANNUAL MORTALITY --------------------------------\n')
fprintf('Increase in American mortality attributable to fossil fuel air pollution (Vohra et al.):\n')
fprintf('\tMean = %.3g thousand lives (%.2g%%).\n',...
    mean(bMV) - MV, 100*(mean(bMV)/MV - 1))
fprintf('\tEquivalent to %.3g 9/11s.\n',mean(bMV - MV)/mortality911)
fprintf('\t95%% confidence interval = [%.3g, %.3g] thousand lives ([%.2g, %.2g]%%).\n',...
    quantile(bMV - MV,q1), quantile(bMV - MV,q2), ...
    100*(quantile(bMV,q1)/MV - 1), 100*(quantile(bMV,q2)/MV - 1))

% Lelieveld et al.
fprintf('Increase in American mortality attributable to fossil fuel air pollution (Lelieveld et al.):\n')
fprintf('\tMean = %.3g thousand lives (%.2g%%).\n',...
    mean(bML) - ML, 100*(mean(bML)/ML - 1))
fprintf('\tEquivalent to %.3g 9/11s.\n',mean(bML - ML)/mortality911)
fprintf('\t95%% confidence interval = [%.3g, %.3g] thousand lives ([%.2g, %.2g]%%).\n',...
    quantile(bML - ML,q1), quantile(bML - ML,q2), ...
    100*(quantile(bML,q1)/ML - 1), 100*(quantile(bML,q2)/ML - 1))

% mortaility probability
fprintf('Probability that mortality from fossil fuel air pollution increases: %.3g%%.\n',...
    100*mean(bML > ML))

% mortaility plot
if figureNumber > 0
    figure(figureNumber), clf
    bg = bar([1 2],[mean(MV), mean(bMV); [mean(ML), mean(bML)]]); grid on
    x1 = bg(1).XEndPoints; % bar midpoints for first data series
    x2 = bg(2).XEndPoints; % bar midpoints for second data series
    text(x1(1),mean(MV)/2,sprintf('%.3g',mean(MV)),'color','white','horizontalalignment','center')
    text(x1(2),mean(ML)/2,sprintf('%.3g',mean(ML)),'color','white','horizontalalignment','center')
    text(x2(1),mean(bMV)/2,sprintf('%.3g',mean(bMV)),'color','white','horizontalalignment','center')
    text(x2(2),mean(bML)/2,sprintf('%.3g',mean(bML)),'color','white','horizontalalignment','center')
    eLow = mean([bMV, bML]) - quantile([bMV, bML],q1);
    eHigh = quantile([bMV, bML],q2) - mean([bMV, bML]);
    hold on, er = errorbar(x2(1:2),[mean(bMV) mean(bML)],eLow,eHigh);    
    er.Color = 'k';
    er.LineStyle = 'none';
    er.LineWidth = 2;
    ylabel({'Annual domestic mortality attributable to','fossil fuel air pollution (thousand lives)'})
    xticklabels({'Vohra et al. mortality intensity','Lelieveld et al. mortality intensity'})
    legend('2025 as it was','2025 under BAAJA')
    if toSave
        exportgraphics(gcf,'mortality.png','resolution',600);
    end
end

end