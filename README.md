This is a set of scripts for control Buffalo Wifi router series.

This script change [Security]-[IP Filter] setting of Buffalo series WiFi-Router
through command line script.

You can control your devices network access.

It is needed IP Addresses are fixed because IP-Filter rules of Buffalo settions are distinguishes with IP address.

# Setup

You have to copy .env.sample to .env on the same directory which includes monior.sh and change.sh, and edit it following way.

```
ROUTER_HOST=192.168.11.1                   # This is the factory default
ROUTER_URL_BASE=http://$ROUTER_HOST        # don't edit
PWS=<Hash valeu of your password.>
RULE_NO=0
```

PWS field is important and you have to edit it. It is a hash value of password of your admin account of your Buffalo wifi router.
To get the actual hash value, you have to access Wifi Router login page through browser(Chrome, Firefox, Edge and so on..)'s developper tool.
This value is a kind of MD5 buf it requries special initialization value so you cannot get the hash value by generic md5 hash commands.

To get the value:
- With your browser acceess the wifi router login page (Factory default value of the router might be http://192.168.11.1).
- Open devloper tool on your browser.
- Select the [Console] tab.
- Input "calcMD5('xxxx')" on console command line in browser, and press ENTER.
- Copy the output value.

And then paste it to PWS field in the .env file. Double quote or quote are not required here.

RULE_NO field is default rule number of IP Filter settiong. This is used when you omit the Rule No command line parameter fo monitor.sh and change.sh scripts.

## monitor.sh

This shows the current state of the rule of the rule number indicates.

```
usage: monitor.sh [0|1...]
```

where [0|1..] is a rule number.

### Example:

```
$ ./change.sh REJECT 2
Change Rule 2
$ ./change.sh REJECT
Change Rule 0
```

## change.sh

Change the state of the rule of the rule number indicates.

```
usage: monitor.sh [0|1...]
```

[0|1..] is a rule number.

If you ommit rule number, RULE_NO field value in .env are used.

### Example:

```
$ ./monitor.sh
REJECT
$ ./monitor.sh 3
ACCEPT
```
# Web interface

Following cgis and index.html are web interfaces of this scripts.

```
accept.cgi
index.cgi
reject.cgi
```

To use this, you setup cgi/fastcgi on your web server (apache or nginx or..) and put index.html like this:

```
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="refresh" content="0;URL=./buffalo-wifirouter-control/index.cgi">
</head>
</html>
```

## Screenshot

[Screenshot](https://i.imgur.com/MpkTV70_d.webp?maxwidth=760&fidelity=grand)

# Crontab Example

It is useful you specify these script on crontab. 

### Example:

```
57 17 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 0
0 19 * * * /var/www/html/buffalo-wifirouter-control/change.sh REJECT 0
10 22 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 0
0 21 * * * /var/www/html/buffalo-wifirouter-control/change.sh REJECT 0
0 6 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 0
0 21 * * * /var/www/html/buffalo-wifirouter-control/change.sh REJECT 1
0 6 * * * /var/www/html/buffalo-wifirouter-control/change.sh ACCEPT 1
```
