test_that("Z-scores are calculated", {
  result <- z_scores(test_path("fixtures", "testset_ris.txt"))
  expect_named(result, c("freetext", "MeSH", "qualifier", "all_keywords", "leftover_keywords"))
  })
