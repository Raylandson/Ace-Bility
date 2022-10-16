extends Node2D

onready var active = false
export(NodePath) onready var player = get_node(player)
var initial_player_pos := Vector2.ZERO
var initial_rotation : float
var block_types = {
	'bridge' : 0,
	'ramp' : 2
}
export(String, 'bridge', 'ramp') var current_block = 'ramp'

export(OpenSimplexNoise) var noise_test

func _ready():
	randomize()
	initial_player_pos = player.global_position
	initial_rotation = player.rotation
	noise_test.seed = randi()
	generate_map()



var hole_freq = randi() % 30 + 30
var hole_len = randi() % 6 + 2

var obstacle_freq = randi() % 10 + 10
var obstacle_len = randi() % 2 + 3

func generate_map():
#	inicio = 0, 760
	
	for c in range(20000):
		var perlin_test = noise_test.get_noise_2d(c, 0.0)
#		print(perlin_test * 10)
#		print(randi() % 20 + 20)
		
		hole_freq -= 1
		if hole_freq < -hole_len:
			hole_freq = randi() % 30 + 30
			hole_len = randi() % 2 + 4
		
		if hole_freq > 0:
			if hole_freq -5 > 0:
				obstacle_freq -= 1
			if obstacle_freq < 0:
				for a in range(1, obstacle_len + 1):
					$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10 - a, false)
					obstacle_freq = randi() % 10 + 10
					obstacle_len = randi() % 2 + 4
#					print(obstacle_len)
					
			$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10, false)
		
			for x in range(1, 8):
				$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10 + x, false)




func _input(event):
	if event.is_action_pressed('pause') and not active:
		pause_game()
		GameEvents.emit_signal("started")
	
	if event.is_action_pressed("reset"):
		if active:
			pause_game()
		reset_player()
		GameEvents.emit_signal("reset")
	
	
	if event.is_action_pressed("change_block"):
		for key in block_types.keys():
			if current_block != key:
				current_block = key
				break
	
	
	if event.is_action_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var player_pos = player.global_position
		var not_in_player = abs(mouse_pos.x - player_pos.x) > 24 and abs(mouse_pos.y - player_pos.y) > 48
		var botton_tile : bool = not $TileMap.get_cell(mouse_pos.x/64, mouse_pos.y/64 + 1)
		var next_tile : bool = not $TileMap.get_cell(mouse_pos.x/64 + 1, mouse_pos.y/64)
		var prev_tile : bool = not $TileMap.get_cell(mouse_pos.x/64 - 1, mouse_pos.y/64)
		
		if $TileMap.get_cell(mouse_pos.x/64, mouse_pos.y/64) and botton_tile and next_tile and current_block == 'ramp':
			$TileMap.set_cellv(mouse_pos/64, block_types['ramp'], true)
		
		if $TileMap.get_cell(mouse_pos.x/64, mouse_pos.y/64) and prev_tile and not botton_tile and current_block == 'bridge':
			$TileMap.set_cellv(mouse_pos/64, block_types['bridge'], true)
	
	if event.is_action_pressed('right_click'):
		var mouse_pos = get_global_mouse_position()
		var tile_type = $TileMap.get_cellv(mouse_pos/64)
		if block_types['bridge'] == tile_type:
			$TileMap.set_cellv(mouse_pos/64, -1)


func pause_reset() -> void:
	if active:
		pause_game()
		reset_player()
		GameEvents.emit_signal("reset")
	else:
		pause_game()
		GameEvents.emit_signal("started")

func pause_game() -> void:
	active = !active
	Autoload.current_state = int(active)


func reset_player() -> void:
	player.global_position = initial_player_pos
	player.rotation = initial_rotation
