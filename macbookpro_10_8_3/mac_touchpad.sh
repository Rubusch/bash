## synaptics touchpad settings
## -d   daemon
## -t   stop tapping when writing
## -i 2 for 2 secs
echo "setting up syndaemon"
kill $( pidof syndaemon ) 2> /dev/null
syndaemon -d -t -i 2

## local touchpad settings
echo "setting up synclient, local touchpad"
synclient TapButton1=1
synclient TapButton2=2
#synclient TapButton3=3
synclient FingerHigh=50
#synclient TapAndDragGesture=0
synclient LBCornerButton=0
synclient LTCornerButton=0
synclient RBCornerButton=0
synclient RTCornerButton=0
synclient PalmDetect=1
