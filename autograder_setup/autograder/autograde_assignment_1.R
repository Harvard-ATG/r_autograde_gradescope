#########################################################
# GOV50 Problem Set 2 Autograder
# Fall 2020
# Author: Tyler Simko
# Adapted from R assignment for Gradescope
#   example by Michael Guerzhoy guerzhoy@princeton.edu.
#   and the fork by Jeremy Guillette:
#   https://github.com/jaguillette/r_autograde_gradescope
#########################################################

#########################################################
# START FILE SETUP
# This segment sets up the files needed for Gradescope.

# rm(list = ls())

filename <- "assignment_1.Rmd" # Assignment file name

rmarkdown::render(filename, "html_document")

assignment_title_env_var = Sys.getenv(c("ASSIGNMENT_TITLE"))
# Check for the existence of an environment variable called "ASSIGNMENT_TITLE"
if(assignment_title_env_var != ""){
  # If the environment variable is not empty, we're in Gradescope,
  # so set the output correctly for Gradescope to find it
  json.filename <- "/autograder/results/results.json"
}else{
  # If the environment variable is empty, we're working locally,
  # so just put the output in this same directory.
  json.filename <- "results.json"
}

# END FILE SETUP
#########################################################

#########################################################
# START ASSIGNMENT SETUP
# This section is for things needed to assess the submitted 
# file(s) that aren't the actual tests. This is a good place 
# to load sample data and set up structures needed for testing.

# Loading necessary libraries.
suppressMessages(library(jsonlite))
suppressMessages(library(tidyverse))
suppressMessages(library(ggthemes))

# Some helper functions.
# Don't remove without care, used in tests
factors.to.chars <- function(column){
  if("factor" %in% class(column)){
    as.character(column)
  }else{
    column
  }
}

my.toString <- function(obj){
  if("data.frame" %in% class(obj)){
    toString(as_tibble(lapply(obj, as.character)))
  }else{
    toString(obj)
  }
}

my.isEqual <- function(obj1, obj2){
  if(all(obj1 == obj2)){
    TRUE
  }else{
    FALSE
  }
}

# END ASSIGNMENT SETUP
#########################################################

#########################################################
# START TEST SETUP
# 
# Gradescope grades each question using a series of 
# function tests. The list `test.cases` below contains
# a list of functions to call for each question. The 
# functions below do the actual object comparisons for
# grading.

#########################################################
# Submission Credit

testSubmission <- function() {
  return("Successfully submitted file!")
}

#########################################################
# Q1
# Creates an object on our end, checks similarity to student object.
# Problem set asked student to create an object called "q1" which:
  # 1. Filters to only states with values of `estimate` above 20000.
  # 2. Then, select only the `GEOID`, `NAME`, and `estimate` columns.

# Here is the autograder's answer:
q1_solution <- us_rent_income %>% 
  filter(estimate > 20000) %>% 
  select(GEOID, NAME, estimate)

# testQuestion1() is a function run by the autograder which will compare
# the student object, which we asked to be called q1, to our q1_solution.
testQuestion1 <- function() {
  return(
    case_when(
      is.null(q1) ~ "Object q1 does not exist. Did you assign your answer to an object called q1?",
      nrow(q1) != nrow(q1_solution) ~ "q1 has incorrect number of rows.",
      ncol(q1) != ncol(q1_solution) ~ "q1 has incorrect number of columns.",
      !identical(q1, q1_solution) ~ "q1 doesn't look right - are you sure you selected the correct columns?",
      identical(q1, q1_solution) ~ "SUCCESS"
    )
  )
}

#########################################################
# Q2 is a plot, which will be graded manually.
# So, Gradescope doesn't need to do anything!

#########################################################
# This example problem set only has two questions, but 
# subsequent questions can follow the example set by 
# Q1 and Q2. If an object needs to be evaluated, run tests
# similar to testQuestion1().

#########################################################
# START TEST SETUP
# 
# This section is where a list of tests is created. Each 
# test in the list has several parts:
# name: the name of the evaluation criterion shown to students
# fun: the function to be run, as a text string
# args: the arguments provided to that function, as a list of objects
# expect: the expected output of `fun`, as an R object
# visibility: whether this criterion will be shown to students. Accepted values are "visible" and "hidden"
# weight: the number of points possible for this criterion
#
# In this example, students get 5 points for successfully submitting (testSubmission())
# and 5 points for passing the Q1 test (weight = 5).

test.cases <- list(
  list(
    name = "Submission Test: your file was successfully received.",
    fun = "testSubmission",
    args = list(),
    expect = "Successfully submitted file!",
    visibility = "visible",
    weight = 5
  ),
  list(
    name = "Question 1: object q1.",
    fun = "testQuestion1",
    args = list(),
    expect = "SUCCESS",
    visibility = "visible",
    weight = 5
  )
)

# END TEST SETUP
#########################################################

#########################################################
# START RUN TESTS
# The rest of the code runs the tests, then prepares the JSON output appropriately.
# You probably don't want to edit it unless you have to.

ret <- tryCatch(rmarkdown::render(filename, "html_document"), error = function(c) c, warning = function(c) c, message = function(c) c)
if(!("message" %in% names(ret))){
  # This used to be a check for `visible` in the `ret` object, but now it's a check
  # for "message" because that should be in the message returned by knitting the markdown
  tests <- list()
  tests[["tests"]] <- list()
  
  for(i in 1:length(test.cases)){
    tests[["tests"]][[i]] <- list(test.cases[[i]][["name"]],
                                  score = 0,
                                  max.score = test.cases[[i]][["weight"]],
                                  visibility = test.cases[[i]][["visibility"]],
                                  output = my.toString(ret))
  }
  
  
  
  write(toJSON(tests, auto_unbox = T), file = json.filename)
  stop(my.toString(ret))
}

tests <- list()
tests[["tests"]] <- list()
for(i in 1:length(test.cases)){
  cur.name <- test.cases[[i]][["name"]]
  cur.fun <- test.cases[[i]][["fun"]]
  cur.args <- test.cases[[i]][["args"]]
  cur.expect <- test.cases[[i]][["expect"]]
  cur.vis <- test.cases[[i]][["visibility"]]
  cur.weight <- test.cases[[i]][["weight"]]
  ret.val <- tryCatch(do.call(cur.fun, cur.args), error = function(c) c, warning = function(c) c ,message = function(c) c)
  
  cur.output <- ""
  
  
  if(my.toString(ret.val) == my.toString(cur.expect)){
    cur.score <-  cur.weight
    cur.output <- "Test passed!\n"
  }else{
    cur.score <- 0
    cur.output <- paste(
      "\n\nExpected:", my.toString(cur.expect), 
      "\n\nGot:", my.toString(ret.val))
  }
  tests[["tests"]][[i]] <- list(name = cur.name,
                                score = cur.score,
                                max.score = cur.weight)
  
  tests[["tests"]][[i]][["output"]] <- cur.output
  
  if(cur.vis != "visible"){
    tests[["tests"]][[i]][["visibility"]] <- cur.vis
  }
}

cat.tests <- function(tests){
  for(i in 1:length(tests[["tests"]])){
    cur.name <- test.cases[[i]][["name"]]
    cur.fun <- test.cases[[i]][["fun"]]
    cur.args <- test.cases[[i]][["args"]]
    cur.expected <- test.cases[[i]][["expect"]]
    cur.output <- tests[["tests"]][[i]][["output"]]
    score <- tests[["tests"]][[i]][["score"]]
    max.score <- tests[["tests"]][[i]][["max.score"]]
    
    
    
    cat(sprintf("Test %s: %s(%s)\n", cur.name, cur.fun, my.toString(cur.args)))
    cat(sprintf("Expected: %s\n", my.toString(cur.expected)))
    cat(sprintf("Output:\n %s\n", my.toString(cur.output)))
    cat(sprintf("Score: %g/%g\n", score, max.score))
    cat("====================================================\n\n\n")
    
  }
}
cat.tests(tests)
write(toJSON(tests, auto_unbox = T), file = json.filename)

# END RUN TESTS
#########################################################