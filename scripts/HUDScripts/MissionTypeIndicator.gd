extends RichTextLabel

func set_vars(mssnNum, mssnName, mssnInfo):
	text = "[center] Mission " + str(mssnNum) + ": " + str(mssnName) + " (" + str(mssnInfo) + ")[/center]"
