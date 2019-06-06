# Kamran's bogdemo.wbitt.com wordpress website
This is the simplest way to bring up a wordpress website, using witline (now witpass) wordpress image. You do not need anything fancy in this repository.

## Features:
* Ability to deploy a wordpress website in *immutable* way.
* Plugins and themes are not stored in persistent storage.
* Plugins and themes are specified as configuration.
* The only piece of data, you need to keep persistent - and take backup of - is the `wp-content/uploads` directory.

**Note:** You are not stopped from experimenting with themes and plugins of your choice. You can install them through the WordPress admin panel of your website, **but** any plugins and themes installed this way will not survive container restart. After your experimentation, you add the plugin(s) and themes(s) of your choice in the related config files in this repository.

# Repository structure:

```
$ tree 
.
├── app.env
├── app.env.example
├── custom-git-issues.sh
├── docker-compose.yml -> docker-compose.server.yml
├── docker-compose.devpv.yml
├── docker-compose.server.yml
├── Dockerfile
├── docs
├── plugins
│   ├── download.list
│   ├── gitrepos.list
│   └── README.md
└── themes
    ├── download.list
    ├── gitrepos.list
    └── README.md

3 directories, 13 files
[kamran@kworkhorse example.com]$
```

# Persistent storage directory structure on your local/development computer:

```
[kamran@kworkhorse ~]$ mkdir -p /home/kamran/tmp/example.com/uploads 
[kamran@kworkhorse ~]$ mkdir -p /home/kamran/tmp/example.com/mysql-data-dir
[kamran@kworkhorse ~]$ chmod 1777 /home/kamran/tmp/example.com/mysql-data-dir
```

```
[kamran@kworkhorse ~]$ ls -l /home/kamran/tmp/example.com/ 
total 8
drwxrwxrwt 2 kamran kamran 4096 Apr  2 21:53 mysql-data-dir
drwxr-xr-x 3 kamran kamran 4096 Apr  2 21:44 uploads
[kamran@kworkhorse tmp]$ 
```

Here is how it looks like:
```
[kamran@kworkhorse ~]$ pwd
/home/kamran

[kamran@kworkhorse ~]$ tree /home/kamran/tmp/example.com/ -L 1
/home/kamran/tmp/example.com/
├── mysql-data-dir
└── uploads
```


# Configuring plugins and themes:
* Use `plugins/download.list` to specify the name and URL of the zip file for the plugin
* Use `plugins/gitrepo.list` to specify the name and URL of the git repository for the plugin. This also needs `GITHUB_USER` and `GITHUB_TOKEN` to be passed to the container.
* Use `themes/download.list` to specify the name and URL of the zip file for the theme
* Use `themes/gitrepo.list` to specify the name and URL of the git repository for the theme. This also needs `GITHUB_USER` and `GITHUB_TOKEN` to be passed to the container. 


# How to use this image:
* Clone this repository on your computer, and save it with the name of the website you are going to setup, e.g. `example.com` . 
 * **Note:** As soon as you are done cloning, remove the `.git/` directory completely from inside of this newly created directory. **This is mandatory.**. The `.git` directory contains the references to the original repository, and if you make changes, and do a `git push` , you will be actually pushing to the source repository ,which is not what we want you to do.  
 * You can make copies of this repository on your local computer by using operating system's copy commands. In that case too, you will need to immediately delete the `.git/` directory from inside of the newly created directories.
* Setup a MySQL database to hold this site's database stuff, and/or keep the DB credentials handy. There are several ways to do it. To ease development, the `docker-compose.devpv.yml` file contains a mysql service definition. Just adjust the path of persistent storage for mysql and use that as test mysql db for wordpress.
* Setup a persistent storage on the computer to hold this website's **uploads** . This location will be specified in `docker-compose.devpv.yml` and/or `docker-compose.server.yml` files, and will be mounted at `/var/www/html/wp-content/uploads` when the container is started using `docker-compose up -d` command. An example of this directory is: `/home/kamran/tmp/example.com/uploads` . You will need to make sure that you do a frequent backup of this location.
* If you intend to download any custom plugins or themes which are actually in a private fit repository, then you need to provide your github username and a github token. You can create a github token just for this specific person against your github user. If you don't then you do not need to provide github_user or github_token. 
* Find the id of the OS user you are logged in as on your computer. This will be used to set correct ownership and permissions for the `uploads` directory.
* Create `app.env` by copying `app.env.example` file. 
* Adjust `app.env` with the environment variables related to this particular website.
* Make sure that you adjust `docker-compose.devpv.yml` file with correct values, while you are working on your local computer. The person who is deploying this website on the server is responsible for adjusting `docker-compose.server.yml` according to the setup/environment in the server.
* Also ensure that the name resolution/DNS is in place. On your local computer you can use `/etc/hosts` , but for setup to work on the server, the website/domain should have correct DNS settings in the related domain registrar.
 
Bring up the image using:
```
$ docker-compose -f docker-compose.devpv.yml build --no-cache
$ docker-compose -f docker-compose.devpv.yml up -d
```
**Note:** It is important to **build** the image *before* bringing it **up**. It is also important to use the `--no-cache` option when building the image.

Check status of the container:
```
$ docker-compose -f docker-compose.devpv.yml ps

or

$ docker ps
```

Check logs:
```
$ docker-compose -f docker-compose.devpv.yml logs -f

or

$ docker logs -f <container-name|container-id>
```

Stop container and remove container image using `docker-compose`:
```
$ docker-compose -f docker-compose.devpv.yml stop  <container-name|container-id> 
$ docker-compose -f docker-compose.devpv.yml rm -f  <container-name|container-id> 
```


# Environment variables:
* Use `app.env` file to pass environment variables to the docker-compose application. This file is part of `.gitignore` and must remain so.
* Ensure that you encode your git token with 
base64 before placing it in `app.env` . Here is how you can convert your git token into base64 representation:

```
$ MY_GITHUB_TOKEN='yourgithubtokenyouobtainedfromgithub'
$ echo ${MY_GITHUB_TOKEN} | base64 -w 0 
```

Copy the output of the last echo command and paste it in `app.env` for the GITHUB_TOKEN variable. **Note:** GITHUB_USER is not encoded with base64.


Here is what the `app.env` file looks like:
```
$ cat app.env
WORDPRESS_DB_HOST=db.example.com
WORDPRESS_DB_NAME=db_sitename
WORDPRESS_DB_USER=user_sitename
WORDPRESS_DB_PASSWORD=secret
WORDPRESS_TABLE_PREFIX=wp_
APACHE_RUN_USER=#1000
APACHE_RUN_GROUP=#1000
GITHUB_USER=kamran
GITHUB_TOKEN=base64encodedgithubtoken
```

# General advice for security and performance:
* Only use plugins and themes which are well reputed.
* Fancy looks are always **less important** than security and performance.
* If a plugin or theme increases CPU or memory utilization, then you should not use it.
