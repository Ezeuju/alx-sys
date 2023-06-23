# File: 7-puppet_install_nginx_web_server.pp

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Configure Nginx server
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  content => "
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location /redirect_me {
        return 301 http://www.example.com;
    }
}
",
  notify  => Service['nginx'],
}

# Create the HTML file with the desired content
file { '/var/www/html/index.html':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  content => '<h1>Hello World!</h1>',
}

# Start and enable the Nginx service
service { 'nginx':
  ensure    => running,
  enable    => true,
  hasstatus => true,
  hasrestart => true,
}

