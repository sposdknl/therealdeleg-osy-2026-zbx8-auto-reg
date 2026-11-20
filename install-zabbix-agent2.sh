sudo apt-get install -y net-tools

# Stažení balíčku pro instalaci zabbix repo (Zabbix 8.0 LTS, Debian 13)
wget https://repo.zabbix.com/zabbix/8.0/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_8.0+debian13_all.deb

# Instalace meta balíčku
dpkg -i zabbix-release_latest_8.0+debian13_all.deb

# Aktualizace repository
apt update

# Instalace meta balíčku
apt install zabbix-agent2

# Instalace pluginu
apt install zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql

# Povoleni sluzby zabbix-agent2
sudo systemctl restart zabbix-agent2

# Restart sluzby zabbix-agent2
sudo systemctl enable zabbix-agent2
