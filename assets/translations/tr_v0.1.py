#!C:/Programs/Python38-32/python.exe
import re

with open("en.json", 'r', encoding="utf8") as file_en:
    lines_en = re.findall(r'\"[A-Z_]+\": \"[\S| ]+\"', file_en.read())

with open("hu.json", 'r', encoding="utf8") as file_hu:
    lines_hu = re.findall(r'\"[A-Z_]+\": \"[\S| ]+\"', file_hu.read())

for i in range(0, min(len(lines_en), len(lines_hu))):
    separator_en = lines_en[i].find(": ")
    key_en = lines_en[i][0:separator_en].strip()
    value_en = lines_en[i][separator_en+2:].strip()
    #print (key_en)
    print (value_en)
    separator_hu = lines_hu[i].find(": ")
    key_hu = lines_hu[i][0:separator_hu].strip()
    value_hu = lines_hu[i][separator_hu+2:].strip()
    #print (key_hu)
    print (value_hu)
    if(key_en != key_hu):
        print(i)
        print("-"*40)
    #    raise SystemExit(1)
    if value_en == value_hu and (value_en.lower() != "null,"):
        print(i)
        print("="*40)
    #    raise SystemExit(2)
    