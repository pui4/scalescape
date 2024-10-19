extends Control

@onready var label = $"RichTextLabel"
@onready var anim = $"AnimationPlayer"
@onready var score = $"RichTextLabel2"
@onready var time_label = $"RichTextLabel3"

func _ready():
	anim.process_mode = Node.PROCESS_MODE_ALWAYS
	Lib.set_subtitle.connect(_set_subtitle)
	Lib.fade_subtitle.connect(_fade_subtitle)
	Lib.fade_ui.connect(_fade)

func _process(delta):
	score.text = "SCORE:[rainbow freq-.2 stat=0.8 val=.5][wave amp=100 freq=3] " + str(Lib.score)
	
	var seconds = floor(Time.get_ticks_msec() / 1000)
	var minutes = floor(seconds / 60)
	var display_sec = seconds - minutes * 60
	if display_sec < 10:
		display_sec = "0" + str(display_sec)
	
	time_label.text = "TIME:[rainbow freq-.2 stat=0.8 val=.5] " + str(minutes) + ":" + str(display_sec)

func _set_subtitle(text):
	label.visible = true
	anim.play("fade_in_subtitle")
	label.text = "[center]" + text

func _fade_subtitle():
	anim.play("fade_out_subtitle")

func _fade(out):
	anim.play("fade_out_subtitle", -1, 1000000)
	if !out:
		anim.play("fade_in")
	else:
		anim.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	Lib.fade_anim_finished(anim_name)
	if anim_name == "fade_in":
		label.visible = false
