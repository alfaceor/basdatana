library(tidyverse)

H_entropy_bits <- function(relAbun){
  # 1. Normalize relativeAbun just in case
  p = relAbun/sum(relAbun, na.rm = TRUE)
  neg_log_p <- -log2(p)
  neg_log_p[is.infinite(neg_log_p)] <- 0
  neg_log_p[is.na(neg_log_p)] <- 0
  H = sum( p*neg_log_p )
  return(H)
}


H_entropy <- function(relAbun){
  # 1. Normalize relativeAbun just in case
  p = relAbun/sum(relAbun, na.rm = TRUE)
  neg_log_p <- -log(p)
  neg_log_p[is.infinite(neg_log_p)] <- 0
  neg_log_p[is.na(neg_log_p)] <- 0
  H = sum( p*neg_log_p )
  return(H)
}



ceor_stats <- function(x, na.rm=FALSE) {
  r <- c(quantile(x, probs=0.05, na.rm = na.rm),
         quantile(x, probs=0.25, na.rm = na.rm),
         quantile(x, probs=0.5, na.rm = na.rm),
         quantile(x, probs=0.75, na.rm = na.rm),
         quantile(x, probs=0.95, na.rm = na.rm),
         mean(x, na.rm=na.rm),
         sd(x, na.rm=na.rm),
         min(x, na.rm=na.rm),
         max(x, na.rm=na.rm),
         length(na.omit(x))
  )
  names(r) <- c("q05", "q25", "q50", "q75", "q95", "mean", "sd", "min", "max", "num") # Standard column names for geom_boxplot
  return(r)
}


theme_bla <-theme_bw() +
  # theme(legend.position = "none")+
  theme(
    plot.title = element_text(size = 24,hjust=-0.03),
    axis.line = element_line(colour = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.text=element_text(size=16),
    axis.title=element_text(size=18),
    axis.line.x = element_line(size = 0.5, linetype = "solid", colour = "black"),
    axis.line.y = element_line(size = 0.5, linetype = "solid", colour = "black")
  )


v_SEX_color <- c(
  "F" = "#dd1c77",
  "M" = "#2c7fb8"
)

v_DRUG_COMPLEX_levels <- c("Ct", "CRO", "CZA", "PTZ")
v_DRUG_COMPLEX_labels <- c("Control", "Ceftriaxone", "Ceftazidime\nAvibactam", "Piperacilin\nTazobactam")


v_DAV_levels <- c("NODAV", "DAVD1", "DAVD2")
v_DAV_labels <- c("No DAV132", "7.5g DAV132", "12g DAV132")




v_ACTARMCD_levels <- c("Ct", "CtD1", "CtD2",
                       "CRO", "CROD1", "CROD2",
                       "CZA", "CZAD1", "CZAD2",
                       "PTZ", "PTZD1", "PTZD2"
)

nv_DAVCD <- c("NODAV" = 0, "DAVD1" = 1, "DAVD2" = 2)


v_taxa_colnames_s2k <- c("bin_tax_species", "bin_tax_genus", "bin_tax_family", "bin_tax_order", "bin_tax_class", "bin_tax_phylum", "bin_tax_division")
v_taxa_colnames_k2s <- c("bin_tax_division", "bin_tax_phylum", "bin_tax_class", "bin_tax_order", "bin_tax_family", "bin_tax_genus", "bin_tax_species")



nv_BMI_colors <- c(
  "Underweight"= "#8ab7d6", # bmi < 18.5
  "Normal" = "#70c6a1", # bmi < 25
  "Overweight" ="#ffd90c", # bmi < 30
  "Obese" = "#f7a051", # bmi < 35
  "ExtremelyObese" = "#ef464d"
)

scale_bmi_cm <- scales::col_bin(
  bins = c(0, 18.5, 25, 30, 35, Inf),
  palette = c("#8ab7d6", "#70c6a1", "#ffd90c", "#f7a051", "#ef464d")
)

nv_BMI_colors <- c(
  "Underweight"= "#8ab7d6", # bmi < 18.5
  "Normal" = "#70c6a1", # bmi < 25
  "Overweight" ="#ffd90c", # bmi < 30
  "Obese" = "#f7a051", # bmi < 35
  "ExtremelyObese" = "#ef464d"
)


nv_BMI_shape <- c(
  "Underweight"= 3, # bmi < 18.5
  "Normal" = 15, # bmi < 25
  "Overweight" = 16, # bmi < 30
  "Obese" = 18, # bmi < 35
  "ExtremelyObese" = 8
)

v_BMI_limits <- c(0, 18.5, 25, 30, 35, Inf)
v_BMI_levels <- c(
  "Underweight",
  "Normal",
  "Overweight",
  "Obese",
  "ExtremelyObese"
)

v_BMI_labels <- c(
  "Underweight [0, 18.5)kg/m2",
  "Normal [18.5, 25)kg/m2",
  "Overweight [25, 30)kg/m2",
  "Obese [30, 35)kg/m2",
  "ExtremelyObese [35, inf)kg/m2 "
)




nv_DRUG_COMPLEX_color <- c(
  "Ct" = "#636363",
  "CRO" = "#e31a1c",
  "CZA" = "#1f78b4",
  "PTZ" = "#33a02c",
  "MXF" = "#ff7f00" 
)


nv_DAV_color <- c(
  "NODAV" = "#984ea3",
  "DAVD1" = "#b15928", #"gray",
  "DAVD2" = "black"
)


# nv_BMI_upper_limit <- c(
#   "Underweight"= 18.5,
#   "Normal" = 25,
#   "Overweight" = 30,
#   "Obese" = 35,
#   "ExtremelyObese" = 50
# )


########## Gene aesthetics
nv_ATB_R_color <- c(
  "CTX" = "#800026", #"#e31a1c",
  "CZA" = "#1f78b4",
  "TZP" = "#33a02c"
)
nv_Resistance_shape <- c(
  "Yes" = 17,
  "A_Yes" = 17,
  "No" = 1,
  "A_No" = 1
)

nv_Ambler_Class_color <- c(
  "A" = "#e31a1c",
  "B1"= "#1f78b4",
  "B3"= "#a6cee3",
  # "Candidate_blac" = "#6a3d9a",
  "D" = "#33a02c"
)


# nv_Classes_color <- c(
#   "Candidate_blaa" = "#e31a1c",
#   "Candidate_blab1"= "#1f78b4",
#   "Candidate_blab3"= "#a6cee3",
#   "Candidate_blac" = "#6a3d9a",
#   "Candidate_blad" = "#33a02c"
# )



