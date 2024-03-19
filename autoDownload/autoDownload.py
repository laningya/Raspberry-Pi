#!/usr/bin/python3
import requests
from urllib.parse import urlparse
from urllib.parse import quote
from urllib.parse import unquote
from bs4 import BeautifulSoup
import os

# 提取出url中的协议、域名、端口
def extract_protocol_domain_port(url):

    parsed_url = urlparse(url)
    protocol = parsed_url.scheme
    domain = parsed_url.hostname
    port = parsed_url.port
    if not port:
        if protocol == 'http':
            port = 80
        elif protocol == 'https':
            port = 443
    return protocol, domain, port


def extract_links_from_html(html_content):
    # 使用BeautifulSoup解析HTML内容
    soup = BeautifulSoup(html_content, 'html.parser')
    # 查找所有<a>标签
    a_tags = soup.find_all('a')
    # 提取超链接
    links = []
    for a_tag in a_tags:
        link = a_tag.get('href')
        if link:
            links.append(link)
    return links

def get_dir_content():
    # 获取当前工作目录
    current_directory = os.getcwd()

    # 获取当前目录下的所有文件和文件夹名称
    files_and_folders = os.listdir(current_directory)

    # 过滤出当前目录下的所有文件名称
    files = [file for file in files_and_folders if os.path.isfile(os.path.join(current_directory, file))]

    return files

def main(url):

    data = requests.get(url)

    if data.status_code != 200:
        print('请检查url')
        exit(0)
    else:
        #编码当前目录下的文件名
        files_encoding = []
        files = get_dir_content()
        for file in files:
            files_encoding.append(quote(file, encoding='utf-8'))
        #获取协议、域名、端口
        protocol, domain, port = extract_protocol_domain_port(url)
        #print(protocol, domain, port)
        url = protocol + '://' + domain +':'+ str(port)
        #print(url)

        href_contents = extract_links_from_html(data.text)
        #print(href_contents)

        #去除顶部的超链接
        flag = href_contents.index('..')
        href_contents = href_contents[flag + 1:]

        #去除重复的文件内容
        for file_encoding in files_encoding:
            for href_content in href_contents:
                if file_encoding in href_content:
                    href_contents.remove(href_content)
                    break

        #下载文件
        for href_content in href_contents:
            _url = url + href_content
            #进行目录下载
            if href_content[-1] == '/':
                last_occurrence = href_content.rfind('/')
                second_last_occurrence = href_content.rfind('/', 0, last_occurrence)
                dir_name = href_content[second_last_occurrence + 1:last_occurrence]
                dir_name = unquote(dir_name,encoding='utf-8')
                #print(dir_name)
                current_dir = os.getcwd()
                os.system('mkdir ' + dir_name)
                os.chdir(current_dir + '/' + dir_name)
                print(os.getcwd())
                main(_url)
                os.chdir(current_dir)
                continue
            else:
                os.system('wget ' + _url)

print('请输入url：')
url = input()
main(url)
