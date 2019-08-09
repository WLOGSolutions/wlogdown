
---
title: Reproducibility with R? Tell me about your workflow first.
author: Wit Jakuczun
date: 2019-08-09
slug: reproducibility-with-r--tell-me-about-your-workflow-first
categories:
  - rsuite
  - rstats
tags:
  - rsuite
  - rstats
  - reproducibility
  - enterprise
blogdown::html_page:
    toc: true
    toc_depth: 1
    number_sections: true
    fig_width: 6
    self_contained: false
---

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Load packages](#load-packages)
    - [External packages](#external-packages)
    - [Custom packages](#custom-packages)
- [This is blog post template](#this-is-blog-post-template)
    - [Call custom package](#call-custom-package)
    - [Plot](#plot)
    - [Extra text](#extra-text)
    - [Emoticons](#emoticons)
    - [Sysinfo](#sysinfo)

<!-- markdown-toc end -->


# Load packages

## External packages ##


```r
library(data.table)
```

```
## Warning: package 'data.table' was built under R version 3.6.1
```

```r
library(mgcv)
```

```
## Warning: package 'mgcv' was built under R version 3.6.1
```

```
## Loading required package: nlme
```

```
## Warning: package 'nlme' was built under R version 3.6.1
```

```
## This is mgcv 1.8-28. For overview type 'help("mgcv-package")'.
```
I just loaded external pkgs.

## Custom packages ##


```r
library(postpkg)
```
I just loaded custom pkg.

# This is blog post template

## Call custom package ##

I can call a custom function `hello` from a custom pkg `postpkg`.


```r
postpkg::hello("World!")
```

```
## [1] "Hello World!"
```

This is an exemplary text

## Plot

```r
plot(1:30)
```

![](/img/2019-08-09-reproducibility-with-r--tell-me-about-your-workflow-first/reproducibility-with-r--tell-me-about-your-workflow-first-simple_plot-1.png)<!-- -->


```r
plot(seq(from = -pi, to = pi, by = 0.1),
     cos(seq(from = -pi, to = pi, by = 0.1)))
```

![](/img/2019-08-09-reproducibility-with-r--tell-me-about-your-workflow-first/reproducibility-with-r--tell-me-about-your-workflow-first-unnamed-chunk-2-1.png)<!-- -->


```r
image(volcano)
```

![](/img/2019-08-09-reproducibility-with-r--tell-me-about-your-workflow-first/reproducibility-with-r--tell-me-about-your-workflow-first-volcano_plot-1.png)<!-- -->

## Extra text

This is extra text.
This is another extra text.

This is one more extra text.
This is one more additional extra text.

## Emoticons

:smile:

## Sysinfo


```r
Sys.info()
```

```
##        sysname        release        version       nodename        machine 
##      "Windows"       "10 x64"  "build 18945"      "WLOG-WJ"       "x86-64" 
##          login           user effective_user 
##  "WitJakuczun"  "WitJakuczun"  "WitJakuczun"
```


```r
.libPaths()
```

```
## [1] "D:/Workplace/Projects/WLOGSite/trunk/wlogblog/posts/2019-08-09-reproducibility-with-r--tell-me-about-your-workflow-first/deployment/sbox"
## [2] "D:/Workplace/Projects/WLOGSite/trunk/wlogblog/posts/2019-08-09-reproducibility-with-r--tell-me-about-your-workflow-first/deployment/libs"
## [3] "D:/Workplace/Tools/R/R-3.6.0/library"
```
