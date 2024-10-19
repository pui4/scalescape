extends Area2D

@export var text = "poop"

func _on_body_entered(body):
	if body.name == "player":
		Lib._set_subtitle(text)
