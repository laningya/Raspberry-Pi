#!/bin/bash

# 启用IPv4orIPv6解析
enableIPv4=1
enableIPv6=0

# 启用代理
proxy=false
# proxy=true

# IPv4域名和IPv6域名
IPv4Domain=
IPv6Domain=

# CloudflareAPI令牌和域ID
ZONE_ID=
API_TOKEN=


response=$(curl -s -o /dev/null -w "%{http_code}" -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID" \
-H "Authorization: Bearer $API_TOKEN" \
-H "Content-Type: application/json")

# 根据 HTTP 状态码判断ZONE_ID和API_TOKEN有效性
if [ "$response" -eq 200 ]; then

    # 检查IPv4记录是否存在
    response=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$IPv4Domain&type=A" \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json")
    recordCount=$(echo "$response" | jq '.result | length')

    if [ "$recordCount" -gt 0 ]; then
      echo "Record '$IPv4Domain' exists."
      IPv4DomainID=$(echo $response | jq -r '.result[0].id')
      IPv4DomainRecord=$(echo $response | jq -r '.result[0].content')
      IPv4DomainProxy=$(echo $response | jq -r '.result[0].proxied')

      if [ "$enableIPv4" -eq 1 ]; then

        # 获取当前IPv4地址
        currentIPv4=$(curl -s 4.ipw.cn)

        # 判断IPv4是否变化
        if [ $IPv4DomainRecord = $currentIPv4 ] && [ $proxy = $IPv4DomainProxy ];then
          echo "IPv4 has not changed"
          echo "Current IPv4 address: '$currentIPv4'"
        else
          echo "IPv4 has changed or proxy status does not match"
        jsonData=$(cat <<EOF
        {
          "type": "A",
          "name": "$IPv4Domain",
          "content": "$currentIPv4",
          "ttl": 1,
         "proxied": $proxy
        }
EOF
        )

          # 发送 PUT 请求更新 DNS 记录
          echo $IPv4DomainID
          response=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$IPv4DomainID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$jsonData")

          # 检查更新是否成功
          success=$(echo "$response" | jq '.success')
          if [ $success = "true" ]; then
            echo "Current IPv4 address: '$currentIPv4'"
            echo "DNS record updated successfully."
          else
            echo "Failed to update DNS record. Response: $response"
          fi
        fi
      else

          # 删除 DNS 记录
          response=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$IPv4DomainID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json")
          
          # 检查删除是否成功
          success=$(echo "$response" | jq '.success')
          if [ "$success" == "true" ]; then
            echo "IPv4 DNS record deleted successfully."
          else
            echo "Failed to delete IPv4 DNS record. Response: $response"
          fi
      fi
    else
      if [ "$enableIPv4" -eq 1 ]; then
        echo "Record '$IPv4Domain' does not exist."

        # 获取当前IPv4地址
        currentIPv4=$(curl -s 4.ipw.cn)
        jsonData=$(cat <<EOF
        {
          "type": "A",
          "name": "$IPv4Domain",
          "content": "$currentIPv4",
          "ttl": 1,
         "proxied": $proxy
        }
EOF
        )

        # 发送 POST 请求创建新 DNS 记录
        response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$jsonData")

        # 检查创建是否成功
        success=$(echo "$response" | jq '.success')
        if [ $success = "true" ]; then
          echo "Current IPv4 address: '$currentIPv4'"
          echo "DNS record created successfully."
        else
          echo "Failed to create DNS record. Response: $response"
        fi
      fi
    fi



    # 检查IPv6记录是否存在
    response=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$IPv6Domain&type=AAAA" \
      -H "Authorization: Bearer $API_TOKEN" \
      -H "Content-Type: application/json")
    recordCount=$(echo "$response" | jq '.result | length')

    if [ "$recordCount" -gt 0 ]; then
      echo "Record '$IPv6Domain' exists."
      IPv6DomainID=$(echo $response | jq -r '.result[0].id')
      IPv6DomainRecord=$(echo $response | jq -r '.result[0].content')
      IPv6DomainProxy=$(echo $response | jq -r '.result[0].proxied')

      if [ "$enableIPv6" -eq 1 ]; then

        # 获取当前IPv6地址
        currentIPv6=$(curl -s 6.ipw.cn)

        # 判断IPv6是否变化
        if [ $IPv6DomainRecord = $currentIPv6 ] && [ $proxy = $IPv6DomainProxy ];then
          echo "IPv6 has not changed"
          echo "Current IPv6 address: '$currentIPv6'"
        else
          echo "IPv6 has changed or proxy status does not match"
                  jsonData=$(cat <<EOF
        {
          "type": "AAAA",
          "name": "$IPv6Domain",
          "content": "$currentIPv6",
          "ttl": 1,
         "proxied": $proxy
        }
EOF
        )

          # 发送 PUT 请求更新 DNS 记录
          echo $IPv6DomainID
          response=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$IPv6DomainID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$jsonData")

          # 检查更新是否成功
          success=$(echo "$response" | jq '.success')
          if [ $success = "true" ]; then
            echo "Current IPv6 address: '$currentIPv6'"
            echo "DNS record updated successfully."
          else
            echo "Failed to update DNS record. Response: $response"
          fi
        fi
      else

          # 删除 DNS 记录
          response=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$IPv6DomainID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json")
          
          # 检查删除是否成功
          success=$(echo "$response" | jq '.success')
          if [ "$success" == "true" ]; then
            echo "IPv6 DNS record deleted successfully."
          else
            echo "Failed to delete IPv6 DNS record. Response: $response"
          fi
      fi
    else
      if [ "$enableIPv6" -eq 1 ]; then
        echo "Record '$IPv6Domain' does not exist."

        # 获取当前IPv6地址
        currentIPv6=$(curl -s 6.ipw.cn)
        jsonData=$(cat <<EOF
        {
          "type": "AAAA",
          "name": "$IPv6Domain",
          "content": "$currentIPv6",
          "ttl": 1,
         "proxied": $proxy
        }
EOF
        )

        # 发送 POST 请求创建新 DNS 记录
        response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$jsonData")

        # 检查创建是否成功
        success=$(echo "$response" | jq '.success')
        if [ $success = "true" ]; then
          echo "Current IPv6 address: '$currentIPv6'"
          echo "DNS record created successfully."
        else
          echo "Failed to create DNS record. Response: $response"
        fi
      fi
    fi

elif [ "$response" -eq 401 ]; then
    echo "Error: Invalid API_TOKEN."
elif [ "$response" -eq 404 ]; then
    echo "Error: Invalid ZONE_ID."
else
    echo "Error: Request failed with status code $response."
fi