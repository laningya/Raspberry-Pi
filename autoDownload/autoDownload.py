#!/usr/bin/python3
import os
import sys
import requests
from urllib.parse import urlparse
from urllib.parse import quote
from urllib.parse import unquote
from bs4 import BeautifulSoup


class AutoDownload:
    def __init__(self,url):
            self.url = url
    # 提取出url中的协议、域名、端口
    def extract_protocol_domain_port(self):

        parsed_url = urlparse(self.url)
        protocol = parsed_url.scheme
        domain = parsed_url.hostname
        port = parsed_url.port
        if not port:
            if protocol == 'http':
                port = 80
            elif protocol == 'https':
                port = 443
        return protocol, domain, port


    def extract_links_from_html(self,html_content):
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

    def get_dir_content(self):
        # 获取当前工作目录
        current_directory = os.getcwd()

        # 获取当前目录下的所有文件和文件夹名称
        files_and_folders = os.listdir(current_directory)

        # 过滤出当前目录下的所有文件名称
        files = [file for file in files_and_folders if os.path.isfile(os.path.join(current_directory, file))]

        return files
    def get_dirs(self):

        folders = [folder for folder in os.listdir() if os.path.isdir(folder)]
        return folders

    def get_dir_name(self,href_content):

        last_occurrence = href_content.rfind('/')
        second_last_occurrence = href_content.rfind('/', 0, last_occurrence)
        dir_name = href_content[second_last_occurrence + 1:last_occurrence]
        return unquote(dir_name, encoding='utf-8')

    def main(self):

        if self.url[-1] != '/':
            os.system('wget ' + self.url)
        else:
            data = requests.get(self.url)

            if data.status_code != 200:
                print('请检查url')
                exit(0)
            else:
                #检查文件夹是否存在
                dir_name = self.get_dir_name(self.url)
                folders = self.get_dirs()
                current_dir = os.getcwd()
                if dir_name not in folders:
                    os.makedirs(dir_name)
                os.chdir(current_dir + '/' + dir_name)

                #编码目录下的文件名
                files_encoding = []
                files = self.get_dir_content()
                for file in files:
                    files_encoding.append(quote(file, encoding='utf-8'))
                #获取协议、域名、端口
                protocol, domain, port = self.extract_protocol_domain_port()
                #print(protocol, domain, port)
                url = protocol + '://' + domain +':'+ str(port)
                #print(url)

                href_contents = self.extract_links_from_html(data.text)
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
                        self.url = _url
                        self.main()
                        continue
                    else:
                        os.system('wget ' + _url)
                os.chdir(current_dir)

if __name__ == '__main__':
    arguments = sys.argv
    len_cmd = len(arguments)
    if len_cmd == 1:
        print('请输入url:',end = '')
        url = input()
    elif len_cmd == 3:
        if arguments[1] == '-l':
            url = arguments[2]
    else:
        print('输入不合法')
        exit(0)
    autoDownload = AutoDownload(url)
    autoDownload.main()
