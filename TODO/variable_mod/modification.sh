#!/bin/bash

## modify variable

var="PeriApp-1.2.3_p1.ebuild"
var="PeriApp-1.2.3_p2.ebuild"
echo "var '$var'"
echo

var=${var//_p[0-9]}
echo "var '$var'"
echo


echo "READY."