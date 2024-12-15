FROM debian:bookworm-slim

# Install required packages and set up locale
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gammu \
    gammu-smsd \
    nodejs \
    npm \
    curl \
    jq \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set locale environment variables
ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8

# Create necessary directories
RUN mkdir -p /var/log/gammu-smsd \
    && mkdir -p /var/spool/gammu-smsd/{inbox,outbox,sent,error} \
    && mkdir -p /etc/gammu-smsd \
    && mkdir -p /scripts

# Copy configuration files
COPY gammu-smsdrc /etc/gammu-smsd/
COPY app.js /app/
COPY package.json /app/

# Set working directory
WORKDIR /app

# Install Node.js dependencies
RUN npm install

# Create volume for received SMS handler script
VOLUME /scripts

# Expose API port
EXPOSE 3000

# Copy and set up the startup script
COPY start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]