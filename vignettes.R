dir.create("vignettes")
---
  title: "Multi-Omics Integration Workflow"
output: html_document
---
  
  ```{r}
library(OmicsFusionR)

data(example_multiomics)

# normalization
norm <- omics_normalize(example_multiomics)

# latent features
latent <- extract_latent(norm)

# sparse CCA integration
model <- run_scca(norm)

# feature ranking
rank <- rank_features(model)

head(rank$omics1)

# network
plot_multiomics_network(norm$protein, norm$transcript)