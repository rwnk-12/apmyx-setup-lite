FROM --platform=linux/amd64 debian:13.2 AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates cmake curl git unzip \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN curl -fSL https://dl.google.com/android/repository/android-ndk-r23b-linux.zip -o /tmp/ndk.zip \
    && unzip -q /tmp/ndk.zip -d /app && rm /tmp/ndk.zip
COPY . /app
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_HOST_LAUNCHERS=ON \
    && cmake --build build --target wrapper_lite_exe -j2
FROM --platform=linux/amd64 debian:13.2
WORKDIR /app
COPY --from=build /app/wrapper-lite /app/wrapper-lite
COPY --from=build /app/rootfs/system /app/rootfs/system
COPY --from=build /etc/ssl/certs/ca-certificates.crt /app/rootfs/etc/ssl/certs/ca-certificates.crt
COPY apmyx-login.sh /app/apmyx-login.sh
RUN chmod +x /app/wrapper-lite /app/rootfs/system/bin/* /app/apmyx-login.sh \
    && mkdir -p /app/rootfs/data
ENTRYPOINT ["/app/wrapper-lite"]
CMD ["--base-dir", "/data", "--host", "0.0.0.0", "--port", "12340"]
