extends Area2D


enum BlockState{BLANK, COMPLETE}
export (BlockState) var block_state = BlockState.BLANK

var _mouse_inside = false
var _hud_showed = false

onready var block = preload("res://scenes/blocks/block1/block1.tscn")
onready var ramp = preload("res://scenes/blocks/ramp1/ramp1.tscn")

var _old_block = null

func _ready():
	$BlockList.connect("block_selected", self, "create_block")


func _input(event):
	if event.is_action_pressed("click") and _mouse_inside == true and event.is_echo() == false:
		if _hud_showed == false:
			$BlockList.visible = true
			var tw = create_tween()
			tw.tween_property($BlockList, "rect_scale", Vector2(1,1), 0.3).from(Vector2(0.25, 0.25)).set_trans(Tween.TRANS_QUINT)
			_hud_showed = true

		elif _hud_showed == true:
			var tw = create_tween()
			tw.tween_property($BlockList, "rect_scale", Vector2(0,0), 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
			_hud_showed = false
			yield(get_tree().create_timer(0.25, false), "timeout")
			$BlockList.visible = false
			
	elif event.is_action_pressed("click") and _mouse_inside == false and event.is_echo() == false and _hud_showed == true:
			var tw = create_tween()
			tw.tween_property($BlockList, "rect_scale", Vector2(0,0), 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
			_hud_showed = false
			yield(get_tree().create_timer(0.25, false), "timeout")
			$BlockList.visible = false
			
			
func create_block(block_idx):
	match block_idx:
		0:
			block_state = BlockState.COMPLETE
#			$Sprite.visible = false
#			var b = b.instance()
#			get_tree().current_scene.add_child(b)
#			b.global_position = self.global_position
		1:
			block_state = BlockState.COMPLETE
			if is_instance_valid(_old_block):
				_old_block.queue_free()
			var b = ramp.instance()
			get_tree().current_scene.add_child(b)
			b.global_position = self.global_position
			_old_block = b
#			$Sprite.visible = false
			
		2:
			block_state = BlockState.COMPLETE
			if is_instance_valid(_old_block):
				_old_block.queue_free()
			var b = block.instance()
			get_tree().current_scene.add_child(b)
			b.global_position = self.global_position
			_old_block = b
#			$Sprite.visible = false
			
		3:
			if is_instance_valid(_old_block):
				_old_block.queue_free()
#			$Sprite.visible = true
			
			
func _on_mouse_entered():
	_mouse_inside = true

func _on_mouse_exited():
	_mouse_inside = false
