#!/bin/bash

ipv4=1
ipv6=1


v4Domain=test
v6Domain=test


domain="a.com"
accessKeyId=""
accessSecret=""



# 使用 command -v 命令检查命令是否存在
if !(command -v aliyun >/dev/null 2>&1); then
    echo "aliyun-cli不存在，x86_64架构机器请使用以下命令安装："
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aliyun/aliyun-cli/HEAD/install.sh)"'
    exit 1
fi

if !(command -v jq >/dev/null 2>&1); then
    echo "jq命令不存在，请根据发行版本安装"
    exit 2
fi

if (aliyun configure set --profile akProfile --mode AK --region cn-hangzhou --access-key-id ${accessKeyId} --access-key-secret ${accessSecret});then
        domainRecords=$(aliyun alidns DescribeDomainRecords --DomainName ${domain} 2>/dev/null)
        if [ $? -eq 1 ];then
            echo "鉴权失败，检查accessKeyID和accessSecret"
            exit 3
        fi

        #v4
        if [ ${ipv4} -eq 1 ];then
            domainRecordInfo=$(echo ${domainRecords} | jq  -e -r '.DomainRecords.Record[] | select(.RR == "'${v4Domain}'" and .Type == "A")')
            if [ $? -eq 0 ];then #更新记录
                v4=$(echo ${domainRecordInfo} | jq -r '.Value')
                v4n=$(curl -s 4.ipw.cn)
                if [ ${v4} = ${v4n} ];then
                    echo "IPv4未改变，无需更新"
                    echo "当前IPv4：${v4n}"
                else
                    recordId=$(echo ${domainRecordInfo} | jq -r '.RecordId')
                    aliyun alidns UpdateDomainRecord --RecordId ${recordId} --RR ${v4Domain} --Type A --Value ${v4n} >/dev/null 2>&1
                    if [ $? -eq 0 ];then
                        echo "IPv4已更新"
                        echo "当前IPv4：${v4n}"
                    fi
                fi
            else #添加记录
                v4n=$(curl -s 4.ipw.cn)
                aliyun alidns AddDomainRecord --DomainName ${domain} --RR ${v4Domain} --Type A --Value ${v4n} >/dev/null 2>&1
                if [ $? -eq 0 ];then
                    echo "创建v4解析成功"
                    echo "当前IPv4：${v4n}"
                fi
            fi
        fi

        #v6
        if [ ${ipv6} -eq 1 ];then
            domainRecordInfo=$(echo ${domainRecords} | jq  -e -r '.DomainRecords.Record[] | select(.RR == "'${v6Domain}'" and .Type == "AAAA")')
            if [ $? -eq 0 ];then #更新记录
                v6=$(echo ${domainRecordInfo} | jq -r '.Value')
                v6n=$(curl -s 6.ipw.cn)
                if [ ${v6} = ${v6n} ];then
                    echo "IPv6未改变，无需更新"
                    echo "当前IPv6：${v6n}"
                else
                    recordId=$(echo ${domainRecordInfo} | jq -r '.RecordId')
                    aliyun alidns UpdateDomainRecord --RecordId ${recordId} --RR ${v6Domain} --Type AAAA --Value ${v6n} >/dev/null 2>&1
                    if [ $? -eq 0 ];then
                        echo "IPv6已更新"
                        echo "当前IPv6：${v6n}"
                    fi
                fi
            else #添加记录
                v6n=$(curl -s 6.ipw.cn)
                aliyun alidns AddDomainRecord --DomainName ${domain} --RR ${v6Domain} --Type AAAA --Value ${v6n} >/dev/null 2>&1
                if [ $? -eq 0 ];then
                    echo "创建v6解析成功"
                    echo "当前IPv6：${v6n}"
                fi
            fi
        fi
fi

