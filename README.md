Kevin J. Kircher, Purdue University, November 3, 2026

This repository accompanies the report "Potential impacts of the Bipartisan American Affordability and Jobs Act on United States energy systems" available at https://kevinjkircher.com/baaja/.

It uses Monte Carlo simulation and deterministic sensitivity analysis to evaluate BAAJA's potential economic and environmental impacts.

The wrapper script BAAJA.m calls subroutines to output all the numbers and graphs in the report.

To run BAAJA.m, please ensure the following functions are on your Matlab path:

initializeBaselineParameters.m

setDerivedParameters.m

fitDirectUseParameters.m

stochasticSimulation.m

energyReport.m

revenueReport.m

jobReport.m

greenhouseGasReport.m

mortalityReport.m

tradeoffReport.m

deterministicSimulation.m

tradeoffPlots.m
