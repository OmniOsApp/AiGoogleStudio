# ---------- BUILD ----------
FROM node:18-alpine AS build
WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app .
RUN npm run build

# ---------- PRODUCTION ----------
FROM nginx:alpine

# LIMPA QUALQUER CONTEÚDO ANTIGO (CRÍTICO)
RUN rm -rf /usr/share/nginx/html/*

# Remove config padrão
RUN rm /etc/nginx/conf.d/default.conf

# Config SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia build FINAL do Vite
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
