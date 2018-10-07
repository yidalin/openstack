#!/bin/bash

source ~/demo-openrc

openstack volume create --size 1 --description "Demo's volume" demoVol
