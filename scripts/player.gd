extends RigidBody2D

const SPEED = 500
const GRAVITY = 10
const JUMP_VEL = 500

const ORIG_COLI = 20

const MAX_SIZE = 40
const MIN_SIZE = 7

const SCALE_SPEED = 70

var normalising = false
var on_floor = false
var previous_rotation = 0

var can_sfx = true

@onready var collider = $"CollisionShape2D"
@onready var sprite = $"Sprite2D"
@onready var area = $"GroundCheck"
@onready var camera = $"Camera2D"
@onready var roof_check = $"RoofCheck"
@onready var sfx = $"AudioStreamPlayer2D"
@onready var sfx_check = $"SfxCheck"
@onready var particle = $"CPUParticles2D"
@onready var stretch = $"AudioStreamPlayer2D2"

func _ready():
	collider.shape.radius = ORIG_COLI

func _physics_process(delta: float) -> void:
	particle.global_position = Vector2(global_position.x, global_position.y + collider.shape.radius)
	particle.global_rotation = 0
	
	if area.is_colliding():
		particle.emitting = true
	
	if Lib.play_move:
		Lib.player_pos = position
		sfx.pitch_scale = randf_range(0.9, 1.1)
		
		if sfx_check.is_colliding() and can_sfx:
			sfx.play()
			can_sfx = false
		elif !sfx_check.is_colliding():
			can_sfx = true
		
		if Input.is_action_pressed("move_l"):
			linear_velocity.x -= SPEED * delta
		elif Input.is_action_pressed("move_r"):
			linear_velocity.x += SPEED * delta
		
		if Input.is_action_just_pressed("jump") and area.is_colliding():
			linear_velocity.y = -JUMP_VEL
		
		if Input.is_action_pressed("scale_up") and !normalising and (!roof_check.is_colliding() or roof_check.get_collider().is_in_group("cage")):
			if collider.shape.radius < MAX_SIZE - 0.05:
				if !stretch.playing:
					stretch.play()
				
				collider.shape.radius += SCALE_SPEED * delta
			else:
				collider.shape.radius = MAX_SIZE
				stretch.stop()
			
			if Lib.subtitle_on:
				Lib._fade_subtitle()
		elif Input.is_action_pressed("scale_down") and !normalising:
			if collider.shape.radius > MIN_SIZE + 0.05:
				if !stretch.playing:
					stretch.play()
				
				collider.shape.radius -= SCALE_SPEED * delta
			else:
				collider.shape.radius = MIN_SIZE
				stretch.stop()
		
			if Lib.subtitle_on:
				Lib._fade_subtitle()
		else:
			stretch.stop()
		
		if Input.is_action_pressed("normalise"):
			normalising = true
		
		if normalising  and !roof_check.is_colliding():
			if collider.shape.radius <= 19.1 or collider.shape.radius >= 20.1:
				collider.shape.radius = lerpf(collider.shape.radius, ORIG_COLI, 10 * delta)
			else:
				normalising = false
		
		previous_rotation = rotation
		
		var texture_size = sprite.texture.get_size()
		var scale_factor = (collider.shape.radius * 2) / texture_size.x
		
		sprite.scale = Vector2(scale_factor, scale_factor)
		area.rotation = -rotation
		camera.rotation = -rotation
		roof_check.rotation = -rotation
		
		var cam_zoom = (MAX_SIZE / (ORIG_COLI / 2)) - (collider.shape.radius / (ORIG_COLI / 2))
		camera.zoom.x = clamp(cam_zoom, 1, MAX_SIZE / (ORIG_COLI / 2))
		camera.zoom.y = clamp(cam_zoom, 1, MAX_SIZE / (ORIG_COLI / 2))
		
		area.target_position.y = collider.shape.radius + 1
		roof_check.target_position.y = -collider.shape.radius - 50
		sfx_check.target_position.x = collider.shape.radius + 1
