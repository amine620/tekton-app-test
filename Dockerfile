# Use an official Node.js runtime as a parent image
FROM node:18-alpine

USER 0
# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# Use a smaller NGINX image to serve the static files
FROM nginx:alpine
USER 0

# Copy the build files from the previous stage to the NGINX directory
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
