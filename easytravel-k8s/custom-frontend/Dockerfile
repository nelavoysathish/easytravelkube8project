FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy our customized webapp
COPY webapp /usr/local/tomcat/webapps/ROOT

# Set environment variables
ENV JAVA_OPTS="-Xmx525m"

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
