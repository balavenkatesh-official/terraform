<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h1>Terraform and Ansible Configuration</h1>
    <p>terraform</p>
    <p>When we run this script, the following items are created:</p>
    <ul>
        <li>VPC</li>
        <li>Subnetmask</li>
        <li>Internet Gateway</li>
        <li>Routing Table</li>
        <li>Subnets</li>
        <li>Ubuntu Instance - t2.micro</li>
        <li>Elastic IP</li>
    </ul>
    <h2>Ansible Configuration</h2>
    <ul>
        <li>Apache2</li>
        <li>MySQL 8.0</li>
        <li>PHP 8.0 with its modules</li>
        <li>Deploy Node project with backend port-no [:: 3000 ]
        https://github.com/balavenkatesh-official/nodejs-crud-project.git
        </li>
        <li>crud.js file as a frontend. use the backend path /users 
        https://github.com/balavenkatesh-official/nodejs-crud-project.git
        </li>
        <li> Configure vhost and make the site live 
                         
                         <VirtualHost *:80>
                         ServerName {{ipaddress}}
                         DocumentRoot /var/www/html/
                         <Directory /var/www/html>
                         Options Indexes FollowSymLinks
                         AllowOverride All
                         Require all granted
                         </Directory>
            
                          # Proxy setup for API requests to backend
                          ProxyPreserveHost On
                          ProxyPass /users http://localhost:3000/users
                          ProxyPassReverse /users http://localhost:3000/users
            
                         ErrorLog /var/log/apache2/example.com-error.log
                         CustomLog /var/log/apache2/example.com-access.log combined
                         </VirtualHost>
</li>        
    </ul>
</body>
</html>





