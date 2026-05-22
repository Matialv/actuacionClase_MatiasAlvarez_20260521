#!/bin/bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)
HOSTNAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-hostname)

cat > /var/www/html/index.html << ENDOFHTML
<html>
<body style="font-family: Arial; text-align: center; padding: 50px;">
  <h1>EC2 Web Server</h1>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <p><strong>Hostname:</strong> $HOSTNAME</p>
</body>
</html>
ENDOFHTML