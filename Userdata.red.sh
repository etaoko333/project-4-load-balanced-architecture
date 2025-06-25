#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Install AWS CLI if not present
yum install -y aws-cli

# Create red directory structure
mkdir -p /var/www/html/red

# Download files from S3 bucket
aws s3 cp s3://${bucket_name}/index.html /var/www/html/red/
aws s3 cp s3://${bucket_name}/error.html /var/www/html/red/
aws s3 cp s3://${bucket_name}/profile.png /var/www/html/red/

# Create custom red index page
cat > /var/www/html/red/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tovadel Academy - Red Server</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            text-align: center;
        }
        .header {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }
        .logo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: block;
        }
        .navigation {
            background: rgba(0, 0, 0, 0.2);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .navigation a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s;
            display: inline-block;
        }
        .navigation a:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }
        .server-info {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
            backdrop-filter: blur(10px);
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            background: #27ae60;
            border-radius: 20px;
            font-size: 14px;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="profile.png" alt="Tovadel Academy Logo" class="logo">
            <h1>🔴 Tovadel Academy Learning Website</h1>
            <h2>Red Server Instance</h2>
            <div class="status-badge">🟢 Server Online</div>
            <p>Welcome to the RED server in our load-balanced architecture</p>
        </div>
        
        <div class="navigation">
            <a href="/red/">Home</a>
            <a href="/red/index.html">About</a>
            <a href="/red/">Courses</a>
            <a href="/red/">Blog</a>
            <a href="/red/">Contact</a>
            <a href="/blue/">Switch to Blue Server</a>
        </div>
        
        <div class="server-info">
            <h3>🚀 Advanced Load Balancing Architecture</h3>
            <p><strong>Current Server:</strong> Red Instance (Primary)</p>
            <p><strong>Load Balancer:</strong> AWS Application Load Balancer</p>
            <p><strong>Routing Types:</strong> Path-based & Host-based routing</p>
            <p><strong>Domain:</strong> eta-oko.com</p>
            <p><strong>High Availability:</strong> Multi-AZ deployment</p>
        </div>
        
        <div class="features">
            <div class="feature-card">
                <h4>🎯 Path-Based Routing</h4>
                <p>Access this server via <code>/red</code> path</p>
                <small>Example: yoursite.com/red</small>
            </div>
            <div class="feature-card">
                <h4>🌐 Host-Based Routing</h4>
                <p>Access via subdomain routing</p>
                <small>Example: red.eta-oko.com</small>
            </div>
            <div class="feature-card">
                <h4>⚡ Auto Scaling</h4>
                <p>Automatic traffic distribution</p>
                <small>Load balanced across multiple servers</small>
            </div>
            <div class="feature-card">
                <h4>🔒 Secure & Reliable</h4>
                <p>SSL/TLS encryption ready</p>
                <small>Enterprise-grade security</small>
            </div>
        </div>
        
        <div class="server-info">
            <h3>🎓 About Tovadel Academy</h3>
            <p>Your premier destination for technology learning and professional development.</p>
            <p>This red server is part of our highly available, scalable infrastructure designed to provide uninterrupted learning experiences.</p>
        </div>
    </div>
</body>
</html>
HTMLEOF

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Restart Apache
systemctl restart httpd
