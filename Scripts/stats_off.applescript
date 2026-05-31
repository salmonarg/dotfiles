try
	do shell script "killall Stats"
end try
delay 0.5
do shell script "defaults write eu.exelban.Stats Sensors_state -int 0"
tell application "Stats" to activate