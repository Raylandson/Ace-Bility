extends KinematicBody2D


var _velocity := Vector2.ZERO
export(float) var horizontal_velocity : float = 100
export(float) var gravity : float = 20
export(int, 10, 100) var smooth_climb : float = 100
export(int, 100, 1000) var smooth_fall : float = 300


func _ready():
	$Sprite/AnimatedSprite.play("default")
	pass 


func _physics_process(delta):
	_velocity.y += gravity
	_velocity.x = horizontal_velocity
	self.horizontal_velocity += 1.75 * delta
	
	if is_on_wall():
		self.queue_free()
	
	_velocity = move_and_slide_with_snap(_velocity.rotated(rotation), transform.y * 1, -transform.y,  true, 4, PI/3)
#	_velocity = _velocity.rotated(-rotation)
	if is_on_floor():
#		rotation = get_floor_normal().angle() + PI/2
		var floor_angle = get_floor_normal().angle() + PI/2
		if $Sprite.rotation != floor_angle:
#			rotation.linear_interpolate()
			if $RightRay.is_colliding() and sign(_velocity.x) == 1:
				$Sprite.rotation = max((abs($Sprite.rotation) + PI/smooth_climb) * sign(get_floor_normal().angle()), floor_angle)
			elif $LeftRay.is_colliding() and sign(_velocity.x) == -1:
#				printt(rotation, rotation + PI/smooth_climb * sign(floor_angle), floor_angle)
				$Sprite.rotation = min($Sprite.rotation + PI/smooth_climb , floor_angle)
#			elif is_equal_approx(0, floor_angle):
#				rotation = max((abs(rotation) + PI/smooth_climb) * sign(get_floor_normal().angle()), floor_angle)
				
#rotation = min(rotation, rota)
#			prints(rotation, rotation + PI/10, get_floor_normal().angle() + PI/2)
	elif not $LeftRay.is_colliding():
		if sign(_velocity.x) == 1:
			$Sprite.rotation = min(0, $Sprite.rotation + PI/smooth_fall * sign(_velocity.x))
		else:
			$Sprite.rotation = max(0, $Sprite.rotation + PI/smooth_fall * sign(_velocity.x))


func _process(delta):
	set_physics_process(Autoload.current_state)

