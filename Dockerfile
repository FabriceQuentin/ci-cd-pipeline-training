# Utiliser l'image Maven officielle comme image de construction
FROM maven:3.8.5-openjdk-17-slim AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances
COPY pom.xml .

# Télécharger les dépendances sans construire le projet (cela optimise le cache Docker)
RUN mvn dependency:go-offline

# Copier tout le code source du projet dans le conteneur
COPY src ./src

# Construire le projet Maven
RUN mvn clean package -DskipTests

# Utiliser l'image JDK officielle comme image d'exécution
FROM openjdk:17-jdk-slim

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier l'artefact de construction du conteneur précédent
COPY --from=build /app/target/*.jar app.jar

# Spécifier le port d'écoute de l'application
EXPOSE 8081

# Démarrer l'application Java
ENTRYPOINT ["java", "-jar", "app.jar"]


