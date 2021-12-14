#!/usr/bin/env python3

import os
import sys

if (len(sys.argv) ==2):
    repopath = sys.argv[1]
else:
    print("Usage: script.py repository_path")
    exit(1)

if (not os.path.exists(repopath+"/.git")):
    print("Path is not a repository")
    exit(2)

bash_command = [f"cd {repopath}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = os.path.expanduser(repopath) + "/" + result.replace('\tизменено:   ', '').strip()
        print(prepare_result)