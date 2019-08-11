find_changed_posts <- function(posts_path) {
    posts_dirs <- normalizePath(list.dirs(path = "../posts",
                                          recursive = FALSE,
                                          full.names = TRUE))

    posts_dirs <- Filter(x = posts_dirs,
                        f = is_post_project)

    posts_dirs <- Filter(x = posts_dirs,
                         f = is_changed_post_project)

    posts_dirs <- sapply(X = posts_dirs,
                         FUN = function(d) {
                             file.path(d, "R", "post.Rmd")
                         },
                         USE.NAMES = FALSE)
    return(posts_dirs)
}

is_post_project <- function(post_dir) {
    file.exists(file.path(post_dir, "R", "post.Rmd"))
}


is_changed_post_project <- function(post_dir) {
    rmd_mtime <- as.integer(file.mtime(file.path(post_dir, "R", "post.Rmd")))
    md_mtime <- as.integer(file.mtime(file.path(post_dir, "R", "post.md")))

    pkg_logdebug("--> post_dir: %s [rmd_mtime:%s, md_mtime:%s]",
                 post_dir,
                 rmd_mtime,
                 md_mtime)

    return(!file.exists(file.path(post_dir, "R", "post.md")) | md_mtime < rmd_mtime)
}
