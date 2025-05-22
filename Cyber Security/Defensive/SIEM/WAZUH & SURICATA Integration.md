# WAZUH & SURICATA Integration

## Install SURICATA
```bash
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt-get update
sudo apt install suricata
```

### Edit Suricata Config
```bash
sudo nano /etc/suricata/suricata.yaml
```
Adjust to network settings, edit variable HOME_NET to your network. Edit interface `af-packet` & `pcap`

### Update List Source
```bash
sudo suricata-update list-sources
sudo suricata-update enable-source etnetera/aggressive
sudo suricata-update
```

## Integrate to Wazuh Server Inside

### Edit Ossec File
```bash
sudo nano /var/ossec/etc/ossec.conf
```
Add to global decoder and rules at the bottom
```
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
```

### Restart Service
```bash
suricata-update
systemctl restart suricata
systemctl restart wazuh-manager
systemctl restart wazuh-indexer
systemctl restart wazuh-dashboard
```
