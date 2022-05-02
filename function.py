import requests
import time
import csv
import json
import math

def bing_reptile(numbers):
  bing_api_url = 'https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=' + str(numbers) + '&mkt=zh-CN'
  response  =  requests.get(bing_api_url)
  data  =  response.json()
  for i in range(numbers):
    image_info = (data['images'])[i]
    image_url = image_info['url']

    url = 'https://cn.bing.com' + image_url
    with open('/home/mln/Pictures/' + str(i) + '.jpg','wb')as f: 
      response = requests.get(url)
      f.write(response.content)



def local_time():
  return  time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())



def weather():
  url = 'https://devapi.qweather.com/v7/weather/now?location=101110509&key=bb6d9d9b301c40ac9ac69852710bfc1a'
  response = requests.get(url)
  weather_data = response.json()
  return (weather_data['now'])


def csv2dict(filename):
    devices_dict = []
    with open(filename,'r') as f:
        csvreader = csv.reader(f)
        header = next(csvreader)
        for device_csv in csvreader:
            result = dict(zip(header,device_csv))
            devices_dict.append(result)
    return devices_dict

def dict2csv_save(filename,devices_dict):
    header = devices_dict[0].keys()
    devices_csv = []
    for device_dict in devices_dict:
        result = device_dict.values()
        devices_csv.append(result)
    with open(filename,'w') as f:
        f_csv = csv.writer(f)
        f_csv.writerow(header)
        f_csv.writerows(devices_csv)

def json2dict(filename):
    devices_dict = []
    with open(filename,'r') as f:
        jsonreader = json.load(f)
        for device_json in jsonreader:
            devices_dict.append(device_json)
    return devices_dict

def dict2json_save(filename,devices_dict):
    with open(filename,'w') as f:
        json.dump(devices_dict,f)

def csv2json(filename1,filename2):
    dict2json_save(filename2,csv2dict(filename1))

def json2csv(filename1,filename2):
    dict2csv_save(filename2,json2dict(filename1))


def Hamming_encode(number):

  Check_code_length = 2

  #计算海明码长度
  while len(number) + Check_code_length + 1 > 2 ** (Check_code_length):
      Check_code_length = Check_code_length + 1
  Hamming_code_length = Check_code_length + len(number)

  #初始化海明码为全0列表
  Hamming_code = [0 for i in range(Hamming_code_length)]

  #计算校验位和信息位
  Check_bits = []
  Information_bits = []
  for i in range(0,Hamming_code_length):
      if math.log2(i + 1) % 1 == 0:
          Check_bits.append(i)
      else :
          Information_bits.append(i)

  #将数据位信息添加到海明码列表中,并计算数据位与校验位关系
  i = 0
  Information_bit_bins = [] 
  for Information_bit in Information_bits:
      Hamming_code[Information_bit] = int(number[i])
      i = i + 1
      Information_bit_bins.append(bin(Information_bit + 1).replace('0b',''))
    
  for i in range(0,Check_code_length):
      flag =0
      for j in range(0,len(Information_bit_bins)):
          Information_bit_bin= Information_bit_bins[j]  
          if len(Information_bit_bin)-1-i >= 0 and int(Information_bit_bin[len(Information_bit_bin)-1-i]) == 1 and int(number[j]) == 1:
              flag = flag + 1
      Hamming_code[Check_bits[i]] = flag % 2
  H = [str(i) for i in Hamming_code]
  return (''.join(H))


def XOR(str1, str2):  # 实现模2减法
    ans = ''
    if str1[0] == '0':
        return '0', str1[1:]
    else:
        for i in range(len(str1)):
            if (str1[i] == '0' and str2[i] == '0'):
                ans = ans + '0'
            elif (str1[i] == '1' and str2[i] == '1'):
                ans = ans + '0'
            else:
                ans = ans + '1'
    return '1', ans[1:]

def CRC_Encoding(str1,str2):  # CRC编码
    lenght = len(str2)
    str3 = str1 + '0' * (lenght - 1)
    ans = ''
    yus = str3[0:lenght]
    for i in range(len(str1)):
        str4, yus = XOR(yus, str2)
        ans = ans + str4
        if i == len(str1) - 1:
            break
        else:
            yus = yus + str3[i + lenght]
    return str1 + yus

def CRC_Decoding(str1, str2):  # CRC解码
    lenght = len(str2)
    str3 = str1 + '0' * (lenght - 1)
    ans = ''
    yus = str3[0:lenght]
    for i in range(len(str1)):
        str4, yus = XOR(yus, str2)
        ans = ans + str4
        if i == len(str1) - 1:
            break
        else:
            yus = yus + str3[i + lenght]
    return yus == '0' * len(yus)
    
def route(local_route_list,route_list,local_route_id,route_id):
    for route in route_list:
        flag = 0
        if route['目的地址'] == local_route_id:
            continue
        for local_route in local_route_list:
            if local_route['目的地址'] == route['目的地址'] and int(route['距离']) + 1 < int(local_route['距离']):
                local_route['下一跳'] = route_id
                local_route['距离'] = str(int(route['距离']) + 1)
                flag = 1
                break
            elif local_route['目的地址'] == route['目的地址'] and int(route['距离']) + 1 >= int(local_route['距离']):
                flag = 1 
                break
        if flag == 0:
            route['距离'] = str(int(route['距离']) + 1)
            route['下一跳'] = route_id
            local_route_list.append(route)
    return local_route_list
