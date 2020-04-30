
#options(repos="https://mirrors.nics.utk.edu/cran") # tn
options(repos = c(CRAN = "http://cran.rstudio.com"))
options(unzip="internal") # for devtools github install

showdf <- function(...) print.data.frame(row.names=F, ...)

updatePrompt <- function(...) {
   options(prompt=format(Sys.time(),
           "\n\033[38;5;197m# \033[38;5;27m%X\033[0;0m\n "))
   return(T)
}

updatePrompt <- function(...) {options(prompt=format(Sys.time(), "\n# %X\n#> ")); return(TRUE)}
.First <- function(...) {
  ### fancy prompt
  # check that we are interactive, that we are not in Rstuido (via libPahts) or emacs/ESS (STERM iESS or dumb term)
  isdumb <- options('STERM')=='iESS'       ||    # emacs
            Sys.getenv('INSIDE_EMACS')!='' ||    # emacs
            Sys.getenv('TERM') == 'dumb'   ||    # no color term
            Sys.getenv('RSTUDIO') == '1'   ||    # rstudio
            Sys.getenv("RADIAN_VERSION") != "" ||# radian
            Sys.getenv("NVIMR_ID") != ""
  


   # radian settings
   if( Sys.getenv("RADIAN_VERSION") != "" ){
      options(
        radian.prompt = "\033[0;32m>\033[0m ",
        radian.shell_prompt = "\033[0;31m#!>\033[0m ",
        radian.browse_prompt = "\033[0;33mBrowse[{}]>\033[0m ",
        radian.enable_reticulate_prompt = TRUE
      )
     #library(colorout)

   }

  # nothing below is good for a dumb/emacs/rstudio R instance
  # only useful if we are using interative mode (and we arent in R studio)
  if(isdumb || !interactive()) return()

  ## PROMPT
  # add blue and pink colors to the prompt
  updatePrompt <- function(...) {options(prompt=format(Sys.time(), 
     #"\n# [38;5;27m%X[0;0m\n#[38;5;197m>[0;0m "
     "\n[38;5;197m# [38;5;27m%X[0;0m\n "
     )); return(TRUE)}

 # add prompt changing function as task callback when we are interactive
 # N.B R has to execute code (cannot just hit enter for new time)
 addTaskCallback(updatePrompt)
 updatePrompt()

 # console R session, add color
 # library(colorout)
}


nnz <- function(v) length(which(v))
nuniq <- function(v) length(unique(v))
histc <- function(v) {
   r <- rle(sort(v))
   i <- order(r$length)
   data.frame(v=r$value[i], n=r$length[i])
}

qns <- function() quit(save="no")
qys <- function() quit(save="yes")


if (F){
 devtools::install_github(c("yihui/servr", "hafen/rmote"))
 rmote::start_rmote()
}
#library(colorout)
# update all packages
update_packages <- function() install.packages(rownames(installed.packages()))

undoRprofile <- function() {
   removeTaskCallback(1)
   options(prompt="> ")
   .First <- function() return(T)
   .Last <- function() return(T)
}
