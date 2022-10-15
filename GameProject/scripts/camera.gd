extends Camera2D

var screen_size = Vector2(1024, 600)

func _process(delta):
	
	if Input.is_action_pressed("left"):
		self.global_position.x += -300 * delta
	if Input.is_action_pressed("right"):
		self.global_position.x += 300 * delta
	if Input.is_action_pressed("down"):
		self.global_position.y += 300 * delta
	if Input.is_action_pressed("up"):
		self.global_position.y += -300 * delta
