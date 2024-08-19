# Gathered information:

1. ## Top 5 IP addresses requests come from 
  ```awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -5```

> vitalik@ns2:~/SRE_Challenge/task-1$ awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -5
  
    278 98.126.83.64
    248 13.212.235.168
    153 26.55.70.11
    145 3.58.246.203
    140 84.147.24.50

2. ## Number of requests with '500' and '200' HTTP codes

    awk '{print $8}' access.log | grep '^200$' | wc -l
    awk '{print $8}' access.log | grep '^500$' | wc -l

    405
    378

3. ## Number of requests per minute 
  ```awk '{print substr($4, 2, 17)}' access.log | sort | uniq -c```

The syntax is substring($0, start, length), where $0 is the string, 
start is the position where the substring starts, and length is the length of the substring.

> vitalik@ns2:~/SRE_Challenge/task-1$ awk '{print substr($4, 2, 17)}' access.log | sort | uniq -c
    
    246 11/Aug/2024:09:49
    392 11/Aug/2024:09:50
    273 11/Aug/2024:09:52
    371 11/Aug/2024:09:53
    241 11/Aug/2024:09:54
    332 11/Aug/2024:09:55
    145 11/Aug/2024:09:56

4. ## Which domain is the most requested one? 
  ```awk '{print $6}' access.log | awk -F[/] '{print $1}' | sort | uniq -c | sort -nr | head -1```
 
-F or fs means --field-separator=fs

> vitalik@ns2:~/SRE_Challenge/task-1$ awk '{print $6}' access.log | awk -F[/] '{print $1}' | sort | uniq -c | sort -nr | head -1

    1036 example3.com

5. ## Do all the requests to '/page.php' result in '499' code? 
  ```echo "number of HTTP code 499:"; awk '$6 ~ /\/page\.php/ && $8 == 499' access.log | wc -l; echo "number of the requests to page.php:"; awk '$6 ~ /\/page\.php/' access.log | wc -l``` 

~: checks a field against a regular expression.

> vitalik@ns2:~/SRE_Challenge/task-1$ echo "number of HTTP code 499:"; awk '$6 ~ /\/page\.php/ && $8 == 499' access.log | wc -l; echo "number of the request  to page.php:"; awk '$6 ~ /\/page\.php/' access.log | wc -l
 
    number of HTTP code 499:
    144
    number of the requests to page.php:
    689

6. ## Additional commands run

```grep -i 'bot\|crawl\|spider' access.log | awk '{print $12}' | sort | uniq -c```

    347 AhrefsBot/7.0;
    336 MJ12bot/v1.4.8;
    330 bingbot/2.0;

An origin of the top IP adresses:

    278 98.126.83.64 - Organization:   Krypt Technologies (VPLSI), USA
    248 13.212.235.168 - Amazon, USA
    153 26.55.70.11 - DoD Network Information Center (DNIC), USA
    145 3.58.246.203 - Amazon, USA
    140 84.147.24.50 - Deutsche Telekom AG

Counting nubmer of requests to wp-login.php
```grep "/wp-login.php" access.log | wc -l```

    641


## **Findings:**

1. #### Time range
A log range is from [11/Aug/2024:09:49:30] to [11/Aug/2024:09:56:12] - that is, almost 7 minutes. 2000 HTTP requests were made in 7 minutes.
Half of the requests came to the domain example3.com.

2. #### Numerous requests from the same IPs during a short period of time
Several addresses made more than 150 attempts to connect to the server in a few minutes. This may indicate an attempt to make multiple requests to different resources from the same IP address, which may also be a sign of an DDos attack or an automated scan.

3. #### Lots of 500 errors
A fifth of all requests show a 500 error. This may be due to internal problems on the server or its overload. 
However, we can see that 200 ok codes are slightly more than 500 codes. So the issue does not seem to be related to the incorrect work of the server. 

4. #### Accessing wp-login.php
Almost a third requests try to access the wp-login.php file, which is the WordPress login page.
This could be an attempted brute-force attack to hack the admin panel. By the way, it may explain abnormal number of 500 errors on the server.

5. #### Suspicious/malicious bots
There are a lot of requests from bots like AhrefsBot, MJ12bot, bingbot (more than 300 requests per each bot). Some of these bots are used for malicious activity very often.

6. #### The presense of 499 HTTP codes.
The HTTP 499 error typically occurs when a client terminates the connection before the server is able to respond, such as when a user cancels a request or navigates away from a page before it fully loads.
This could be a sign of malicious activity by a bot or other automated system.

## **Summary:**
It looks like we witnessed a fragment of a DDoS attack, a brute force attack or a vulnerability scan.

