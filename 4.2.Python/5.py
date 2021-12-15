#!/usr/bin/env python3
from github import Github
import os

token = "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"
remoterepo = "VitalyKay/testrepo"
branchname = "newconf"

body = "New Configuration"

local_repo = "~/testrepo"
minusb = " -b"

g = Github(token)

bash_command = [f"cd {local_repo}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        bash_command = f"cd {local_repo} && git branch"
        result_os = os.popen(bash_command).read()
        for ex_br in result_os.split('\n'):
            if ex_br.find("newconf") != -1:
                minusb = ""
        bash_command = f"cd {local_repo} && git checkout{minusb} {branchname} && git commit -am 'New Config#50' && " \
                       f"git push -u origin {branchname}"
        if os.system(bash_command) != 0:
            print("Push error")
            break
        repo = g.get_repo(remoterepo)
        pr = repo.create_pull(title="New Config", body=body, head=branchname, base="main")
        print(pr.title+" "+str(pr.number))
        break
