#!/bin/bash
sudo nmap -sn -PU -PA53,161,162 $1
