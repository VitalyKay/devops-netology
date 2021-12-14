#!/usr/bin/env python3

import os

repopath = "~/testrepo"

bash_command = [f"cd {repopath}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = os.path.expanduser(repopath) + "/" + result.replace('\tизменено:   ', '').strip()
        print(prepare_result)