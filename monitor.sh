#!/bin/sh

CONFIG=$(dirname $0)/.env
if [ ! -f $CONFIG ]; then
    echo "Error: no config file $CONFIG"
    exit 1
fi
. $CONFIG

case "$1" in
    "" )
	;;
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"  )
	RULE_NO=$1
	;;
    *)
	echo "usage: $0 [0|1...]"
	exit 1
esac

echo "Monitor Rule $RULE_NO"

CURL_OPTION="--noproxy $ROUTER_HOST
	   --silent
	   -H 'Cookie: lang=8; mobile=true; url=filter_ip.html'
	   --compressed
	   --insecure"

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/login.html" | \
    grep 'data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print  decode_base64($1)}')

if [ "$TKN" = "" ]; then
    echo "Error: cannot access to $ROUTER_URL_BASE/login.html"
    exit 1
fi

NOW=$(date -u +%s)

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/login.cgi" \
  -H "Origin: $ROUTER_URL_BASE" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Referer: $ROUTER_URL_BASE/login.html" \
  --data-raw "name=admin&pws=$PWS&url=advanced.html%3Freq%3Dfilter_ip&mobile=0&httoken=$TKN" \
	  | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print  decode_base64($1)}')

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/advanced.html" \
     -H "Referer: $ROUTER_URL_BASE/" \
	  | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print  decode_base64($1)}')

if [ "$TKN" = "" ]; then
    echo "Error: cannot login to $ROUTER_URL_BASE"
    exit 1
fi

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/filter_ip.html" \
  -H "Referer: $ROUTER_URL_BASE/" \
	  | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print decode_base64($1)}')

curl $CURL_OPTION "$ROUTER_URL_BASE/cgi/cgi_filter_ip.js?_tn=$TKN&_t=$NOW&_=1625895743842" \
  -H "Referer: $ROUTER_URL_BASE/filter_ip.html" \
    | \
    perl -ne 'if ($_ =~ /.*ARC_FIREWALL_IPFILTER_RULE_'$RULE_NO'_Action","(.*)"/) { print $1 }'

TKN=$(curl $CURL_OPTION "$ROUTER_URL_BASE/logout.html" \
     -H "Referer: $ROUTER_URL_BASE/" \
	  | \
    grep '<img.*data:' | \
    perl -MMIME::Base64 -ne 'if (/src=".{78}(.*)"/) {print decode_base64($1)}')

curl $CURL_OPTION "$ROUTER_URL_BASE/logout.cgi" \
     -H "Referer: $ROUTER_URL_BASE/logout.html" \
     --data-raw "httoken=$TKN" \
     > /dev/null
