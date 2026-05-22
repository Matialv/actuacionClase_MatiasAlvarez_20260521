#!/bin/bash
# 1. Esperar a que la red y el sistema estén listos
sleep 10

# 2. Actualizar paquetes e instalar el servidor web Apache
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

# 3. Obtener metadatos reales usando la herramienta de AWS con privilegios sudo
# (Extrae el segundo parámetro de la respuesta de forma exacta)
INSTANCE_ID=$(sudo ec2-metadata -i | awk '{print $2}')
HOSTNAME=$(sudo ec2-metadata -l | awk '{print $2}')

# 4. Asegurar valores por defecto en caso de que tarde un segundo extra
if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" = "com" ]; then 
  INSTANCE_ID="i-error-en-lectura"
fi
if [ -z "$HOSTNAME" ]; then 
  HOSTNAME=$(hostname)
fi

# 5. Escribir el sitio web index.html
cat > /var/www/html/index.html << ENDOFHTML
<html>
<body style="font-family: Arial; text-align: center; padding: 50px;">
  <h1>EC2 Web Server</h1>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <p><strong>Hostname:</strong> $HOSTNAME</p>
</body>
</html>
ENDOFHTML
