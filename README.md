This is a set of scripts for control Buffalo Wifi router series.

This script change [Security]-[IP Filter] setting of Buffalo series WiFi-Router
throu command line script.

# Setup

You have to copy .env.sample to .env on the same directory which includes monior.sh and change.sh, and edit it.

```
ROUTER_HOST=192.168.11.1                   # This is the factory default
ROUTER_URL_BASE=http://$ROUTER_HOST        # don't edit
PWS=<Hash valeu of your password.>
RULE_NO=0
```

PWS is important and you have to edit. It is a hash value of password of your admin account of your Buffalo wifi router.
To get it, you have to access Wifi Router login page through browser(Chrome, Firefox, Edge and so on..)'sr developepr tool.
This value is a kind of MD5 buf it requries special initialization value so you cannot get the hash value by generic md5 hash commands.

To get the value:
- Access your browser to the wifi router(factory default value might be 192.168.11.1).
- Open devloper tool on your browser.
- Select [Console] tab.
- Input "calcMD5('xxxx')"  on console command line in browser.
- Copy the output value.

And then paste it to PWS field in .env file. Double quote or quote are not required there.

RULE_NO is default rule of IP Filter settiong. This is used when you omit the Rule No parameter of monitor.sh and change.sh.

# Monitor

```
usage: monitor.sh [0|1...]
```

Show the current state of the rule of the rule number indicates.
[0|1..] is a rule number.

Example:

```
$ ./change.sh REJECT 2
Change Rule 2
$ ./change.sh REJECT
Change Rule 0
```

# Change

```
usage: monitor.sh [0|1...]
```

Show the current state of the rule of the rule number indicates.
[0|1..] is a rule number.

Example:

Example:

```
$ ./monitor.sh
REJECT
$ ./monitor.sh 3
ACCEPT
```


# Crontab Example

```
57 17 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 0
0 19 * * * /var/www/html/buffalo-wifirouter-control/change.sh REJECT 0
10 22 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 0
0 21 * * * /var/www/html/buffalo-wifirouter-control/change.sh REJECT 0
0 6 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 0
0 21 * * * /var/www/html/buffalo-wifirouter-control/change.sh REJECT 1
0 6 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 1
```
