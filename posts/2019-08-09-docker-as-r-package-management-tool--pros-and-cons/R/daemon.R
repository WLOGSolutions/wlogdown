# Detect proper script_path (you cannot use args yet as they are build with tools in set_env.r)
script_path <- (function() {
  args <- commandArgs(trailingOnly = FALSE)
  script_path <- dirname(sub("--file=", "", args[grep("--file=", args)]))
  if (!length(script_path)) {
    return("R")
  }
  if (grepl("darwin", R.version$os)) {
    base <- gsub("~\\+~", " ", base) # on MacOS ~+~ in path denotes whitespace
  }
  return(normalizePath(script_path))
})()

# Setting .libPaths() to point to libs folder
source(file.path(script_path, "set_env.R"), chdir = T)

config <- load_config()
args <- args_parser()

library(later)
library(rmarkdown)

hugo_dir <- normalizePath(file.path(script_path,
                                    "../../../site"))

hugo_static <- normalizePath(file.path(hugo_dir, "static"))
hugo_posts <- normalizePath(file.path(hugo_dir, "content", "post"))
post_dir_name <- sprintf("%s-%s", config$date, config$slug)
hugo_post_dir <- normalizePath(file.path(hugo_posts, post_dir_name))
hugo_img_dir <- normalizePath(file.path(hugo_static, "img", post_dir_name))


if (!file.exists(hugo_post_dir)) {
    dir.create(hugo_post_dir)
}

update_post <- function() {
    rmd_mtime <- as.integer(file.mtime(file.path(script_path, "post.Rmd")))
    md_mtime <- as.integer(file.mtime(file.path(script_path, "post.md")))

    this_was_error <- FALSE
    if ((!file.exists(file.path(script_path, "post.md")) | md_mtime < rmd_mtime)) {
        loginfo("Rmd file updated --> rendering post")
        loginfo("--> path = %s", getwd())

        this_was_error <- tryCatch({
            loginfo("--> rendering")
            rmarkdown::render(file.path(script_path, "post.Rmd"),
                              output_format = output_format(
                                  knitr = knitr_options(opts_chunk = list(
                                                            dev = "png",
                                                            fig.path = file.path("img",
                                                                                 sprintf("%s-",
                                                                                         config$slug))),
                                                        opts_knit = list(
                                                            root.dir = file.path(script_path, ".."))),
                                  pandoc = pandoc_options(to = "html"),
                                  keep_md = TRUE),
                              clean = FALSE)

            post_md <- readLines(file.path(script_path, "post.md"))

            post_md <- gsub(pattern = "\\(img/",
                            replacement = sprintf("(/img/%s/",
                                                  post_dir_name),
                            x = post_md)
            writeLines(post_md,
                       file.path(script_path, "post.md"))

            file.copy(from = file.path(script_path, "post.md"),
                      to = hugo_post_dir,
                      overwrite = TRUE)

            dir.create(hugo_img_dir)

            imgs <- list.files(file.path(script_path, "img"),
                               full.names = TRUE)

            file.copy(from = imgs,
                      to = hugo_img_dir,
                      recursive = FALSE)

            return(FALSE)
        },
        error = function(e) {
            loginfo("--> error during rendering post")
            return(TRUE)
        })
    }
    later::later(func = update_post,
                 delay = 3)
}

while(TRUE) {
    update_post()
}
