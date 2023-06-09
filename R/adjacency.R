adjacency <- function(corpus_data, skip = 0) {
  corpus_data %>%
    quanteda::tokens(remove_punct = T, remove_symbols = T,padding = F) %>%
    quanteda::tokens_remove(quanteda::stopwords("en"), padding = T) %>%
    quanteda::tokens_ngrams(n = 2, skip = skip, concatenator = " ") %>%
    dfm %>%
    textstat_frequency()%>%
    select("feature", "frequency") %>%
    mutate(ngram = skip + 2)
#  return(skip)
}

summarise_adjacency <- function(corpus, ngrams = 4){
  result_loop <- vector("list", ngrams - 1)

  for (i in seq.int(from = 2, to = ngrams)){
  skip <- i - 2
    result_loop[[i-1]] <- adjacency(corpus, skip = skip)
  }
  result <- result_loop %>%
    bind_rows %>%
    group_by(.data$feature) %>%
    summarise(frequency = sum(.data$frequency),
              ngram = .data$ngram,
              .groups = "drop") %>% # avoid dplyr message about group tibble
    arrange(.data$ngram) %>%
    tidyr::pivot_wider(names_from = "ngram",
                       names_prefix = "ngram_",
                       values_from = "ngram",
                       values_fn = as.character, # otherwise values_fill throws an error
                       values_fill = "-") %>%
    arrange(desc(frequency))
  return(result)
}

# summarise_adjacency(testset$text_corpus, ngrams = 4)

#  full_join(df30, by = "feature", suffix = c("_2", "_3")) %>%
  #  full_join(df40, by = "feature") %>%
  #  full_join(df50, by = "feature", suffix = c("_4", "_5")) %>%
  #  mutate(frequency = rowSums(dplyr::across(c(frequency_2,frequency_3,frequency_4,frequency_5)), na.rm = T),
  #         ngram = paste(ngram_2,ngram_3,ngram_4, ngram_5),
  #         ngram = str_replace_all(ngram, pattern = "NA",replacement ="-")) %>%
  #  select(feature, frequency, ngram) %>%
  #  arrange(desc(frequency))
  #

