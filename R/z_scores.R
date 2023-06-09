#' Create z-scores for every token in the testset provided
#'
#' @inheritParams create_testset
#' @param references an object created with create_testset() to be used fo analysis instead of a raw ris file
#' @param risfile_population a risfile from Endnote containing a population set
#' @param load_popset logical, should internal population set be applied (default) or should a customized population set be calculated
#'
#' @returns a list
#' @export
#' @examples
#' ris <- c("TY  - JOUR",
#'          "AU  - Kapp",
#'          "TI  - Titles",
#'          "PY  - 2023",
#'          "JOUR  - IQWiG Journal",
#'          "KW  - Systematic Reviews as Topic",
#'          "ER  -")
#'
#' tmp <- tempfile(fileext = ".txt")
#' writeLines(ris, tmp)
#' z_scores(tmp)
#'
z_scores <- function(risfile = NULL, references = NULL, risfile_population, load_popset = TRUE,dev_set = FALSE, seed = NULL){

  #load population set
  if(load_popset == F){
    popset <- create_popset(risfile_population)
  }
  if(!is.null(risfile)){
  # calculate frequency table for testset
  testset <- create_testset(risfile, dev_set = dev_set, seed = seed)
  }else if (!is.null(references)){
  testset <- references
  }else {
    stop("Please provide a valid set of test references as risfile or created with create_testset()")
  }
  testset <- create_MeSH_qualifier_lists(testset)


  zscore_freetext <- calculate_z_scores(testset[["freetext"]], popset[["freetext"]], key_testset = "feature", key_popset = "feature")
  zscore_MeSH <- calculate_z_scores(testset[["MeSH.Terms"]][["MeSH"]], popset[["MeSH.Terms"]], key_popset = "MeSH")
  zscore_qualifier <- calculate_z_scores(testset[["MeSH.Terms"]][["qualifier"]], popset[["qualifier"]], key_popset = "qualifier")

  #revtools::write_bibliography(testset[["validation_set"]],
  #                             filename = paste0(here::here(),
  #                                               "/Output/validation_set.ris")
  #                             , format = "ris")

  # überarbeiten
  result <- list("freetext" = zscore_freetext,
                 "MeSH" = zscore_MeSH,
                 "qualifier" = zscore_qualifier,
                 "all_keywords" = testset$MeSH.Terms$MeSH_with_qualifier,
                 "leftover_keywords" = testset$MeSH.Terms$Not_MeSH)
  return(result)
}
