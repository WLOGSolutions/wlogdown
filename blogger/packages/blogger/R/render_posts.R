watch_posts <- function(posts_path, site_path) {
    changed_posts <- find_changed_posts(posts_path)

    if (length(changed_posts) > 0) {
        pkg_loginfo("--> found %d changed posts in %s",
                    length(changed_posts),
                    posts_path)
    }

    render_posts(changed_posts,
                 hugo_dir = site_path)

    later::later(func = function() {
        watch_posts(posts_path,
                    site_path)
    },
    delay = 3)
}

render_posts <- function(changed_posts, hugo_dir) {
    for (post_rmd in changed_posts) {
        pkg_logdebug("--> rendering %s", post_rmd)

        render_post(post_rmd,
                    hugo_dir = hugo_dir)
    }
}

render_post <- function(post_rmd, hugo_dir) {
    hugo_static <- get_hugo_static(hugo_dir)
    hugo_posts <- get_hugo_posts(hugo_dir)
    post_root_dir <- get_post_root_dir(post_rmd)
    post_cfg <- read_post_config(post_rmd)
    post_dir_name <- get_post_dir_name(post_cfg)
    hugo_post_dir <- normalizePath(file.path(hugo_posts, post_dir_name))    
    hugo_img_dir <- normalizePath(file.path(hugo_static, "img", post_dir_name))

    if (!dir.exists(hugo_post_dir)) {
        pkg_loginfo("--> Creating dir for post")
        dir.create(hugo_post_dir, recursive = TRUE)
    }
    if (!dir.exists(hugo_img_dir)) {
        pkg_loginfo("--> Creating dir for post's images")
        dir.create(hugo_img_dir, recursive = TRUE)
    }
    
    tryCatch({
        render_results <- callr::r(func = function(post_rmd, post_root_dir, post_cfg) {
            setwd(file.path(post_root_dir, "R"))
            source(file.path(post_root_dir, "R", "set_env.r"), chdir = TRUE)

            library(rmarkdown)
            
            rmarkdown::render(post_rmd,
                              output_format = output_format(
                                  knitr = knitr_options(opts_chunk = list(
                                                            dev = "png",
                                                            fig.path = file.path("img",
                                                                                 sprintf("%s-",
                                                                                         post_cfg$slug))),
                                                        opts_knit = list(
                                                            root.dir = post_root_dir)),
                                  pandoc = pandoc_options(to = "html"),
                                  keep_md = TRUE),
                              clean = FALSE)
        },
        args = list(
            post_rmd = post_rmd,
            post_root_dir = post_root_dir,
            post_cfg = post_cfg)
        )
        post_md <- readLines(file.path(post_root_dir, "R", "post.md"))

        post_md <- gsub(pattern = "\\(img/",
                        replacement = sprintf("(/img/%s/",
                                              basename(post_dir_name)),
                        x = post_md)
        writeLines(post_md,
                   file.path(post_root_dir, "R", "post.md"))

        file.copy(from = file.path(post_root_dir, "R", "post.md"),
                  to = hugo_post_dir,
                  overwrite = TRUE)

        dir.create(hugo_img_dir)

        imgs <- list.files(file.path(post_root_dir, "R", "img"),
                           full.names = TRUE)

        file.copy(from = imgs,
                  to = hugo_img_dir,
                  recursive = FALSE)
    },
    error = function(e) {
        pkg_logerror("There was error rendering %s - %s",
                     basename(post_root_dir),
                     e$message)
        
    })    
}

get_post_root_dir <- function(post_rmd) {
    normalizePath(file.path(dirname(post_rmd), ".."))
}

get_post_dir_name <- function(post_cfg) {
    sprintf("%s-%s", post_cfg$date, post_cfg$slug)
}

read_post_config <- function(post_rmd) {
    post_cfg_file <- file.path(get_post_root_dir(post_rmd),
                          "config.txt")

    if (!file.exists(post_cfg_file)) {
        pkg_logdebug("post:%s - config.txt is not existing, reading config_templ.txt",
                     basename(get_post_root_dir(post_rmd)))
        post_cfg_file <- file.path(get_post_root_dir(post_rmd),
                              "config_templ.txt")
    }

    post_cfg <- as.list(as.data.frame(read.dcf(post_cfg_file),
                                      stringsAsFactors = FALSE))
}
