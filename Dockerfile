FROM docker.io/rust:1.91-slim AS builder
RUN rustup target add wasm32-unknown-unknown
RUN cargo install trunk
WORKDIR /app
COPY . .
RUN trunk build --release
FROM docker.io/nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]
