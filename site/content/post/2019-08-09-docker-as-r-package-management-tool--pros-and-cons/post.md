
---
title: Docker as R package management tool? Pros and cons.
author: Wit Jakuczun
date: 2019-08-09
slug: docker-as-r-package-management-tool--pros-and-cons
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
# Table of Contents

- [What is Docker?](#what-is-docker)
- [A Docker workflow for dummies](#a-docker-workflow-for-dummies)
- [What has happened with my ad-hoc installed packages?](#what-has-happened-with-my-ad-hoc-installed-packages)
- [Why Dockerfile is preferred to image commits?](#why-dockerfile-is-preferred-to-image-commits)
- [Is Docker an answer for R packages dependency hell?](#is-docker-an-answer-for-r-packages-dependency-hell)
- [Where should I develop my R code?](#where-should-i-develop-my-r-code)
- [What is a deployment procedure when you work with Docker?](#what-is-a-deployment-procedure-when-you-work-with-docker)
- [How does R Suite supports Docker?](#how-does-r-suite-supports-docker)
    - [Deployment without docker](#deployment-without-docker)
    - [Building docker image for solution](#building-docker-image-for-solution)
    - [Support for custom images](#support-for-custom-images)
- [Conclusion](#conclusion)

<!-- markdown-toc end -->


# What is Docker?

[Docker](https://www.docker.com/) tries to address infamous “it works for me” problem. The cause of this problem are hidden dependencies on you dev system
settings that you forgot to configure on a production environment. It is based on a [container concept](https://www.docker.com/what-container) as presented on
the diagram below. A container encapsulates all dependencies needed to run your application: code, runtime, system tools, system libraries, settings. 

# A Docker workflow for dummies

Using docker is like having a new set of laptops for each project with preconfigured OS. This is great if you want to have your work reproducible. To have a
container that suits your needs a typical approach is like in the steps below:

1. Take any base image from e.g. [Docker Hub](https://hub.docker.com/), like [rocker/r-base
   image](https://hub.docker.com/r/rocker/r-base/) with base R installed on Ubuntu Linux.
1. Write a Dockerfile like in this [tutorial](https://docs.docker.com/get-started/part2/#your-new-development-environment) with proper R packages and other
   tools your R application need. 
1. Build your image using just created Dockerfile

Now you have a new image that contains a brand new “laptop” with everything you need to run your application. If you do not feel to really understand what
Docker is I recommend their official [docs site](https://docs.docker.com/get-started/ "Docker's docs site").


# What has happened with my ad-hoc installed packages?

The workflow I have just described forces you to think about all packages you need for your project in advance. This is because **Docker images are persistent
but containers are not.** This means that as soon as you create a container and modify it (e.g. change a file), this modification will exist until you restart
your container. The result is that **working with containers is not reproducible** unless you commit the change and generate a new image.

***

This means that whenever during your development cycle you decide to add a new package you have to do it twice: in a container and in a Dockerfile. Not very
comfortable but this is the only way to keep your work reproducible. By the way this is a general way of developing a software.

# Why Dockerfile is preferred to image commits?

Because we want to have a real reproducibility. Docker image with many ad-hoc commits is not reproducible. Imagine you wanted to upgrade the base image because
of security hole in an OS. How would you do this with your one year old Docker image with *one-one-remember-how-I-did-it* installed packages?

# Is Docker an answer for R packages dependency hell?

R packages are one of the strongest feature of R. There are now more than 10000 packages available on official [CRAN repository](https://cran.r-project.org/
"Official CRAN repository"). By default packages are installed either in user local folder or globally.

Both solutions are not robust. For example R Studio installs some packages when you want to use [Addins](https://rstudio.github.io/rstudioaddins/ "R Studio's Addins
feature") or [RMarkdown](http://rmarkdown.rstudio.com/ "RMarkdown") features. You might want not to be dependent on R Studio’s packages versions in your
project. Why? **For example, You might want to upgrade R Studio without affecting your project dependencies.**

Here I collected reasons for not using Docker for R packages management:

* you may want to isolate your app from system's R packages
* you may want to run a custom version of R but still keep the system's packages untouched
* you may need fine grain control on the packages installed for a specific app
* you may need to run multiple apps with different requirements.


We use [R Suite](http://rsuite.io "R Suite's homepage") for separating R project packages from R global packages. Later in the article we show how we integrated
[R Suite](http://rsuite.io "R Suite's homepage") and [Docker](https://docker.com "Docker homepage") to make containerized R apps less painful.

# Where should I develop my R code?

When I first met Docker this question was natural for me. And it is natural to answer - in the Docker’s container itself. It is possible when you use for
example [R Studio Server Community Edition](https://www.rstudio.com/products/rstudio/download-server/ "R Studio Server Community Edition") but **only for
Linux**. If you want to develop a code for a Windows it is not a choice.

What about persistency? Does it affect your code written via R Studio Server directly to a container? Yes it affects. **Any new file, including your source
code, you create in a running container will not be saved unless you commit all changes to a new image.** I have argued before that this is not the path you
want to follow :).

***

The solution could be to give access to host filesystem and this is according to my opinion the best approach. This means that any changes you make are written
on your laptop’s hard drive. When dealing with source code we recommend to use an external to a container source code version control system like
[Git](https://git-scm.com/ "Git homepage") or [Subversion](https://subversion.apache.org/ "Apache Subversion
homepage"). **This roughly  means that container is for OS reproducibility and not for the R project.**

# What is a deployment procedure when you work with Docker?

Suppose you wrote a [Shiny](https://shiny.rstudio.com/ "RStudio Shiny homepage") application and would like to share it with your customer. You do not really
want to send him your development image and ask for logging into R Studio to run the app, don’t you? Much better would be to share the production image that
automatically runs your app whenever a container is created. 

***

Simple answer to the question is -- it is the same as for any other setup. You have to ship an image with your app inside in a way that the consumer can use
it. To do this you have to decide **what is a production use case for your application**. In most cases production use cases are much different than development
use cases. **For example on production you do not need R Studio or development version of system libraries or compilers to build your packages**. In fact to decide on a
production use case you have to create completely new image simulating development environment with only requirements to run (not to develop!) your R
solution. In case of a Shiny app it would be a shiny server on production but not R Studio.

![*Deployment procedure converts development environment to a production environment. (Images taken from
[docker.com](https://docker.com)).*](/img/2019-08-09-docker-as-r-package-management-tool--pros-and-cons/2018-01-29-deployment_procedure_general.png)



# How does R Suite supports Docker?
I use [R Suite](http://rsuite.io "R Suite's homepage") for my everyday R software development tasks. I am using Windows 10 as my host system so I use Docker
whenever I have to develop for Linux (in most cases this is either Ubuntu/Debian or RedHat/CentOS). R Suite currently supports two scenarios (check [docpage
about Docker integration](http://rsuite.io/RSuite_Tutorial.php?article=rsuite_cli_reference.md#user-content-docker-integration) for more details): 

* Deployment without docker -- the production is not supporting docker
* Deployment with docker -- the production is supporting docker

Below we shortly describe both scenarios in details. What I get **out-of-the-box using R Suite and Docker** is:

* support for both docker and docker-less deployment
* the workflow is reproducible by design
* docker images are versioned accordingly to R Suite project
* easy integration with [CI](https://en.wikipedia.org/wiki/Continuous_integration)/[CD](https://en.wikipedia.org/wiki/Continuous_delivery) toolchain like
  [Jenkins](https://jenkins.io/). 
  

## Deployment without docker

Very often we use docker only to reproduce/simulate a production environment. This is important to test our R solutions before deployment on a production machine. 

***

When you want to share your R Suite project you [build a deployment package (as zip
file)](http://rsuite.io/RSuite_Tutorial.php?article=rsuite_cli_reference.md#building-deployment-package) out of it. The zip package contains everything, from R
perspective, you need to run the R application. R Suite uses Docker in the build procedure. The procedure starts a container using a standard image (currently
we support Ubuntu and CentOS.), transfers project into the container, builds it and retrieves the deployment zip file to the host system.

***

Having this zip file you can transfer it to production environment, unzip and run. This procedure can be done manually using Dockerfiles but we find this
automation very useful. 

![*Diagram showing how R Suite builds zip deployment package using Docker.*](/img/2019-08-09-docker-as-r-package-management-tool--pros-and-cons/2018-01-29-nondocker-deployment-procedure.png) 

## Building docker image for solution ##

Some of our customers use docker for deployment. In such situation I use R Suite to directly build production image with deployment version of R Suite
project. The resulting image is versioned accordingly to R project version and contains the solution ready for usage.

![*Diagram showing how R Suite builds production Docker image.*](/img/2019-08-09-docker-as-r-package-management-tool--pros-and-cons/2018-01-29-dockerbased-deployment-procedure.png) 

## Support for custom images ##

When building using docker (either zip or image) you can use you own image or our images (check here). You can also add extra commands that will be attached to
a Dockerfile before building the solution. 

# Conclusion

I have presented my point of view on using Docker for R software development. I have shown that Docker is a great solution but it can be tricky when
reproducibility is concerned. At last I have presented how R Suite makes using Docker for R development less painful.




