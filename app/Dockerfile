# Stage 1: Build the application
FROM node:14 AS builder

WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the application source code to the container
COPY . .

# # Build the application (you can add any necessary build steps here)
# RUN npm run build --if-present

# Stage 2: Create the production image
FROM node:14-alpine

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder app/package*.json .

COPY . /app
# Install only production dependencies
RUN npm install --only=production

# Define the command to run your application
CMD [ "node", "app.js" ]

# Expose the port your application listens on
EXPOSE 3000