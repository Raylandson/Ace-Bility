extends Area2D


enum BlockState{BLANK, COMPLETE}
export (BlockState) var block_state = BlockState.BLANK

var _mouse_inside = false
var _hud_showed = false


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


func _on_mouse_entered():
	_mouse_inside = true

func _on_mouse_exited():
	_mouse_inside = false
