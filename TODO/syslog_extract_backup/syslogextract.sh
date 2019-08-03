#!/bin/bash

function die()
{
    echo "$@"
    exit 1
}

## set marker
TestsuiteMarker="Testsuite1234567"
logger "Testsuite $TestsuiteMarker started"

logger "some test tututututu.."

## set marker
logger "Testsuite $TestsuiteMarker ended"

## testsuite failed - extract log information
awk -v testsuite="$TestsuiteMarker" -f extractTestLogs.awk < /var/log/syslog > ./extracted.syslog || die "awk failed, $! "

echo "READY."

