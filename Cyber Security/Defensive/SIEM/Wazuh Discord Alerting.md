# Wazuh Discord Alerting

1. Setting Config `Server Management -> Setting -> Edit configuration`
In `<ossec_config>` under first `<global>...</global>`
```
<integration>
  <name>custom-discord</name>
  <hook_url>https://discord.com/api/webhooks/XXXxxx</hook_url>
  <alert_format>json</alert_format>
</integration>
```
2. Save & Restart Manager
3. Create `/var/ossec/integrations/custom-discord` file
```bash
#!/bin/sh
# Copyright (C) 2015, Wazuh Inc.
# Created by Wazuh, Inc. <info@wazuh.com>.
# This program is free software; you can redistribute it and/or modify it under the terms of GPLv2
# this is a copy of the slack integration file renamed to custom-discord 


WPYTHON_BIN="framework/python/bin/python3"

SCRIPT_PATH_NAME="$0"

DIR_NAME="$(cd $(dirname ${SCRIPT_PATH_NAME}); pwd -P)"
SCRIPT_NAME="$(basename ${SCRIPT_PATH_NAME})"

case ${DIR_NAME} in
    */active-response/bin | */wodles*)
        if [ -z "${WAZUH_PATH}" ]; then
            WAZUH_PATH="$(cd ${DIR_NAME}/../..; pwd)"
        fi

        PYTHON_SCRIPT="${DIR_NAME}/${SCRIPT_NAME}.py"
    ;;
    */bin)
        if [ -z "${WAZUH_PATH}" ]; then
            WAZUH_PATH="$(cd ${DIR_NAME}/..; pwd)"
        fi

        PYTHON_SCRIPT="${WAZUH_PATH}/framework/scripts/$(echo ${SCRIPT_NAME} | sed 's/\-/_/g').py"
    ;;
     */integrations)
        if [ -z "${WAZUH_PATH}" ]; then
            WAZUH_PATH="$(cd ${DIR_NAME}/..; pwd)"
        fi

        PYTHON_SCRIPT="${DIR_NAME}/${SCRIPT_NAME}.py"
    ;;
esac


${WAZUH_PATH}/${WPYTHON_BIN} ${PYTHON_SCRIPT} "$@"
```
4. Create `/var/ossec/integrations/custom-discord.py` file
```python
#/usr/bin/env python3

import sys
import requests
import json
from requests.auth import HTTPBasicAuth

"""
ossec.conf configuration structure
 <integration>
     <name>custom-discord</name>
     <hook_url>https://discord.com/api/webhooks/XXXXXXXXXXX</hook_url>
     <alert_format>json</alert_format>
 </integration>
"""

# read configuration
alert_file = sys.argv[1]
user = sys.argv[2].split(":")[0]
hook_url = sys.argv[3]

# read alert file
with open(alert_file) as f:
    alert_json = json.loads(f.read())

# extract alert fields
alert_level = alert_json["rule"]["level"]

# colors from https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812
if(alert_level < 5):
    # green
    color = "5763719"
elif(alert_level >= 5 and alert_level <= 7):
    # yellow
    color = "16705372"
else:
    # red
    color = "15548997"

# agent details
if "agentless" in alert_json:
          agent_ = "agentless"
else:
    agent_ = alert_json["agent"]["name"]

ip = alert_json.get("data", {}).get("srcip", "None")

# combine message details
payload = json.dumps({
    "content": "",
    "embeds": [
        {
                    "title": f"Wazuh Alert - Rule {alert_json['rule']['id']}",
                                "color": color,
                                "description": alert_json["rule"]["description"],
                                "fields": [{
                                                "name": "Agent",
                                                "value": agent_,
                                                "inline": True
                                                },
                                           {
                                                "name": "Source IP",
                                                "value": ip,
                                                "inline": False
                                                }]
        }
    ]
})

# send message to discord
r = requests.post(hook_url, data=payload, headers={"content-type": "application/json"})
sys.exit(0)
```
5. Permission file command
```bash
sudo chmod 750 /var/ossec/integrations/custom-*
sudo chown root:wazuh /var/ossec/integrations/custom-*
```
6. Install Python requirements
```bash
sudo apt-get install python3-pip
pip3 install requests
```
7. Restart wazuh
```bash
/var/ossec/bin/wazuh-control restart
``` 
