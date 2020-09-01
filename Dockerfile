# Run image
FROM tomcat:9.0-jdk11-slim 
RUN apt-get update && apt-get upgrade -y
RUN apt-get install tzdata -y
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Connectors Java
ENV URL_JDBC="https://jdbc.postgresql.org/download"

ENV POSTGRES_CONN_J postgresql-42.1.4.jar
ENV POSTGRES_CONN_J_URL $URL_JDBC/$POSTGRES_CONN_J

RUN apt-get install wget -y
RUN wget -c $POSTGRES_CONN_J_URL -O /usr/local/tomcat/lib/$POSTGRES_CONN_J

# COPY context.xml /usr/local/tomcat/conf/context.xml
COPY deployment/context.xml.template /usr/local/tomcat/conf/context.xml.template
COPY deployment/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY deployment/manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY deployment/logs.xml /usr/local/tomcat/conf/Catalina/localhost/logs.xml
COPY deployment/dev/.env /usr/local/tomcat/conf/dev.env
COPY deployment/stage/.env /usr/local/tomcat/conf/stage.env
COPY deployment/production/.env /usr/local/tomcat/conf/production.env
COPY deployment/local/.env /usr/local/tomcat/conf/local.env

COPY deployment/populate_env.sh /usr/local/tomcat/populate_env.sh
COPY deployment/boot_catalina_with_properties.sh /usr/local/tomcat/boot_catalina_with_properties.sh

COPY build/libs/us-election-backend*.war /usr/local/tomcat/logs/version.zip
COPY build/libs/us-election-backend*.war /usr/local/tomcat/webapps/us-election-backend.war
EXPOSE 8080
CMD ["/usr/local/tomcat/boot_catalina_with_properties.sh"]
