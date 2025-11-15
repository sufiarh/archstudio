#!/bin/bash
sensors | grep 'edge' | awk '{print $2}' | tr -d '+' | awk -F. '{print $1}'

