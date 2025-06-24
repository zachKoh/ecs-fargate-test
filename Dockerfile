# Stage 1: Build Angular app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install deps
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

# Copy source code
COPY . .

# Build Angular app
RUN npm run build -- --configuration=production

# Stage 2: Serve Angular app
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built Angular app from builder stage
COPY dist/angular-conduit/browser/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]