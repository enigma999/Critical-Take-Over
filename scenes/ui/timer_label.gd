extends Label

func SetTimerFromSeconds(seconds: int)->void:
	var min = seconds/60
	var sec = seconds%60
	var min_str = str(min)
	var sec_str = str(sec)
	if min < 10:
		min_str = "0" + min_str
	if sec < 10:
		sec_str = "0" + sec_str
	text = str(min_str) + ":" + str(sec_str)
