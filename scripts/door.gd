extends Node2D

@export var location = "debug"

var close = preload("res://sfx/door_close.mp3")
var orig_stream = preload("res://sfx/door_open.mp3")

@onready var sprite = $"Door"
@onready var timer = $"Timer"
@onready var sfx = $"AudioStreamPlayer2D"

func _ready():
	sprite.process_mode = Node.PROCESS_MODE_ALWAYS
	sfx.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_area_2d_body_entered(body):
	sfx.stream = orig_stream
	sfx.play()
	
	match body.name:
		"Robot":
			body.queue_free()
			Lib.play_move = true
			Lib._set_subtitle("[img]res://icons/Mouse_Left_Key_Light.png[/img]grow")
			timer.start(1)
		"player":
			Lib._change_scene(location)

	sprite.play("default")

func _on_timer_timeout():
	sfx.stream = close
	sfx.play()
	sprite.play_backwards("default")
	timer.stop()
