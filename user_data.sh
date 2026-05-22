#!/bin/bash
# 1. Esperar inicialización del sistema e instalar Apache
sleep 10
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

# 2. Obtener metadatos con el comando oficial de AWS formateado correctamente
INSTANCE_ID=$(sudo ec2-metadata --instance-id | awk '{print $2}')
HOSTNAME=$(hostname)

# 3. Validar en caso de que falle la lectura
if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" = "com" ]; then
  INSTANCE_ID="i-error-lectura"
fi

# 4. Crear el sitio web index.html
cat > /var/www/html/index.html << ENDOFHTML
<html>
<body style="font-family: Arial; text-align: center; padding: 50px;">
  <h1>EC2 Web Server</h1>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <p><strong>Hostname:</strong> $HOSTNAME</p>
</body>
</html>
ENDOFHTML
