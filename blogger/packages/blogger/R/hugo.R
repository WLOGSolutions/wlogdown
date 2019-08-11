get_hugo_static <- function(hugo_dir) {
    normalizePath(file.path(hugo_dir, "static"))
}

get_hugo_posts <- function(hugo_dir) {
    hugo_posts <- normalizePath(file.path(hugo_dir, "content", "post"))
    hugo_posts
}

get_hugo_post_dir <- function(hugo_dir, post_dir_name) {
    normalizePath(file.path(get_hugo_posts(hugo_dir),
                            post_dir_name))
}


