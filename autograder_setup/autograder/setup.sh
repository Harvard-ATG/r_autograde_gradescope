#!/usr/bin/env bash

# Install R to Gradscope autograder
# give public key: https://cran.r-project.org/bin/linux/ubuntu/README.html#secure-apt
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# add source: ubuntu uses 18.04
deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/

# update everything
apt-get update

# now do usual R installation.
apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
apt-get install -y r-base r-base-dev
apt-get install -y pandoc

# If student submissions will include packages beyond basic R setup, include them here to install:
# jsonlite is used by autograder template, do not remove.
Rscript -e "install.packages('jsonlite')"
Rscript -e "install.packages('tidyverse')"
Rscript -e "install.packages('ggthemes')"