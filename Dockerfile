FROM witline/wordpress:5.2.4-php-7.3-apache-2.4

# Copy themes and plugins from the repository to a fixed place inside the container image.
# The themes and plugins will be processed by the our wordpress-custom-entrypoint.sh script,
#   when the container starts.
COPY themes /usr/src/themes/
COPY plugins /usr/src/plugins/ 

