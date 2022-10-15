extends KinematicBody2D


var _velocity := Vector2.ZERO
export(float) var horizontal_velocity : float = 100
export(float) var gravity : float = 20
export(int, 10, 100) var smooth : float = 10

func _ready():
	pass 


func _physics_process(delta):
	_velocity.y += gravity
	_velocity.x = horizontal_velocity
	
	
	_velocity = move_and_slide_with_snap(_velocity.rotated(rotation), transform.y * 1, -transform.y,  true, 4, PI/3)
	_velocity = _velocity.rotated(-rotation)
	if is_on_floor():
#		rotation = get_floor_normal().angle() + PI/2
		if rotation != get_floor_normal().angle() + PI/2:
#			rotation += PI/10
			rotation = max(rotation + PI/smooth * sign(get_floor_normal().angle()), get_floor_normal().angle() + PI/2)
#			rotation = min(rotation, rota)
#			prints(rotation, rotation + PI/10, get_floor_normal().angle() + PI/2)
