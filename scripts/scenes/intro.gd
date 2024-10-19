extends Node2D

@onready var robot = $"Robot"
@onready var robot_sprite = $"Robot/sprite"
@onready var timer = $"Timer"

const ROBOT_SPEED = 70

var robot_moving = false

func _physics_process(delta):
	if robot_moving and robot != null:
		robot.position.x += ROBOT_SPEED * delta

func _on_timer_timeout():
	if robot != null:
		robot_sprite.flip_h = false
		robot_sprite.play("run")
		robot_moving = true
