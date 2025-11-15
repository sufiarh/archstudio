#!/bin/bash

# CPU temp (dari k10temp, Tctl)
cpu_temp=$(sensors | grep 'Tctl' | awk '{print $2}' | tr -d '+°C')
cpu_temp=$(printf "%.0f" "$cpu_temp" 2>/dev/null)

# GPU temp (dari amdgpu, edge)
gpu_temp=$(sensors | grep 'edge' | head -n1 | awk '{print $2}' | tr -d '+°C')
gpu_temp=$(printf "%.0f" "$gpu_temp" 2>/dev/null)

# Safety check kalau kosong
[ -z "$cpu_temp" ] && cpu_temp="N/A"
[ -z "$gpu_temp" ] && gpu_temp="N/A"

# Output ke waybar
echo "󰾆 ${cpu_temp}°C  ${gpu_temp}°C"
