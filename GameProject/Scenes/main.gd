extends Node2D

onready var active = false
export(NodePath) onready var player = get_node(player)
var initial_player_pos := Vector2.ZERO
var initial_rotation : float
var poste_pai = load('res://scenes/blocks/poste.tscn')

var block_types = {
	'bridge' : 6,
	'ramp' : 2,
	'brick' : 5,
	'transparent' : 7
	#bridge deveria ser 6
	#bloco normal deveria ser 0
	#terra deveria ser 4
}

export(String, 'bridge', 'ramp') var current_block = 'ramp'

export(OpenSimplexNoise) var noise_test


func _ready():
	$Interface2/Fade.visible = true
	
	var tw = create_tween()
	randomize()
	initial_player_pos = player.global_position
	initial_rotation = player.rotation
	noise_test.seed = randi()

	generate_map()
	
	GameEvents.emit_signal("started")
	pause_game()

	tw.tween_property($Interface2/Fade, "color", Color(0,0,0,0), 1.2).set_trans(Tween.TRANS_QUINT)


var hole_freq = randi() % 30 + 30
var hole_len = randi() % 6 + 7

var obstacle_freq = randi() % 10 + 10
var obstacle_len = randi() % 2 + 3

var ramp_off = 0
var diff = 0

var post_freq = randi() % 2 + 20


func generate_map():
#	inicio = 0, 760
	
	for c in range(22222):
		var perlin_test = noise_test.get_noise_2d(c, 0.0)
		var next_perlin = noise_test.get_noise_2d(c + 1, 0.0)
		
		hole_freq -= 1
		
		
		if hole_freq < -hole_len:
			hole_freq = randi() % 30 + 30
			hole_len = randi() % 2 + 4
		
		if hole_freq > 0:
			if hole_freq -5 > 0:
				obstacle_freq -= 1
			
			
			if obstacle_freq < 0:
				for a in range(1, obstacle_len + 1):
					$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10 - a, block_types['brick'])
					obstacle_freq = randi() % 10 + 10
					obstacle_len = randi() % 1 + 3
			
			$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10 - diff, 0)
			
			if post_freq > 0:
				post_freq -= 1
			
			elif not ramp_off != floor(abs(perlin_test * 10)):
				
				var poste = poste_pai.instance()
				var pos = 456 - floor(abs(perlin_test) * 10 * 64 - diff * 64)
				poste.global_position = Vector2(c * 64 - 32, (pos - int(pos) % 64)) + Vector2.DOWN * 36
				add_child(poste)
				post_freq = randi() % 2 + 20
			
			
			if ramp_off != floor(abs(perlin_test * 10)):
				if ramp_off > floor(abs(perlin_test * 10) ):
					$TileMap.set_cell(c , 700/64 - abs(perlin_test) * 10 - 1, 7)
				
				elif ramp_off < floor(abs(perlin_test * 10 - diff)):
					$TileMap.set_cell(c -1, 700/64 - abs(perlin_test) * 10 - diff, 7)
				
				ramp_off = floor(abs(perlin_test) * 10)
		
			for x in range(1, 12):
				$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10 + x - diff, 4)
		
			if diff < 0:
				diff += 1
				$TileMap.set_cell(c, 700/64 - abs(perlin_test) * 10 - diff, 7)
		
		else:
			if hole_freq <= -hole_len:
				diff = min(0, (ramp_off + 1) - (floor(abs(next_perlin) * 10) + 1))
			
			$TileMap.set_cell(c, 700/64 - (ramp_off + 1), 7)


func _process(delta):
	if Input.is_action_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		put_block(mouse_pos)
		put_block(mouse_pos + Vector2.RIGHT * 32)
		put_block(mouse_pos + Vector2.DOWN * 32)
		put_block(mouse_pos + Vector2.UP * 32)
		put_block(mouse_pos + Vector2.LEFT * 32)
	
	if Input.is_action_pressed("click"):
		delete_block(get_global_mouse_position())
		delete_block(get_global_mouse_position() + Vector2.RIGHT * 32)
		delete_block(get_global_mouse_position() + Vector2.DOWN * 32)
		delete_block(get_global_mouse_position() + Vector2.UP * 32)
		delete_block(get_global_mouse_position() + Vector2.LEFT * 32)


func delete_block(position : Vector2):
	var tile_type = $TileMap.get_cellv(position/64)
	
	if block_types['brick'] == tile_type:
		$TileMap.set_cellv(position/64, -1)
		$Audio/Build.play()
	


func put_block(position : Vector2) -> void:
		var player_pos = player.global_position
		var not_in_player = abs(position.x - position.x) > 24 and abs(position.y - player_pos.y) > 48
		
		var botton_tile = $TileMap.get_cell(position.x/64, position.y/64 + 1)
		var next_tile : bool = not $TileMap.get_cell(position.x/64 + 1, position.y/64)
		var prev_tile = $TileMap.get_cell(position.x/64 - 1, position.y/64)
		
		if $TileMap.get_cell(position.x/64, position.y/64) and botton_tile in [0, 6] and next_tile:
			
			$Audio/Blop.play()
			$TileMap.set_cellv(position/64, block_types['ramp'], true)
			
			if botton_tile != block_types['bridge']:
				$TileMap.set_cell(position.x/64, position.y/64 + 1, 1, false)
			
		elif $TileMap.get_cell(position.x/64, position.y/64) == 7  and botton_tile == $TileMap.INVALID_CELL:
			$Audio/Blop.play()
			$TileMap.set_cellv(position/64, block_types['bridge'], true)
		
		elif $TileMap.get_cell(position.x/64, position.y/64)and botton_tile in [0, 6] and prev_tile in [0, 6, 1]:
			$Audio/Blop.play()
			$TileMap.set_cellv(position/64,  block_types['ramp'], false)
			
			if botton_tile != block_types['bridge']:
				$TileMap.set_cell(position.x/64, position.y/64 + 1, 1, true)


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
