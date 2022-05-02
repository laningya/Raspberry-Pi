import requests

def bing_reptile(number):
  bing_api_url = 'https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=' + str(number) + '&mkt=zh-CN'
  response  =  requests.get(bing_api_url)
  data  =  response.json()
  for i in range(number):
    image_info = (data['images'])[i]
    image_url = image_info['url']

    url = 'https://cn.bing.com' + image_url
    with open('/home/mln/Pictures/' + str(i) + '.jpg','wb')as f: 
      response = requests.get(url)
      f.write(response.content)
if __name__ == '__main__':
  bing_reptile(8)
