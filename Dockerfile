# #stage 1
# FROM node:20-alpine as node
# WORKDIR /app
# COPY . .
# RUN npm install --force
# CMD ["npm", "run", "build"]

# #stage 2
# FROM nginx:alpine
# ARG name
# COPY --from=node /app/dist/vertex-ems/browser /usr/share/nginx/html

# Stage 1: Build the Angular application
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install --force
COPY . .
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine
# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
# Copy built Angular app from builder stage
COPY --from=builder /app/dist/cicd/browser/ /usr/share/nginx/html/
# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
