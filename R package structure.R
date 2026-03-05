# Sparse CCA
run_scca <- function(data_list, penaltyx = 0.3, penaltyz = 0.3){
  
  if(length(data_list) < 2){
    stop("At least two omics datasets are required.")
  }
  
  X <- data_list[[1]]
  Z <- data_list[[2]]
  
  result <- PMA::CCA(
    x = X, # X = omics layer 1
    z = Z, #Z = omics layer 2
    typex = "standard",
    typez = "standard",
    penaltyx = penaltyx,
    penaltyz = penaltyz
  )
  model <- list(
    u = result$u, #u/v = canonical weights
    v = result$v,
    cors = result$cors #cors = canonical correlation
  )
  return(model)
}

# Normalize multi-omics data
omics_normalize <- function(data_list, method = "zscore") {
  normalize_matrix <- function(x) {
    if(method == "zscore"){
      return(scale(x))
    }
    if(method == "log"){
      return(log2(x + 1))
    }
    if(method == "minmax"){
      return((x - min(x)) / (max(x) - min(x)))
    }
  }
  lapply(data_list, normalize_matrix)
}

# Impute missing values

impute_omics <- function(data_list, method = "mean"){
  impute_matrix <- function(x){
    if(method == "mean"){
      x[is.na(x)] <- mean(x, na.rm = TRUE)
    }
    if(method == "median"){
      x[is.na(x)] <- median(x, na.rm = TRUE)
    }
    return(x)
  }
  lapply(data_list, impute_matrix)
}

# Extract latent representation using PCA

extract_latent <- function(data_list, ncomp = 5){
  latent_list <- lapply(data_list, function(x){
    pca <- prcomp(x, scale. = TRUE)
    pca$x[,1:ncomp]
  })
  return(latent_list)
}

# Integrate latent omics layers

integrate_omics <- function(latent_list){
  data_all <- do.call(cbind, latent_list)
  cor_matrix <- cor(data_all)
  model <- list(
    latent = latent_list,
    correlation = cor_matrix
  )
  return(model)
}

# Rank features based on correlation strength

rank_features <- function(model){
  cor_matrix <- model$correlation
  score <- apply(abs(cor_matrix), 1, mean)
  ranking <- sort(score, decreasing = TRUE)
  return(ranking)
}

library(igraph)
library(ggplot2)
library(reshape2)

plot_multiomics_network <- function(model, threshold = 0.6){
  cor_matrix <- model$correlation
  cor_matrix[abs(cor_matrix) < threshold] <- 0
  graph <- graph_from_adjacency_matrix(
    cor_matrix,
    mode = "undirected",
    weighted = TRUE,
    diag = FALSE
  )
  plot(graph,
       vertex.size = 6,
       vertex.label.cex = 0.7)
}