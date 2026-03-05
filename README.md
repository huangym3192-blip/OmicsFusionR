# OmicsFusionR
Package: OmicsFusionR Type: Package Title: Multi-Omics Integration Framework Version: 0.1.0 Description: A unified framework for multi-omics integration including normalization, latent representation extraction, cross-omics correlation analysis, feature ranking, and visualization. License: MIT Encoding: UTF-8 

OmicsFusionR is an R package designed for multi-omics data integration. 
It provides a unified framework including data normalization, latent 
representation extraction, cross-omics integration, feature ranking, 
and visualization.

## Installation

```r
devtools::install_github("huangym3192/OmicsFusionR")

## Example Workflow
library(OmicsFusionR)

data(example_multiomics)

norm_data <- omics_normalize(example_multiomics)

latent <- extract_latent(norm_data)

model <- integrate_omics(latent)

rank <- rank_features(model)

plot_multiomics_network(model)
