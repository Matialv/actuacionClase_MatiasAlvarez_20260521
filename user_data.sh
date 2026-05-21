#!/bin/bash
# Actualizar repositorios e instalar Apache usando dnf (nativo de AL2023)
dnf update -y
dnf install -y httpd

# Iniciar y habilitar el servicio de Apache
systemctl start httpd
systemctl enable httpd

# Obtener Token IMDSv2 con tiempo de espera (timeout) para evitar bloqueos
TOKEN=$(curl -s -X PUT "http://169.254.169" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" --connect-timeout 5)

# Validar si obtuvimos el token antes de pedir las variables
if [ -n "$TOKEN" ]; then
  INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169 --connect-timeout 5)
  HOSTNAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169 --connect-timeout 5)
else
  INSTANCE_ID="Unknown-AL2023"
  HOSTNAME=$(hostname)
fi

# Crear el sitio web
cat > /var/www/html/index.html << ENDOFHTML
<html>
<body style="font-family: Arial; text-align: center; padding: 50px;">
  <h1>EC2 Web Server</h1>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <p><strong>Hostname:</strong> $HOSTNAME</p>
</body>
</html>
ENDOFHTML
