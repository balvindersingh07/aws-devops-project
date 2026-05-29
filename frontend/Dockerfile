FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .

EXPOSE 3000

ENV BACKEND_URL=http://backend:5000

CMD ["node", "server.js"]
