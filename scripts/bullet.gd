extends Node2D

const BULL_SPEED = 1000
const MAX_LENGTH = -21

@onready var trail = $"Container/Line2D"
@onready var orig_pos = get_parent().get_node("./enemy_body/sprite/Sprite2D/Marker2D").global_position
@onready var sfx = $"AudioStreamPlayer2D"
@onready var bullet = $"Container"

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * BULL_SPEED * delta
	
	if trail != null:
		trail.points[0].x = clampf(-orig_pos.distance_to(global_position) / 2, MAX_LENGTH, 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "enemy_body":
		bullet.queue_free()
		if body.name == "player":
			Lib.score -= 1
			sfx.pitch_scale = randf_range(0.9, 1.1)
			sfx.play()
