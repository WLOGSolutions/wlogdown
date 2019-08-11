#' Main function that continuosly watches posts dir for changes and renders posts
#' 
#' @param posts_path folder(s) to watch for posts
#' @param site_path folder where hugo's site is localized
#'
#' @export
update_posts <- function(posts_path, site_path) {
    pkg_loginfo("> Watching for posts in %s", posts_path)
    pkg_loginfo("> Site path is %s", site_path)
    
    while (TRUE) {
        do_update_posts(posts_path, site_path)
    }
}

do_update_posts <- function(posts_path, site_path) {
    changed_posts <- find_changed_posts(posts_path)

    if (length(changed_posts) > 0) {
        pkg_loginfo("--> found %d changed posts in %s",
                    length(changed_posts),
                    posts_path)
    }

    render_posts(changed_posts,
                 hugo_dir = site_path)

    later::later(func = do_update_posts,
                 delay = 3)
}
