extends Sprite

func _process(delta):
	self.global_position = get_global_mouse_position() + Vector2(22, -22)
