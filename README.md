# wlogdown
Reproducible blogging framework for R

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Initialize framework](#initialize-framework)
    - [External tools](#external-tools)
    - [R Suite templates](#r-suite-templates)
    - [Blogger tool](#blogger-tool)
- [Using framework](#using-framework)
    - [Starting hugo](#starting-hugo)
    - [Starting blogger daemon](#starting-blogger-daemon)
    - [Adding new post](#adding-new-post)
    - [Editing post](#editing-post)
        - [Adding custom images](#adding-custom-images)

<!-- markdown-toc end -->


## Initialize framework ##

### External tools ###

1. Download and install [hugo](https://gohugo.io/)
2. Download and install [pandoc](https://pandoc.org/)

### R Suite templates ###

Register `blog-post` template running command (from `wlogdown` folder)

```
rsuite tmpl register -p blog-post
```

### Blogger tool ###

`blogger` is a tool to manage your blog. To initalize it run the following commands

```
cd blogger
rsuite proj depsinst
rsuite proj build
```

## Using framework ##

### Starting hugo ###

When writing posts it is convenient to run hugo in backround. You can do this running the following command

```
cd site
hugo server --disableFastRender -D
```

Now you can peek your blog using link <http://localhost:1313>.

### Starting blogger daemon ###

`blogger` can be run in a server mode to watch for any changes you make to your posts (in folder `posts`) and moves them to hugo's site. To run the daemon use the command

```
cd blogger
Rscript R\server.R
```

### Adding new post ###

To add a new post run the following command

```
cd blogger
Rscript R\new_post.R --title="Your post title" --author="Your Name"
```

It takes a while to add a new post due to dependency installation. After you are finished you can start editing your post.

### Editing post ###

Your posts are stored in `posts` folder. Each post project is a R Suite project. 

**Remark** it is mandatory to name post as `post.Rmd` file to have a project recognized as blog post project.

#### Adding custom images ####

When writing blog in `Rmd` format you can generate images using R plot capabilities. Sometimes you might want to add external image. *wlogdown* assumes that all images used in a post are kept in `posts\<Your post>\R\img` folder. To add your image, just copy it to this folder.

To reference image you can use template `![<Image description>](img/<Image filename)`.
