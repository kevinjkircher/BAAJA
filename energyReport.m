function energyReport(E,bE,C,bC,P,bP,D,bD,X,bX,figureNumber,toSave)
% energyReport reports energy outcomes in the baseline and alternative scenarios.

arguments (Input)
    E % baseline total electricity generation, EJ
    bE % total electricity generation under BAAJA, EJ
    C % baseline clean electricity generation, EJ
    bC % clean electricity generation under BAAJA, EJ
    P % baseline total fossil fuel production, EJ
    bP % total fossil fuel production under BAAJA, EJ
    D % baseline total domestic fossil fuel direct use, EJ
    bD % total domestic fossil fuel direct use under BAAJA, EJ
    X % baseline fossil fuel exports, EJ
    bX % fossil fuel exports under BAAJA, EJ
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)

end

% quantiles
q1 = 0.025; % low quantile to report
q2 = 0.975; % high quantile to report

% clean electricity report
fprintf('-------------------------------- ANNUAL ENERGY --------------------------------\n')
fprintf('Increase in clean electricity generation:\n')
fprintf('\tMean = %.3g EJ (%.2g%%).\n',...
    mean(bC) - C, 100*(mean(bC)/C - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] EJ ([%.2g, %.2g]%%).\n',...
    quantile(bC - C,q1), quantile(bC - C,q2), ...
    100*(quantile(bC,q1)/C - 1), 100*(quantile(bC,q2)/C - 1))

% fossil fuel electricity report
fprintf('Increase in fossil fuel electricity generation:\n')
fprintf('\tMean = %.3g EJ (%.2g%%).\n',...
    mean(bE - bC) - (E - C), 100*(mean(bE - bC)/(E - C) - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] EJ ([%.2g, %.2g]%%).\n',...
    quantile(bE - bC - (E - C),q1), quantile(bE - bC - (E - C),q2), ...
    100*(quantile(bE - bC,q1)/(E - C) - 1), 100*(quantile(bE - bC,q2)/(E - C) - 1))

% total electricity report
fprintf('Increase in total electricity generation:\n')
fprintf('\tMean = %.3g EJ (%.2g%%).\n',...
    mean(bE) - E, 100*(mean(bE)/E - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] EJ ([%.2g, %.2g]%%).\n',...
    quantile(bE - E,q1), quantile(bE - E,q2), ...
    100*(quantile(bE,q1)/E - 1), 100*(quantile(bE,q2)/E - 1))

% fossil fuel production report
fprintf('Increase in fossil fuel production:\n')
fprintf('\tMean = %.3g EJ (%.2g%%).\n',...
    mean(bP) - P, 100*(mean(bP)/P - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] EJ ([%.2g, %.2g]%%).\n',...
    quantile(bP - P,q1), quantile(bP - P,q2), ...
    100*(quantile(bP,q1)/P - 1), 100*(quantile(bP,q2)/P - 1))

% fossil fuel direct use report
fprintf('Increase in fossil fuel direct use:\n')
fprintf('\tMean = %.3g EJ (%.2g%%).\n',...
    mean(bD) - D, 100*(mean(bD)/D - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] EJ ([%.2g, %.2g]%%).\n',...
    quantile(bD - D,q1), quantile(bD - D,q2), ...
    100*(quantile(bD,q1)/D - 1), 100*(quantile(bD,q2)/D - 1))

% fossil fuel export report
fprintf('Increase in fossil fuel exports:\n')
fprintf('\tMean = %.3g EJ (%.2g%%).\n',...
    mean(bX) - X, 100*(mean(bX)/X - 1))
fprintf('\t95%% confidence interval = [%.3g, %.3g] EJ ([%.2g, %.2g]%%).\n',...
    quantile(bX - X,q1), quantile(bX - X,q2), ...
    100*(quantile(bX,q1)/X - 1), 100*(quantile(bX,q2)/X - 1))

% energy probabilities
fprintf('Probability that clean generation increases: %.3g%%.',...
    100*mean(bC > C))
    fprintf(' Fossil fuel electricity generation: %.3g%%. ',100*mean(bE - bC > E - C))
    fprintf(' Total generation: %.3g%%.\n',100*mean(bE > E))
fprintf('Probability that generation increases are higher for clean than fossil fuel electricity: %.3g%%.\n',...
    100*mean(bC - C > bE - bC - (E - C)))
fprintf('Probability that domestic fossil fuel use (direct + electricity) increases: %.3g%%.\n',...
    100*mean(bP - bX > P - X))
fprintf('Probability that fossil fuel exports increase: %.3g%%.\n',...
    100*mean(bX > X))

% electricity plot
if figureNumber > 0
    figure(figureNumber), clf
    bg = bar([1 2],[mean(E-C), mean(bE-bC); [mean(C), mean(bC)]]); grid on
    x1 = bg(1).XEndPoints; % bar midpoints for first data series
    x2 = bg(2).XEndPoints; % bar midpoints for second data series
    text(x1(1),mean(E-C)/2,sprintf('%.3g',mean(E-C)),'color','white','horizontalalignment','center')
    text(x1(2),mean(C)/2,sprintf('%.3g',mean(C)),'color','white','horizontalalignment','center')
    text(x2(1),mean(bE-bC)/2,sprintf('%.3g',mean(bE-bC)),'color','white','horizontalalignment','center')
    text(x2(2),mean(bC)/2,sprintf('%.3g',mean(bC)),'color','white','horizontalalignment','center')
    eLow = mean([bE-bC, bC]) - quantile([bE-bC, bC],q1);
    eHigh = quantile([bE-bC, bC],q2) - mean([bE-bC, bC]);
    hold on, er = errorbar(x2(1:2),[mean(bE-bC) mean(bC)],eLow,eHigh);    
    er.Color = 'k';
    er.LineStyle = 'none';
    er.LineWidth = 2;
    xticklabels({'Fossil fuel','Clean'})
    ylabel('Annual electricity generation (EJ)')
    legend('2025 as it was','2025 under BAAJA')
    if toSave
        exportgraphics(gcf,'generation.png','resolution',600);
    end
end

end