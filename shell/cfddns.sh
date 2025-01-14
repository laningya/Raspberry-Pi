#!/bin/bash

# 启用IPv4或IPv6解析
enableIPv4=1
enableIPv6=0

# 启用代理
proxy=false
# proxy=true

# IPv4和IPv6域名
IPv4Domain="test.yourdomail.com"
IPv6Domain="test.yourdomail.com"

# Cloudflare API令牌和域ID
ZONE_ID=""
API_TOKEN=""

# 获取当前IP地址
get_current_ip() {
  if [ "$1" == "A" ]; then
    curl -s 4.ipw.cn
  elif [ "$1" == "AAAA" ]; then
    curl -s 6.ipw.cn
  fi
}

# 管理DNS记录
manage_dns_record() {
  local recordType=$1
  local domain=$2
  local enable=$3

  if [ -z "$domain" ]; then
    return
  fi

  local response=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$domain&type=$recordType" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json")
  local recordCount=$(echo "$response" | jq '.result | length')

  if [ "$recordCount" -gt 0 ]; then
    local recordID=$(echo "$response" | jq -r '.result[0].id')

    if [ "$enable" -eq 1 ]; then
      local currentIP=$(get_current_ip "$recordType")
      local recordContent=$(echo "$response" | jq -r '.result[0].content')
      local recordProxied=$(echo "$response" | jq -r '.result[0].proxied')

      if [ "$recordContent" == "$currentIP" ] && [ "$proxy" == "$recordProxied" ]; then
        echo "$recordType record for '$domain' has not changed. Current IP: $currentIP"
      else
        echo "$recordType record for '$domain' has changed or proxy status does not match. Updating..."
        local jsonData=$(cat <<EOF
{
  "type": "$recordType",
  "name": "$domain",
  "content": "$currentIP",
  "ttl": 1,
  "proxied": $proxy
}
EOF
        )
        local updateResponse=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$recordID" \
          -H "Authorization: Bearer $API_TOKEN" \
          -H "Content-Type: application/json" \
          -d "$jsonData")
        local success=$(echo "$updateResponse" | jq '.success')
        if [ "$success" == "true" ]; then
          echo "$recordType record updated successfully. New IP: $currentIP"
        else
          echo "Failed to update $recordType record. Response: $updateResponse"
        fi
      fi
    else
      echo "$recordType record for '$domain' is disabled. Deleting..."
      local deleteResponse=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$recordID" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json")
      local success=$(echo "$deleteResponse" | jq '.success')
      if [ "$success" == "true" ]; then
        echo "$recordType record deleted successfully."
      else
        echo "Failed to delete $recordType record. Response: $deleteResponse"
      fi
    fi
  else
    if [ "$enable" -eq 1 ]; then
      echo "$recordType record for '$domain' does not exist. Creating..."
      local currentIP=$(get_current_ip "$recordType")
      local jsonData=$(cat <<EOF
{
  "type": "$recordType",
  "name": "$domain",
  "content": "$currentIP",
  "ttl": 1,
  "proxied": $proxy
}
EOF
      )
      local createResponse=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$jsonData")
      local success=$(echo "$createResponse" | jq '.success')
      if [ "$success" == "true" ]; then
        echo "$recordType record created successfully. New IP: $currentIP"
      else
        echo "Failed to create $recordType record. Response: $createResponse"
      fi
    fi
  fi
}

# 验证ZONE_ID和API_TOKEN
response=$(curl -s -o /dev/null -w "%{http_code}" -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json")

if [ "$response" -eq 200 ]; then
  manage_dns_record "A" "$IPv4Domain" "$enableIPv4"
  manage_dns_record "AAAA" "$IPv6Domain" "$enableIPv6"
elif [ "$response" -eq 401 ]; then
  echo "Error: Invalid API_TOKEN."
elif [ "$response" -eq 404 ]; then
  echo "Error: Invalid ZONE_ID."
else
  echo "Error: Request failed with status code $response."
fi
