#!/bin/bash
sleep 10
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

# Intentar obtener el token en un bucle (máximo 5 intentos)
for i in {1..5}; do
  TOKEN=$(curl -s -X PUT "http://169.254.169" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" --connect-timeout 2)
  if [ -n "$TOKEN" ]; then break; fi
  sleep 2
done

if [ -n "$TOKEN" ]; then
  INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169)
  HOSTNAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169)
else
  INSTANCE_ID="Unknown-AL2023"
  HOSTNAME=$(hostname)
fi

cat > /var/www/html/index.html << ENDOFHTML
<html>
<body style="font-family: Arial; text-align: center; padding: 50px;">
  <h1>EC2 Web Server</h1>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <p><strong>Hostname:</strong> $HOSTNAME</p>
</body>
</html>
ENDOFHTML
