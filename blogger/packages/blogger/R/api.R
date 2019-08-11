
#' Main function that continuosly watches posts dir for changes and renders posts
#' 
#' @param posts_path folder(s) to watch for posts
#' @param site_path folder where hugo's site is localized
#'
#' @export
server <- function(posts_path, site_path) {
    pkg_loginfo("> Watching for posts in %s", posts_path)
    pkg_loginfo("> Site path is %s", site_path)
    
    while (TRUE) {
        watch_posts(posts_path, site_path)
    }
}

#' Create new post in `posts` folder
#'
#' @param post_title is post tile
#' @param post_author is post author
#' @param post_date is post date
#' @param posts_path is a path where post is to be created
#' @param skip_rc is a boolean flag to control whether add post projet to VC or not.
#' 
#' @export
new_post <- function(post_title,
                     post_author,
                     post_date,
                     posts_path,
                     skip_rc = FALSE) {
    post_slug <- build_slug(post_title)
    
    post_prj_name <- sprintf("%s-%s",
                             post_date,
                             post_slug)

    post_prj <- RSuite::prj_start(name = post_prj_name,
                                  path = posts_path,
                                  tmpl = "blog-post",
                                  skip_rc = skip_rc)
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

}
