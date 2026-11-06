# Hokusai 2 needs libvips 8.16 or newer, which Ubuntu 24.04 does not ship (it has 8.15).
# This image builds libvips from a release tarball in the build stage and copies it to a slim runtime.

# ---- build ----------------------------------------------------------------
FROM swift:6.2-noble AS build
ARG VIPS_VERSION=8.16.1

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential meson ninja-build pkg-config curl xz-utils ca-certificates \
      libglib2.0-dev libexpat1-dev libjpeg-turbo8-dev libpng-dev libwebp-dev libtiff-dev \
      libheif-dev libcairo2-dev libpango1.0-dev libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz" | tar -xJ -C /tmp \
    && cd "/tmp/vips-${VIPS_VERSION}" \
    && meson setup build --prefix=/opt/vips --libdir=lib --buildtype=release \
         -Dintrospection=disabled -Dmodules=disabled -Dexamples=false \
    && meson install -C build \
    && rm -rf /tmp/vips-*

ENV PKG_CONFIG_PATH=/opt/vips/lib/pkgconfig
WORKDIR /src
COPY app/ .
RUN swift build -c release --product Resizer

# ---- runtime --------------------------------------------------------------
FROM ubuntu:noble
RUN apt-get update && apt-get install -y --no-install-recommends \
      libglib2.0-0t64 libexpat1 libjpeg-turbo8 libpng16-16t64 libwebp7 libwebpmux3 libwebpdemux2 libtiff6 \
      libheif1 libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libfontconfig1 \
      fonts-dejavu-core ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /opt/vips /opt/vips
COPY --from=build /usr/lib/swift/linux/*.so* /usr/lib/swift/linux/
COPY --from=build /src/.build/release/Resizer /usr/local/bin/resizer
ENV LD_LIBRARY_PATH=/opt/vips/lib:/usr/lib/swift/linux
RUN useradd --system --create-home app
USER app
ENTRYPOINT ["resizer"]
