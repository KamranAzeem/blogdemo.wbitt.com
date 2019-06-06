This directory will contain:
* custom themes which we need to place inside the main wordpress Docker container before it starts. Each custom theme will be in it's own subdirectory.
* list of publicly available themes which we need to install in our wordpress container. It needs to contain Name of the plugin and the exact URL to download it in the file called `downloadable-themes.list` . The format of the 'download.list' file is that it must have total two columns. A theme name and the URL. If theme name is multiword (`Jet Pack`), then make sure that you remove all spaces in the name of the theme, and make it as `JetPack`. 
* Make sure that the URL is the link to actual zip file, normally found under the blue `Download` button on wordpress website.

Here is an example of download.list file:
```
$ cat themes/download.list

# Format of this file is:
# PluginName   	URL
OceanWP       	https://downloads.wordpress.org/theme/oceanwp.1.6.4.zip
```
