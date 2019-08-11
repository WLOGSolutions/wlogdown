build_slug <- function(title) {
    gsub(pattern ="-$",
         replacement = "",
         x = tolower(gsub(pattern = "[[:blank:]|[:punct:]]",
                          replacement = "-",
                          title)))
}
