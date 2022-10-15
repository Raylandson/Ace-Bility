extends Node2D

onready var active = false
export(NodePath) onready var player = get_node(player)
var initial_player_pos := Vector2.ZERO
var initial_rotation : float


func _ready():
	initial_player_pos = player.global_position
	initial_rotation = player.rotation


func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed('pause') and not active:
		pause_game()
	
	if event.is_action_pressed("reset"):
		if active:
			pause_game()
		reset_player()


func pause_reset() -> void:
	if active:
		pause_game()
		reset_player()
	else:
		pause_game()

func pause_game() -> void:
	active = !active
	Autoload.current_state = int(active)


func reset_player() -> void:
	player.global_position = initial_player_pos
	player.rotation = initial_rotation
