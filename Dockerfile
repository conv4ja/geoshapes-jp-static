FROM httpd:alpine
ADD src/ /usr/local/apache2/htdocs
RUN ln -sf version /usr/local/apache2/htdocs/index.html
