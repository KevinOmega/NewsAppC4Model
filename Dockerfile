# Usa la imagen base de Structurizr Lite
FROM structurizr/lite

# Descarga el plugin de PlantUML y lo agrega al directorio de plugins
# ADD https://github.com/structurizr/dsl-plugins/releases/download/v1.0.0/structurizr-dsl-plugin-plantuml-1.0.0.jar /usr/local/structurizr/plugins/

# Exponer el puerto 8080 para el servidor
EXPOSE 8080