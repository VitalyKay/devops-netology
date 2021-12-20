#!/usr/bin/env python3

import json
import socket
import time

import yaml

servers = {"drive.google.com":"", "mail.google.com":"", "google.com":""}

while True:
    for srvname, srvaddr in servers.items():
        ip_addr = socket.gethostbyname(srvname);
        if (srvaddr == ""):
            servers[srvname] = ip_addr
            print(f"{srvname} - {ip_addr}")
        else:
            if (srvaddr != ip_addr):
                # print("[ERROR] {} IP missmatch: {} {}".format(srvname,srvaddr,ip_addr))
                servers[srvname] = ip_addr
    with open('services.json', 'w') as sj:
        sj.write(json.dumps(servers, indent=2))
    with open('services.yml', 'w') as sy:
        sy.write(yaml.dump(servers, indent=2, explicit_start=True, explicit_end=True))
    time.sleep(1)
