This directory will contain:
* custom plugins which we need to place inside the main wordpress Docker container before it starts. Each custom plugin will be in it's own subdirectory.
* list of publicly available plugins which we need to install in our wordpress container. It needs to contain Name of the plugin and the exact URL to download it in the file called `downloadable-plugins.list` . The format of the 'download.list' file is that it must have total two columns. A plugin name and the URL. If plugin name is multiword (`Contact Form 7`), then make sure that you remove all spaces in the name of the plugin, and make it one word, e.g.  `ContactForm7` or `Contact-Form-7`.  
* Make sure that the URL is the link to actual zip file, normally found under the blue `Download` button on wordpress website.

Here is an example of the download.list file:
```
$ cat plugins/download.list

# Format of this file is:
# PluginName	URL

WooCommerce    	https://downloads.wordpress.org/plugin/woocommerce.3.5.7.zip
```
