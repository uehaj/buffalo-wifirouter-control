#!/bin/sh

if [ "$1" != "ACCEPT" -a "$1" != "REJECT" ]; then
      echo "usage: $0 ACCEPT | REJECT"
      exit
fi

CONFIG=$(dirname $0)/.env
if [ ! -f $CONFIG ]; then
    echo "Error: no config file $CONFIG"
    exit 1
fi
source $CONFIG

CURL_OPTION="--noproxy $ROUTER_HOST
	   --silent
	   -H 'Cookie: lang=8; mobile=true; url=filter_ip.html'
	   -compressed
	   --insecure"

TKN=$(curl $CURL_OPTION $ROUTER_URL_BASE/login.html | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print  decode_base64($1)}')

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/login.cgi" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Referer: $ROUTER_URL_BASE/login.html" \
  --data-raw "name=admin&pws=a154284cc0da6b575bbefe44e547036c&url=advanced.html%3Freq%3Dfilter_ip&mobile=0&httoken=$TKN" \
 | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print  decode_base64($1)}')

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/filter_ip.html" \
  -H "Referer: $ROUTER_URL_BASE/" \
 | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print  decode_base64($1)}')

curl $CURL_OPTION "$ROUTER_URL_BASE/apply_abstract.cgi" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Referer: $ROUTER_URL_BASE/filter_ip.html?rnd=33996119" \
  --data-raw "action=ui_firewall&httoken=$TKN&submit_button=filter_ip.html&action_params=blink_time%3D5&ARC_FIREWALL_IPFILTER_RULE_0_Action=$1" \
  > /dev/null

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/logout.html" \
     -H "Referer: $ROUTER_URL_BASE/" \
     | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print decode_base64($1)}')

curl $CURL_OPTION "$ROUTER_URL_BASE/logout.cgi" \
     -H "Referer: $ROUTER_URL_BASE/logout.html" \
     --data-raw "httoken=$TKN" \
    > /dev/null
