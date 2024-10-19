extends Node2D

const ENEM_GRAVITY = 10
const GUN_SPEED = 10
const SP_ORIG = 0.415

var bullet = preload("res://assets/bullet.tscn")
var dead = preload("res://sfx/dead_robot.wav")

@onready var enemy_body = $"enemy_body"
@onready var paricles = $"GPUParticles2D"
@onready var sprite = $"enemy_body/sprite"
@onready var gun = $"enemy_body/sprite/Sprite2D"
@onready var timer = $"Timer"
@onready var marker = $"enemy_body/sprite/Sprite2D/Marker2D"
@onready var sfx = $"AudioStreamPlayer2D"

func _physics_process(delta: float) -> void:
	if enemy_body != null and !get_tree().paused:
		sfx.pitch_scale = randf_range(0.9, 1.1)
		
		if enemy_body.global_position.x - Lib.player_pos.x < 0:
			sprite.scale.x = SP_ORIG
			gun.rotation = rotate_toward(gun.rotation, gun.global_position.direction_to(Lib.player_pos).angle(), delta * GUN_SPEED)
		else:
			sprite.scale.x = -SP_ORIG
			gun.rotation = rotate_toward(gun.rotation, PI - gun.global_position.direction_to(Lib.player_pos).angle(), delta * GUN_SPEED)
		
		if !enemy_body.is_on_floor():
			enemy_body.velocity.y += ENEM_GRAVITY
		
		var collision = enemy_body.move_and_collide(enemy_body.velocity * delta)
		if collision and collision.get_collider().name == "player":
			print(collision.get_collider().linear_velocity.y)
			if collision.get_collider().linear_velocity.length() >= 100 or collision.get_collider().linear_velocity.y <= -1:  # Check the length of velocity
				paricles.emitting = true
				sfx.stream = dead
				sfx.play()
				enemy_body.queue_free()
				Lib.score += 100
		
		paricles.position = enemy_body.position

func _on_timer_timeout() -> void:
	if enemy_body != null and !get_tree().paused:
		sfx.play()
		var bul = bullet.instantiate()
		add_child(bul)
		bul.global_position = marker.global_position
		bul.rotation = marker.global_rotation
		timer.start(randf_range(0.9, 1.1))
