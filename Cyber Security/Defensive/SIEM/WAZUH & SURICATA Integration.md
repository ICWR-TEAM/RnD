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

## Integration to Wazuh Server Inside

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
sudo suricata-update
sudo systemctl restart suricata
sudo systemctl restart wazuh-manager
sudo systemctl restart wazuh-indexer
sudo systemctl restart wazuh-dashboard
```

## Integration to Wazuh Agent

### Install Wazuh Agent
```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.12.0-1_amd64.deb && sudo WAZUH_MANAGER='xxx.xxx.xxx.xxx' WAZUH_AGENT_NAME='agent' dpkg -i ./wazuh-agent_4.12.0-1_amd64.deb
```

### Edit Ossec File
```bash
sudo nano /var/ossec/etc/ossec/ossec.conf
```
Add to global decoder and rules at the bottom
```
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
```
Restart wazuh-agent
```bash
sudo systemctl restart wazuh-agent
```
