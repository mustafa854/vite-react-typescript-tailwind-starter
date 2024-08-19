# Base image
FROM node:18-alpine AS base
WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

ARG ENV=production
RUN if [ "$ENV" = "development" ]; then npm install; else npm ci --only=production; fi

COPY . /app

# Stage for production builds
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=base /app /app

# Set environment variable for production
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000
CMD [ "npm", "start" ]