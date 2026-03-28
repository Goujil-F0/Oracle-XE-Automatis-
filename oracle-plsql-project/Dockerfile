# Dockerfile
FROM gvenzl/oracle-xe:21-slim-faststart

# Variables d'environnement (valeurs par défaut)
ENV ORACLE_PASSWORD=${ORACLE_PASSWORD}
ENV APP_USER=${APP_USER}
ENV APP_USER_PASSWORD=${APP_USER_PASSWORD}

# Créer un répertoire pour les logs
RUN mkdir -p /opt/oracle/logs

# Copier les scripts SQL (ils seront exécutés automatiquement)
COPY ./scripts/*.sql /container-entrypoint-initdb.d/

# Rendre les scripts exécutables
RUN chmod +x /container-entrypoint-initdb.d/*.sql

EXPOSE 1521 5500