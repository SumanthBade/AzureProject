FROM node:18

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Install dependencies
RUN npm install

# Expose the port your app listens on
EXPOSE 3030

# Start the app
CMD ["npm", "start"]
