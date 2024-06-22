extends VBoxContainer

var fadeSpeed = 0.2 

var main_message: RichTextLabel
var sub_message: RichTextLabel

func set_vars(mnMssg, sbMssg):
	main_message = $MainMessage
	sub_message = $SubMessage
	
	main_message.text = "[center]" + mnMssg + "[/center]"
	sub_message.text = "[center]" + sbMssg + "[/center]"

func _process(delta):
	if(modulate.a > 0):
		modulate.a -= fadeSpeed * delta
	else:
		free()
