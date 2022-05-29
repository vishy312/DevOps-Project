#! /bin/bash

###############################################################################
#				To Print text in green/red color																			#
#				Arguments:-																														#
#							 1 - color-->green or red																				#
#							 2 - text-to-be-printed																				  #
###############################################################################

function print_color(){
  NC='\033[0m' # No Color

  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2 ${NC}"
}

###############################################################################
#				To Check a Service Status																			        #
#				Arguments:-																														#
#							 1) name of service--> ex: firewalld, mariadb-server						#
###############################################################################

function check_service_status(){
	service_is_active=$(sudo systemctl is-active $1)

	if [ $service_is_active = "active"]
	then
		print_color "green" "$1 is active and running"
	else
		print_color "red" "$1 is not active"
		exit 1
	fi
}

###############################################################################
#				To check if a given item is present in the given output or not				#
#				Arguments:-																														#
#							 1 - item																												#
#							 2 - output																										  #
###############################################################################
function check_item(){
	if [[ $1 = *$2* ]]
	then
		print_color "green" "$2 is present on the webpage"
	else
		print_color "red" "$2 is not present on the webpage"
	fi
}


###############################################################################
#				To check the status of a firewalld rule, if not configured-->exit.		#
#				Arguments:-																														#
#							 1 - item																												#
#							 2 - output																										  #
###############################################################################
function is_firewalld_rule_configured(){

  firewalld_ports=$(sudo firewall-cmd --list-all --zone=public | grep ports)

  if [[ $firewalld_ports == *$1* ]]
  then
    print_color "green" "FirewallD has port $1 configured"
  else
    print_color "red" "FirewallD port $1 is not configured"
    exit 1
  fi
}



# install and configure firewall
print_color green 'Installing Firewall...................'
sudo yum install -y firewalld
print_color green 'Firewall Installed!'
sudo service firewalld start
sudo systemctl enable firewalld
print_color green 'checking firewalld service status......'
check_service_status firewalld

# install and configure mariaDB
print_color green 'Installing MariaDB...................'
sudo yum install -y mariadb-server
print_color green 'MariaDB Installed!'
sudo service mariadb start
sudo systemctl enable mariadb
print_color green 'checking mariadb service status......'
check_service_status mariadb

# configure firewall rules for Database
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload
is_firewalld_rule_configured 3306

# Database setup
print_color "green" "<------------Database Server Setup Starts------------->"
cat > setup-db.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
EOF
sudo mysql < setup-db.sql

# loading Products in Database 
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

sudo mysql < db-load-script.sql
mysql_db_results=$(sudo mysql -e "use ecomdb; select * from products;")
if [[ $mysql_db_results == *Laptop* ]]
then
  print_color "green" "Inventory data loaded into MySQl"
else
  print_color "green" "Inventory data not loaded into MySQl"
  exit 1
fi

print_color "green" "<------------Database Server Setup Finished------------->"

print_color "green" "<---------------Web Server Setup Starts----------------->"
# install web server packages
print_color green "Installing Web Server Packages............."
sudo yum install -y httpd php php-mysql

# configure firewall rules for Web-Server
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload
is_firewalld_rule_configured 80

# in httpd configuration file changing the value from index.html to index.php
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf


sudo service httpd start
sudo systemctl enable httpd
print_color green 'checking firewalld service status......'
check_service_status firewalld
print_color "green" "<---------------Web Server Setup Starts----------------->"


#Download Code
print_color "green" "Installing Git.................."
sudo yum install -y git
print_color "green" "cloning Git Repo................."
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

#changing the server in index.php file
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php


#Test Script
web_page=$(curl http://localhost)
for item in Laptop Drone VR Watch Phone
do
  check_item "$web_page" $item
done