#!/usr/bin/env python3
import json
import os
import sys
import yaml

data = dict()


def read_json(fd):
    global data
    try:
        data = json.load(fd)
    except json.JSONDecodeError as jexc:
        if jexc.pos == 0:
            print("File is not JSON!")
            return 2
        else:
            print("JSON error in position " + str(jexc.pos))
            return 1
    else:
        print("File is good JSON")
        return 0


def read_yaml(fd):
    global data
    try:
        data = yaml.safe_load(fd)
    except yaml.YAMLError as yexc:
        if hasattr(yexc, 'problem_mark'):
            mark = yexc.problem_mark
            print(f"YAML Error position: ({mark.line}:{mark.column})")
            return 1
        else:
            print("File is not YAML")
            return 2
    else:
        print("File is good YAML")
        return 0


if len(sys.argv) == 2:
    convfile = sys.argv[1]
    filename, file_extension = os.path.splitext(convfile)
    print(file_extension)
    if os.path.isfile(convfile) and (file_extension == ".json" or file_extension == ".yml"):
        result = 2
        result1 = 2
        with open(convfile, 'r') as cf:
            result = read_json(cf)
        # сделал по условию тк json - подмножество yaml
        if result == 2:
            with open(convfile, 'r') as cf:
                result1 = read_yaml(cf)

        if result == 0 or result1 == 0:
            print(data)
            with open(filename + ".json", 'w') as wjf:
                wjf.write(json.dumps(data))
            with open(filename + ".yml", 'w') as wyf:
                wyf.write(yaml.dump(data))
    else:
        print("File is not *.json or *.yml")
        exit(2)
else:
    print("Usage: script.py *.[jsom|yml]")
    exit(1)
