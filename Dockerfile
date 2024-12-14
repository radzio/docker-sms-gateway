FROM debian:bookworm-slim

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gammu \
    gammu-smsd \
    nodejs \
    npm \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

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