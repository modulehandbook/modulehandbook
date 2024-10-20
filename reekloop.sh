#!/bin/bash

while true; do
    clear
    reek
    fswatch -1 .reek.yml
done