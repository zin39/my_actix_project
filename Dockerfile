# Stage 1: Build
FROM rust:1.71 as builder

WORKDIR /usr/src/my_actix_project

# Cache dependencies by copying only Cargo.toml and Cargo.lock
COPY Cargo.toml Cargo.lock ./

# Create a dummy source file to compile dependencies for caching
RUN mkdir src
RUN echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/my_actix_project*

# Copy the rest of the project and compile it
COPY . .
RUN cargo build --release

# Stage 2: Runtime image
FROM debian:buster-slim

# Install necessary system libraries (e.g., OpenSSL for Actix-Web/Diesel)
RUN apt-get update && \
    apt-get install -y libssl1.1 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin
COPY --from=builder /usr/src/my_actix_project/target/release/my_actix_project .

# Expose the application port (using the port specified in the .env file or default to 8080)
EXPOSE 8080

CMD ["./my_actix_project"]

