library(tidyverse)
library(latex2exp)

theme_ano <-theme_bw() +
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


# nv_organ_colors <- c("K"="brown", "B"="blue", "U"="orange")
# nv_LacZ_color <- c("LacZ_p_CFU_mL"="#67a9cf", "LacZ_m_CFU_mL"="#ef8a62")
# nv_organ_colors <- c("4"="#8c510a", "6"="#7570b3", "8"="#d8b365")
# nv_organ_colors <- c("4"="#762a83", "6"="#af8dc3", "8"="#fee090")
# nv_organ_colors <- c("4"="#d73027", "6"="#4575b4", "8"="#fee090")

# c("K_p_B"="#7570b3", "owK_p_owB"="#e7298a")

v_organ_levels <- c("K", "B", "U", "W")
nv_organ_colors <- c(
  "K"="#d73027", 
  "B"="#4575b4", 
  "U"="#feb24c", # #feb24c #fed976 #fee090
  "W"="#e7298a"
  )
nv_organ_shape <- c(
  "K" = 17,
  "B" = 15,
  "U" = 19,
  "W" = 18
)

v_strain_levels <- c("PAS", "NILS69", "UTI", "CFT", "ALL")
nv_strain_color <- c(
  "PAS" = "#01665e", 
  "NILS69" = "#5ab4ac", 
  "UTI" = "#8c510a", 
  "CFT"  = "#d8b365", 
  "ALL" = "black"
)

nv_strain_shape <- c(
  "PAS" = 21, 
  "NILS69" = 22, 
  "UTI" = 23, 
  "CFT"  = 24,
  "ALL" = 8
)

nv_DAY_color <- c(
  "1"="#c7e9b4",
  "2"="#7fcdbb",
  "4"="#41b6c4",
  "6"="#1d91c0",
  "10"="#225ea8",
  "14"="#6baed6",
  "16"="#0c2c84",
  "22"="black"
)

nv_DAY_shape <- c(
  "1"=16,
  "2"=15,
  "4"=17,
  "6"=6,
  "10"=0,
  "14"= 18,
  "16"=2,
  "22"=1
)

v_AB_code_levels <- c("Ct", "Cipro_d002", "Cipro_d010", "CTX", "Fosfo", "Delaflo")
nv_AB_code_color <- c(
  "Ct" = "#252525", #252525 #ff7f00
  "CTX" = "#33a02c",
  "Fosfo" = "#a6cee3",
  "Delaflo " = "#1f78b4",
  "Cipro_d002" = "#5e3c99",
  "Cipro_d010" = "#d01c8b"
)
nv_AB_code_shape <- c(
  "Ct" = 1,
  "CTX" = 4,
  "Fosfo" = 0,
  "Delaflo " = 5,
  "Cipro_d002" = 6,
  "Cipro_d010" = 2
)

nv_LacZ_color <- c("LacZ_p_CFU_mL"="#4393c3", "LacZ_m_CFU_mL"="#d6604d")



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






get_pop_parameters_tbl <- function(mdl_dir_ii){
  fln_popParams <- sprintf("%s/populationParameters.txt", mdl_dir_ii)
  tbl_params_ii <- read.csv(fln_popParams) %>% tibble()
  return(tbl_params_ii)
}

get_likelihood_tbl <- function(mdl_dir_ii){
  fln_popParams <- sprintf("%s/LogLikelihood/logLikelihood.txt", mdl_dir_ii)
  tbl_params_ii <- read.csv(fln_popParams) %>% tibble() %>% dplyr::mutate(across(-criteria, ~ signif(., digits = 6)) )
  return(tbl_params_ii)
}

get_individual_parameters <- function(mdl_dir_ii){
  fln_individual_parameters <- sprintf("%s/IndividualParameters/estimatedIndividualParameters.txt", mdl_dir_ii)
  # print(fln_individual_parameters)
  df_params_ii <- read.csv(fln_individual_parameters)
  return(df_params_ii)
}

get_individual_parameters_mode <- function(mdl_dir_ii){
  df_params_ii_mode <- get_individual_parameters(mdl_dir_ii) %>% 
    dplyr::select(id, contains("_mode")) %>% 
    dplyr::rename_all(function(x) str_replace(x, "_mode", ""))
  return(df_params_ii_mode)
}

get_TestResiduals_tbl <- function(mdl_dir_ii){
  # "Test/symmetryResiduals.txt"
  # mdl_dir_ii <- mdl_mlxtran_list[ll]
  fln_tmp <- sprintf("%s/Tests/symmetryResiduals.txt", mdl_dir_ii)
  tbl_tmp <- read.csv(fln_tmp, header = TRUE) %>% tibble()
  return(tbl_tmp)
}

get_onecol_tbl <- function(mdl_dir_ii, mdl_nickname=NULL){
  # str_mdl_name
  if (is.null(mdl_nickname)){
    mdl_nickname <- basename( tools::file_path_sans_ext(mdl_dir_ii) )
  }
  
  data_pop_parameters <- get_pop_parameters_tbl(mdl_dir_ii)
  onecol_likelihood <- get_likelihood_tbl(mdl_dir_ii) %>% rename(parameter='criteria', model_name='importanceSampling')
  
  # onecol_pop_parameters <- data_pop_parameters %>%
  #   dplyr::mutate(model_name = sprintf('%0.2g\n%0.2f%%', value, rse_sa)) %>%
  #   dplyr::select(-value, -se_sa, -rse_sa)
  # 
  if ("rse_sa" %in% colnames(data_pop_parameters) ){
    onecol_pop_parameters <- data_pop_parameters %>%
      dplyr::mutate(model_name = sprintf('%0.2g\n%0.2f%%', value, rse_sa )) %>%
      dplyr::select(parameter, model_name)
    # dplyr::select(-value, -se_sa, -rse_sa)
  }else{
    onecol_pop_parameters <- data_pop_parameters %>%
      dplyr::mutate(model_name = sprintf('%0.2g\nNO_rse', value)) %>%
      dplyr::select(parameter, model_name)
    # dplyr::select(-value)
  }
  
  onecol_model <- rbind(onecol_likelihood, onecol_pop_parameters)
  colnames(onecol_model) <- str_replace(onecol_model %>% colnames(), "model_name", mdl_nickname)
  
  return(onecol_model)
}


get_onecol_tbl_lin <- function(mdl_dir_ii, mdl_nickname=NULL){
  # str_mdl_name
  if (is.null(mdl_nickname)){
    mdl_nickname <- basename( tools::file_path_sans_ext(mdl_dir_ii) )
  }
  
  data_pop_parameters <- get_pop_parameters_tbl(mdl_dir_ii)
  tbl_likelihood <- get_likelihood_tbl(mdl_dir_ii)
  if ("linearization" %in% colnames(tbl_likelihood) ){
    if ("importanceSampling" %in% colnames(tbl_likelihood) ){
      onecol_likelihood <- get_likelihood_tbl(mdl_dir_ii) %>% dplyr::select(-importanceSampling) %>% rename(parameter='criteria', model_name='linearization')
    }else{
      onecol_likelihood <- get_likelihood_tbl(mdl_dir_ii) %>% rename(parameter='criteria', model_name='linearization')
    }
  }else{
    onecol_likelihood <- data.frame(parameter=NA, model_name=NA)
  }
  
  # onecol_pop_parameters <- data_pop_parameters %>%
  #   dplyr::mutate(model_name = sprintf('%0.2g\n%0.2f%%', value, rse_sa)) %>%
  #   dplyr::select(-value, -se_sa, -rse_sa)
  # 
  if ("rse_lin" %in% colnames(data_pop_parameters) ){
    onecol_pop_parameters <- data_pop_parameters %>%
      dplyr::mutate(model_name = sprintf('%0.2g\n%0.2f%%', value, rse_lin)) %>%
      dplyr::select(parameter, model_name)
    # dplyr::select(-value, -se_sa, -rse_sa, -se_lin, -rse_lin)
    # }else if(){
    #   
  }else {
    onecol_pop_parameters <- data_pop_parameters %>%
      dplyr::mutate(model_name = sprintf('%0.2g\nNO_rse', value)) %>%
      dplyr::select(parameter, model_name)
    # dplyr::select(-value)
  }
  
  onecol_model <- rbind(onecol_likelihood, onecol_pop_parameters)
  colnames(onecol_model) <- str_replace(onecol_model %>% colnames(), "model_name", mdl_nickname)
  
  return(onecol_model)
}


### Monolix ChartsData

get_IndividualFits <- function(mdl_dir_ii, str_yXX){
  fln_IndividualFits <- sprintf("%s/ChartsData/IndividualFits/%s_fits.txt", mdl_dir_ii, str_yXX)
  # print(fln_individual_parameters)
  df_IndividualFits <- read.csv(fln_IndividualFits)
  return(df_IndividualFits)
}

get_observations <- function(mdl_dir_ii, str_yXX){
  fln_observations <- sprintf("%s/ChartsData/IndividualFits/%s_observations.txt", mdl_dir_ii, str_yXX)
  # print(fln_individual_parameters)
  df_observations <- read.csv(fln_observations) %>%
    dplyr::mutate(variable=str_yXX) %>%
    dplyr::rename(observation=str_yXX)
  return(df_observations)
}




#################

f_rse_color_code <- Vectorize(
  function(x){
    if ( str_detect(x, "NaN%") | str_detect(x, "NA%")  | str_detect(x, "NO_rse") ){
      return(-1)
    }else if ( str_detect(x, "%") & str_detect(x, "\n") ){
      real_value <- as.numeric( str_replace(str_split(x, "\n")[[1]][2], "%", "") )
      # real_value <- as.numeric( str_replace(str_split(x, "\r\n")[[1]][2], "%", "") )
      if (!is.na(real_value) ){
        if (real_value <= 50){
          return(0)
        }else if(real_value <= 100){
          return(1)
        }else if(real_value <= 200){
          return(2)
        }else{
          return(3)
        }
      }else{
        return(0)
      }
    }else{
      return(0)
    }
  }
)


nv_monolix_colors <- c("black" = "#000000",
                       "yellow" = "#d2b11d",
                       "orange" = "#c58038",
                       "red" = "#711820"
)

f_pvalue_color_code <- Vectorize(
  # High p-values are colored in yellow (p-value in [0.01-0.05]), orange (p-value in [0.05-0.10]) or red (p-value in [0.10-1]) to draw attention on parameter-covariate relationships that can be removed from the model from a statistical point of view
  function(x){
    real_value <- as.numeric( x )
    if (!is.na(real_value) ){
      if (real_value <= 0.01){
        return(nv_monolix_colors["red"]) # black
      }else if(real_value <= 0.05){
        return(nv_monolix_colors["orange"]) # yellow
      }else if(real_value <= 0.10){
        return(nv_monolix_colors["yellow"]) # orange
      }else{
        return(nv_monolix_colors["black"]) # red
      }
    }else{
      return(nv_monolix_colors["black"]) # black
    }
    
  }
)



get_flx_tbl_monolix <- function(df_Comp){
  mat_p_color_code <- df_Comp %>% mutate(across(everything(), f_rse_color_code )) %>% as.matrix() %>% unname()
  mat_p_color_value <- sapply(mat_p_color_code,
                              function(x) case_when(
                                x == -1 ~ "red",
                                x == 0 ~ "#000000", # black
                                x == 1 ~ "#d2b11d", # yellow
                                x == 2 ~ "#c58038", # orange
                                x == 3 ~ "#711820", # red
                                TRUE ~ "#000000"
                              ),
                              simplify = TRUE)
  
  flx_tbl_tmp <- df_Comp %>%
    flextable::flextable() %>%
    flextable::theme_zebra(
      odd_header = "#CFCFCF",
      odd_body = "#EFEFEF",
      even_header = "transparent",
      even_body = "transparent"
    ) %>%
    flextable::separate_header(opts=c("center-hspan", "span-top"), split = "[.]") %>%
    flextable::bg( bg = "wheat", part = "header") %>%
    flextable::color( color=mat_p_color_value)
  
  return(flx_tbl_tmp)
}







get_df_IndividualFits_compar_to_plt <- function(path_mdl_A, path_mdl_B, str_yXX, mdl_nick_A, mdl_nick_B){
  df_IndividualFits_A <- get_IndividualFits(path_mdl_A, str_yXX) %>%
    dplyr::mutate(taxa_id=int_taxa_id) %>%
    dplyr::mutate(model=mdl_nick_A)
  
  df_IndividualFits_B <- get_IndividualFits(path_mdl_B, str_yXX) %>%
    dplyr::mutate(taxa_id=int_taxa_id) %>%
    dplyr::mutate(model=mdl_nick_B)
  
  df_IndividualFits <- bind_rows(df_IndividualFits_A, df_IndividualFits_B) %>%
    left_join(
      DF_SUBJID_METADA_COMPLEX_DRUG,
      by=c("SUBJID")
    )
  
  return(df_IndividualFits)
}


get_plt_IndividualFits_observations <- function(df_IndividualFits, df_observations, lbl_x, lbl_y, LLOQ_AbsAbun, nv_ACTARMCD_color){
  df_IndividualFits %>%
    ggplot(
      aes(x=time, y=indivPredMode)
    ) +
    geom_line(size=1, aes(color=model)) +
    geom_point(
      data=df_observations %>% dplyr::filter(ACTARMCD == str_ACTARMCD_TMP),
      aes(x=time, y=observation),
      size=2, color='black',
    ) +
    geom_hline(yintercept = log10(LLOQ_AbsAbun), linetype="dashed") +
    labs(x=lbl_x, y=lbl_y) +
    facet_wrap(~SUBJID) +
    coord_cartesian(
      ylim = c(log10(LLOQ_AbsAbun)/10, 1.1*max(df_IndividualFits$indivPredMode) )
      # xlim=c(1e-5, 1e4)
    ) +
    theme_bla +
    theme(strip.background = element_rect(fill = nv_ACTARMCD_color[str_ACTARMCD_TMP], color = nv_ACTARMCD_color[str_ACTARMCD_TMP] )) +
    theme(strip.text = element_text(colour = 'white', face="bold", size = 15)) +
    theme(panel.border = element_rect(colour = "black", fill = NA) ) +
    theme(legend.title = element_blank())
  
}







f_replace_to_fix <- function (x){
  ifelse(
    str_detect(x, "NA%"),
    str_replace(
      str_replace(x, "NO_rse", "(fix)"),
      "NA%",
      "(fix)"
    ),
    x
  )
}



get_df_params_pop_omega <- function(df_mdls_params_2_compare, param_type="all"){
  df_params_fitting <- df_mdls_params_2_compare %>%
    dplyr::filter(!str_detect(parameter, "_pop") & !str_detect(parameter, "omega_")) %>%
    dplyr::mutate(param_type="fit")
  
  df_params_pop <- df_mdls_params_2_compare %>%
    dplyr::filter(str_detect(parameter, "_pop")) %>%
    dplyr::mutate(parameter=str_replace(parameter, "_pop", "")) %>%
    dplyr::mutate(param_type="pop")
  
  df_params_omega <- df_mdls_params_2_compare %>%
    dplyr::filter(str_detect(parameter, "omega_")) %>%
    dplyr::mutate(parameter=str_replace(parameter, "omega_", "")) %>%
    dplyr::mutate(param_type="omega")
  
  df_params_pop_omega <- bind_rows(
    df_params_pop,
    df_params_omega
  ) %>% arrange(
    parameter, param_type
  ) %>%
    dplyr::select(
      parameter, param_type, everything()
    )
  
  df_params_pop_omega %>%
    dplyr::mutate_all(~replace_na(., "")) %>%
    dplyr::mutate( across(everything(), ~f_replace_to_fix(.x) ) ) %>%
    get_flx_tbl_monolix() %>%
    flextable::merge_v(j=c("parameter"))
  
  if (param_type == "all"){
    return(
      bind_rows(
        df_params_fitting,
        df_params_pop_omega
      )
    )
  }else if(param_type == "pop"){
    return(df_params_pop)
  }else if(param_type == "omega"){
    return(df_params_omega)
  }else if(param_type == "pop_omega"){
    
    df_params_pop_omega_02 <- df_params_pop_omega
    v_parameter_tmp <- df_params_pop_omega %>% dplyr::select(parameter, param_type) %>% pull(parameter) %>% unique()
    v_parameter_omega_tmp <- df_params_pop_omega %>% dplyr::filter(param_type == "omega") %>% pull(parameter) %>% unique()
    if (length(v_parameter_tmp) > length(v_parameter_omega_tmp) ){
      v_no_omega_parameters <- setdiff(v_parameter_tmp, v_parameter_omega_tmp)
      for (tmp_param in v_no_omega_parameters ){
        df_params_pop_omega_02 <- df_params_pop_omega_02 %>% 
          dplyr::add_row(parameter=tmp_param, param_type="omega")
      }
    }
    
    
    
    df_params_pop_omega_03 <- df_params_pop_omega_02 %>% 
      dplyr::mutate(param_type = factor(param_type, c("pop", "omega"))) %>% 
      dplyr::arrange(parameter, param_type)
    return(df_params_pop_omega_03)
    
  }else if(param_type == "fit"){
    return(df_params_fitting)
  }else{
    return(NULL)
  }
}



# get_df_params_pop_omega <- function(df_mdls_2_compare, param_type="all"){
#   df_params_fitting <- df_mdls_2_compare %>% 
#     dplyr::filter(!str_detect(parameter, "_pop") & !str_detect(parameter, "omega_")) %>% 
#     dplyr::mutate(param_type="fit")
#   
#   df_params_pop <- df_mdls_2_compare %>% 
#     dplyr::filter(str_detect(parameter, "_pop")) %>% 
#     dplyr::mutate(parameter=str_replace(parameter, "_pop", "")) %>% 
#     dplyr::mutate(param_type="pop")
#   
#   df_params_omega <- df_mdls_2_compare %>% 
#     dplyr::filter(str_detect(parameter, "omega_")) %>% 
#     dplyr::mutate(parameter=str_replace(parameter, "omega_", "")) %>% 
#     dplyr::mutate(param_type="omega")
#   
#   df_params_pop_omega <- bind_rows(
#     df_params_pop,
#     df_params_omega
#   ) %>% arrange(
#     parameter, param_type
#   ) %>%
#     dplyr::select(
#       parameter, param_type, everything()
#     )
#   
#   df_params_pop_omega %>% 
#     dplyr::mutate_all(~replace_na(., "")) %>% 
#     dplyr::mutate( across(everything(), ~f_replace_to_fix(.x) ) ) %>% 
#     get_flx_tbl_monolix() %>% 
#     flextable::merge_v(j=c("parameter"))
#   
#   if (param_type == "all"){
#     return(
#       bind_rows(
#         df_params_fitting,
#         df_params_pop_omega
#       )
#     )
#   }else if(param_type == "pop"){
#     return(df_params_pop)
#   }else if(param_type == "omega"){
#     return(df_params_omega)
#   }else if(param_type == "pop_omega"){
#     return(df_params_pop_omega)
#   }else if(param_type == "fit"){
#     return(df_params_fitting)
#   }else{
#     return(NULL)
#   }
# }






V_get_BICc_from_mdl_path <- Vectorize(
  function(mdl_dir_ii) ( get_likelihood_tbl(mdl_dir_ii) %>% dplyr::filter(criteria == "BICc") )$importanceSampling
)



get_sml_simulated_data <- function(sml_dir_ii){
  fln_sml_data <- sprintf("%s/Simulation/simulatedData.txt", sml_dir_ii)
  tbl_sml_ii <- read.csv(fln_sml_data, na.strings = ".") %>% tibble()
  return(tbl_sml_ii)
}

get_sml_individual_parameters <- function(sml_dir_ii){
  fln_sml_data <- sprintf("%s/Simulation/individualParameters.txt", sml_dir_ii)
  tbl_sml_ii <- read.csv(fln_sml_data, na.strings = ".") %>% tibble()
  return(tbl_sml_ii)
}




