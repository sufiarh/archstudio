#!/bin/bash
sensors | grep 'Tctl' | awk '{print $2}' | tr -d '+' | awk -F. '{print $1}'

