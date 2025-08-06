# Imagen base ligera de Node.js
FROM node:20-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copia solo los archivos necesarios para instalar dependencias
COPY package*.json ./

# Instala dependencias + correcciones de seguridad
RUN npm install \
    && npm audit fix --force

# Copia el resto de los archivos
COPY . .

# Variables de entorno obligatorias según la rúbrica
ENV PORT=8080
ENV NODE_ENV=production

# Expone el puerto especificado
EXPOSE 8080

# Comando por defecto
CMD ["node", "app.js"]
