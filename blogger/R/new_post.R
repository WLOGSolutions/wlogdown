                                        # Detect proper script_path (you cannot use args yet as they are build with tools in set_env.r)
script_path <- (function() {
    args <- commandArgs(trailingOnly = FALSE)
    script_path <- dirname(sub("--file=", "", args[grep("--file=", args)]))
    if (!length(script_path)) {
        return("R")
    }
    if (grepl("darwin", R.version$os)) {
        script_path <- gsub("~\\+~", " ", script_path) # on MacOS ~+~ in path denotes whitespace
    }
    return(normalizePath(script_path))
})()

                                        # Setting .libPaths() to point to libs folder
source(file.path(script_path, "set_env.R"), chdir = T)

config <- load_config()
args <- args_parser()

posts_path <- normalizePath(file.path(script_path, "..", "..", "posts"))

build_slug <- function(title) {
    gsub(pattern ="-$",
         replacement = "",
         x = tolower(gsub(pattern = "[[:blank:]|[:punct:]]",
                          replacement = "-",
                          title)))
}

post_author <- args$get("author", FALSE, "No one")
post_title <- args$get("title", FALSE, "No title")
post_slug <- build_slug(post_title)

post_date <- Sys.Date()

post_prj_name <- sprintf("%s-%s",
                         post_date,
                         post_slug)

post_prj <- RSuite::prj_start(name = post_prj_name,
                              path = posts_path,
                              tmpl = "blog-post",
                              skip_rc = TRUE)

prj_config <- readLines(con = file.path(posts_path,
                                        post_prj_name,
                                        "config_templ.txt"))
prj_config <- gsub(pattern = "__post_author__",
                   replacement = post_author,
                   x = prj_config)

prj_config <- gsub(pattern = "__post_title__",
                   replacement = post_title,
                   x = prj_config)

prj_config <- gsub(pattern = "__post_slug__",
                   replacement = post_slug,
                   x = prj_config)

prj_config <- gsub(pattern = "__post_date__",
                   replacement = post_date,
                   x = prj_config)

writeLines(text = prj_config,
           con = file.path(posts_path,
                           post_prj_name,
                           "config_templ.txt"))

RSuite::prj_install_deps(prj = post_prj)
