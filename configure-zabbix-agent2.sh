#!/bin/sh

set -eu

config=/etc/zabbix/zabbix_agent2.conf
name_file=/var/lib/zabbix-auto-reg/hostname
prefix=therealdeleg-debian13

install -d -m 0755 /var/lib/zabbix-auto-reg

# Jedinečný název se vytvoří jen jednou a pak se načítá ze souboru.
if [ ! -s "$name_file" ]; then
  id=$(tr -d '-' < /proc/sys/kernel/random/uuid | cut -c1-12)
  printf '%s-%s\n' "$prefix" "$id" > "$name_file"
  chmod 0644 "$name_file"
fi

hostname=$(cat "$name_file")

if ! printf '%s\n' "$hostname" | grep -Eq "^${prefix}-[[:xdigit:]]{12}$"; then
  echo "Neplatný uložený název hosta: $hostname" >&2
  exit 1
fi

if [ ! -f "${config}.orig" ]; then
  cp -p "$config" "${config}.orig"
fi

# Při opakovaném provisioningu nenecháme v konfiguraci duplicitní parametry.
sed -i -E '/^[[:space:]#]*(Hostname|Server|ServerActive|HostMetadata)=/d' "$config"
cat >> "$config" <<EOF2

# Nastavení pro úlohu OSY
Hostname=$hostname
Server=enceladus.pfsense.cz
ServerActive=enceladus.pfsense.cz
HostMetadata=SPOS
EOF2

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
systemctl --no-pager status zabbix-agent2

printf 'Zabbix agent běží jako %s\n' "$hostname"