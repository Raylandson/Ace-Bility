extends KinematicBody2D


var _velocity := Vector2.ZERO
export(float) var horizontal_velocity : float = 100
export(float) var gravity : float = 20
export(int, 10, 100) var smooth_climb : float = 100
export(int, 100, 1000) var smooth_fall : float = 300

var _initial_pos_x = self.global_position.x
var t = 0

func _ready():
	$Sprite/AnimatedSprite.play("default")


func _physics_process(delta):
	_velocity.y += gravity
	_velocity.x = horizontal_velocity
	self.horizontal_velocity = max(2.75 * delta + horizontal_velocity, 250)
	
	
	t += delta
	if t >= 1.4:
		$wheelsound.play()
		t = 0
		
	if _initial_pos_x != global_position.x:
		_initial_pos_x = global_position.x
	
	else:
		if not $crash.playing:
			$crash.play()
			var tw = create_tween()
			tw.tween_property($Sprite, "scale", Vector2(1, 1), 0.3).from(Vector2(1.2, 1.2)).set_trans(Tween.TRANS_QUART)
			yield(get_tree().create_timer(0.5, false), "timeout")
			GameEvents.emit_signal("ended")
	
	_velocity = move_and_slide_with_snap(_velocity.rotated(rotation), transform.y * 1, -transform.y,  true, 4, PI/3)
	
	if is_on_floor():
		var floor_angle = get_floor_normal().angle() + PI/2
		
		if $Sprite.rotation != floor_angle:
			if $RightRay.is_colliding() and sign(_velocity.x) == 1:
				$Sprite.rotation = max((abs($Sprite.rotation) + PI/smooth_climb) * sign(get_floor_normal().angle()), floor_angle)
			
			elif $LeftRay.is_colliding() and sign(_velocity.x) == -1:
				$Sprite.rotation = min($Sprite.rotation + PI/smooth_climb , floor_angle)
			
	elif not $LeftRay.is_colliding():
		if sign(_velocity.x) == 1:
			$Sprite.rotation = min(0, $Sprite.rotation + PI/smooth_fall * sign(_velocity.x))
		
		else:
			$Sprite.rotation = max(0, $Sprite.rotation + PI/smooth_fall * sign(_velocity.x))


func _process(delta):
	set_physics_process(Autoload.current_state)

