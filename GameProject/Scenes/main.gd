extends Node2D

var paused = true

func _ready():
	pass 

func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed('pause'):
		paused = !paused
		Autoload.current_state = int(paused)
#		get_tree().paused = !get_tree().paused
#		print(Autoload.current_state)

