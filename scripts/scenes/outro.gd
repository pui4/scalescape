extends Node2D

func _ready():
	$"Control/RichTextLabel".text = "[center]FINAL SCORE:[rainbow freq-.2 stat=0.8 val=.5][wave amp=100 freq=3] " + str(Lib.score)
	
	var seconds = floor(Time.get_ticks_msec() / 1000)
	var minutes = floor(seconds / 60)
	var display_sec = seconds - minutes * 60
	if display_sec < 10:
		display_sec = "0" + str(display_sec)
	
	$"Control/RichTextLabel2".text = "[center]FINAL TIME:[rainbow freq-.2 stat=0.8 val=.5][wave amp=100 freq=3] " + str(minutes) + ":" + str(display_sec)
