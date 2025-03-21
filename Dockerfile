# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:1.25.3-alpine3.21  # Use a specific Alpine version for compatibility
COPY --from=build /app/dist /usr/share/nginx/html

# Uncomment if you need a custom Nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Install libxml2 correctly without updating all packages
RUN apk add --no-cache libxml2
