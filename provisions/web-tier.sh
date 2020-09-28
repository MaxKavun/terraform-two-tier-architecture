#!/bin/bash

#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd
systemctl enable httpd
echo "Hello from <h1>$(hostname)</h1>" > /var/www/html/index.html
