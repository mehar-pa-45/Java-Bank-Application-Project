# ---------- Stage 1: Build React App ----------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Fix permission for react scripts
RUN chmod +x node_modules/.bin/react-scripts

# Build React app
RUN npm run build


# ---------- Stage 2: Nginx ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
