#!/usr/bin/env python3

import socket
import json


servers = {"drive.google.com":"", "mail.google.com":"", "google.com":""}

while True:
    for srvname, srvaddr in servers.items():
        ip_addr=socket.gethostbyname(srvname);
        if(srvaddr==""):
            servers[srvname]=ip_addr
            print(f"{srvname} - {ip_addr}")
        else:
            if(srvaddr!=ip_addr):
                print("[ERROR] {} IP missmatch: {} {}".format(srvname,srvaddr,ip_addr))
                servers[srvname] = ip_addr