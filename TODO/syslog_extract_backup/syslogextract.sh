#!/bin/bash -e
##
## needs sudo permissions
##

function die()
{
    echo "$@"
    exit 1
}

## set marker
TestsuiteMarker="Testsuite1234567"
sudo logger "Testsuite $TestsuiteMarker started"
sudo logger "some test tututututu.."

## set marker
sudo logger "Testsuite $TestsuiteMarker ended"

## testsuite failed - extract log information
sudo sh -c 'awk -v testsuite=$TestsuiteMarker -f extractTestLogs.awk < /var/log/syslog > ./extracted_syslog.log || die "awk failed, $! "'


echo "RESULT:"
sudo chown $(whoami).$(whoami) ./extracted_syslog.log
nl ./extracted_syslog.log

echo
echo "READY."

