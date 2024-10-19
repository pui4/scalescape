extends Node2D

@onready var sfx = $"AudioStreamPlayer2D"
var done = false

func _physics_process(delta):
	if !done and !get_tree().paused:
		sfx.play()
		done = true
