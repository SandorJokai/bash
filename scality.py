# This is a nice way of how we can fetch datas from a website's API. In order to script let work, we need to have a file called
# .credentials storing the username/passwd in JSON format.

#!/usr/bin/python3.8

# requirements: pip install requests, hurry.filesize, etc.
import json
import requests
from requests.auth import HTTPBasicAuth
from requests.packages.urllib3.exceptions import InsecureRequestWarning
# this module will convert the numbers from bytes to terabyte. If we need si values rather, just add si after "size" below as well as when we call the print function
from hurry.filesize import size, si

# this method suppress the warning about ssl complaining
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# get the credentials from an external file
with open('.credentials',) as file:
  credfile = json.load(file)
  for k, v in credfile.items():
    if k == "user":
      user = v
    else:
      pw = v

response = requests.get('https://sup01.scality.fasthosts.net.uk/api/v0.1/rings/?limit=20', verify=False,
            auth=HTTPBasicAuth(user, pw))

data = response.json()

def get_names(Name, dict):
  print()
  print(Name)
  for k, v in dict.items():
    if k == "diskspace_used":
      diskused = v
      du = k + " for " + Name + "       : " + size(v, si) + "  ==> "
    elif k == "diskspace_total":
      disktotal = v
      dt = k + " for " + Name + "      : " + size(v, si)
    elif k == "diskspace_available":
      da = k + " for " + Name + "  : " + size(v, si)

  perc = diskused / disktotal
  print(du,format( perc,".2f"), "%")
  print(dt)
  print(da)
  print()

# data variable is a dictionary, but data['_items'] is a list.
for dict in data['_items']:
  get_names(dict['id'], dict)
