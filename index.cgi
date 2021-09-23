#!/bin/sh

echo 'Content-type: text/html'  
echo ''

cat <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Change IP Filter Setting</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Change IP Filter Setting</h1>
<p>Current Status:<span style="text-decoration: bold">
EOF

$(dirname $0)/monitor.sh

cat <<EOF
<span>
</p>
<form action="reject.cgi">
  <input type="submit" value="REJECT"></input>
</form>
<form action="accept.cgi">
  <input type="submit" value="ACCEPT"></input>
</form>
</body>
</html>
EOF
