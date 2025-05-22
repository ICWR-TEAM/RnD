# WAZUH & SURICATA Integration

### Install SURICATA
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

### Edit Ossec File
```bash
sudo nano /var/ossec/etc/ossec.conf
```
Add to global decoder and rules in both
```
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
```
