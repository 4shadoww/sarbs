#!/usr/bin/env bash

pactl set-sink-volume $(pactl list short sinks | grep "RUNNING" | awk '{ print $1 }' | head -n1) $1
