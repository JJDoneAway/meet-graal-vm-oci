# Using Oracle GraalVM for JDK 17
FROM container-registry.oracle.com/graalvm/native-image:21-ol8 AS builder

# Set the working directory to /home/app
WORKDIR /build

# Install necessary tools
RUN microdnf install -y gzip tar && microdnf clean all

# Copy the source code into the image for building
COPY . /build

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Build
RUN ./mvnw --no-transfer-progress native:compile -Pnative

# The deployment Image
FROM container-registry.oracle.com/os/oraclelinux:8-slim

EXPOSE 8080

# Copy the native executable into the containers
COPY --from=builder /build/target/meetgraalvm app
ENTRYPOINT ["/app"]
