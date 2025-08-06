#!/bin/bash

APP_NAME="devops-eval"
IMAGE_NAME="devops-eval-image"
PORT=8080

echo "🔍 Verificando si Docker está instalado..."
if ! command -v docker &> /dev/null; then
  echo "Docker no está instalado. Por favor, instálalo para continuar."
  exit 1
fi
echo "Docker está instalado."

echo "🔧 Construyendo la imagen Docker..."
if docker build -t $IMAGE_NAME .; then
  echo "Imagen '$IMAGE_NAME' construida correctamente."
else
  echo "Fallo al construir la imagen."
  exit 1
fi

echo "Ejecutando contenedor '$APP_NAME' en segundo plano..."
docker run -d --rm -p $PORT:$PORT \
  -e PORT=$PORT \
  -e NODE_ENV=production \
  --name $APP_NAME $IMAGE_NAME

# Esperar unos segundos para que arranque la app
sleep 3

echo "Probando el endpoint /health..."
if curl -s http://localhost:$PORT/health | grep -q "OK"; then
  echo "La aplicación responde correctamente en http://localhost:$PORT"
  echo "Contenerización y verificación completadas con éxito."
else
  echo "La aplicación no respondió correctamente."
  echo "Logs del contenedor:"
  docker logs $APP_NAME
  docker stop $APP_NAME
  exit 1
fi
