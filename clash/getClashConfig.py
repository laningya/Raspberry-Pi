import os
import re
import requests

<<<<<<< HEAD
url = ''
oldContent  = 'external-controller: :9090'
newContent  = 'external-controller: 0.0.0.0:9090'
insertContent = 'external-ui: /ui'
filePath = '/home/pi/clash/'
=======
url  = ''
oldContent  = 'external-controller: :9090'
newContent  = 'external-controller: 0.0.0.0:9090'
insertContent = 'external-ui: /ui'
filePath = ''
>>>>>>> develop

def getData(url):
     # 发送GET请求
     response = requests.get(url)
     return response.status_code , response.text

def processData(contents):

    newContents = insertContent + '\n' + re.sub(oldContent, newContent, contents)

    with open(filePath + 'config.yaml', 'w') as file:
         file.write(newContents)

def restartClash():
     os.system('docker restart clash')

def main():
    statusCode ,contents = getData(url)
    if statusCode != 200:
        print('获取订阅失败，请检查订阅链接')
    else:
        print('获取订阅成功')
        processData(contents)
        print('更新订阅成功')
        restartClash()

if __name__ == '__main__':
    main()

