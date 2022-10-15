extends Area2D


func _ready():
	pass



func on_body_entered(body):
	if body.is_in_group("player"):
		print('go to next level')
