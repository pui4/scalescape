extends Node

var player_pos
var play_move = false
var score = 0

var subtitle_on = false
signal set_subtitle
signal fade_subtitle

var curret_scene = null
var target_scene
signal fade_ui
signal at_end
var final_time

@onready var view = get_tree().root.get_node("./main/SubViewportContainer/SubViewport")
@onready var ui = get_tree().root.get_node("./main/ui")

func _ready():
	view.process_mode = Node.PROCESS_MODE_ALWAYS

func _set_subtitle(text):
	set_subtitle.emit(text)
	subtitle_on = true

func _fade_subtitle():
	fade_subtitle.emit()
	subtitle_on = false

func _change_scene(scene):
	get_tree().paused = true
	target_scene = scene
	play_move = false
	fade_ui.emit(false)

func fade_anim_finished(name):
	if name == "fade_in":
		print("res://levels/" + target_scene + ".tscn")
		view.get_child(0).queue_free()
		curret_scene = load("res://levels/" + target_scene + ".tscn").instantiate()
		view.add_child(curret_scene)
		fade_ui.emit(true)
	elif name == "fade_out":
		if target_scene == "outro":
			at_end.emit()
			ui.visible = false
		get_tree().paused = false
		play_move = true

func reset_lib_values():
	play_move = false
	score = 0
	ui.visible = true
