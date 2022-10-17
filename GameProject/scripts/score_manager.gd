extends Node


func _ready():
	pass


func _process(delta):
	if Autoload.current_state == Autoload.ACTIVE:
		Autoload.score += 10 * delta
