#!/usr/bin/env python3

import os
import sys
import subprocess

def main():
    default_sink = subprocess.check_output(["pactl", "get-default-sink"]).decode('utf-8').strip()
    raw_lines = subprocess.check_output(["pactl", "list", "short", "sinks"]).decode('utf-8')

    ds_num = None
    sinks = []

    for line in raw_lines.strip().split('\n'):
        line = line.split('\t')

        if line[1] == default_sink:
            ds_num = int(line[0])
        else:
            sinks.append([int(line[0]), line[1]])

    for sink in sinks:
        if sink[0] > ds_num:
            subprocess.call(["pactl", "set-default-sink", sink[1]])
            subprocess.call(["notify-send", "new default sink: " + sink[1]])
            sys.exit(0)

    subprocess.call(["pactl", "set-default-sink", sinks[0][1]])
    subprocess.call(["notify-send", "new default sink: " + sinks[0][1]])
    sys.exit(0)

if __name__ == '__main__':
    main()
