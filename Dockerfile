# -------- Stage 1 : Build WAR using Maven --------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# copy project files
COPY . .

# build war file
RUN mvn clean package -DskipTests


# -------- Stage 2 : Run application using Tomcat --------
FROM tomcat:9-jdk17

# remove default tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# copy war from build stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]
