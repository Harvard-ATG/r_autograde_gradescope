# Gradescope Autograder sample setup

This repository contains a sample autograder setup, as well as instructions for students to submit R assignments to Gradescope for automatic feedback. This is based on work done for GOV 50: Data in the fall semester of 2020, generously shared by [Tyler Simko](https://tylersimko.com/), one of the TFs for the course. If interested in this repository, you should first take a look at the [Gradescope Autograder docs](https://gradescope-autograders.readthedocs.io/en/latest/) for a more full understanding of how the Gradescope Autograder works.

## Autograder setup

The `autograder_setup` folder contains a sample setup for the Gradescope autograder, including a sample `.Rmd` file for test submissions. The autograder setup is in the `autograder` folder, and includes `setup.sh`, which installs dependencies on a virtual autograder machine, `run_autograder`, which sets up the file structure after a submission and calls `autograde_assignment_1.R`, which is the last file and the one which produces the `results.json` output file that Gradescope expects. This is based on [Michael Guerzhoy](https://github.com/guerzh)'s [R autograde gradescope](https://github.com/guerzh/r_autograde_gradescope/) repository, with substantial additions for more complex grading.

## Student-facing instructions

The `assignment_instructions` directory contains an `Rmd` file that powered a page on [Rpubs.com](https://rpubs.com/), where students could find instructions on accessing materials through [GitHub Classroom](https://classroom.github.com) and submitting them to Gradescope.