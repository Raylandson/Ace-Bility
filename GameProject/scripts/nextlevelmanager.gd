extends Node


func _ready():
	GameEvents.connect("ended", self, "game_over")


func game_over():
	get_tree().paused = true
	var tw = create_tween()
	tw.tween_property(get_parent().get_node("Interface2/Fade"), "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	get_tree().change_scene("res://scenes/ui/game_over.tscn")
	
