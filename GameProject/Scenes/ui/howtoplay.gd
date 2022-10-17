extends Control

func _ready():
	get_tree().paused = false
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,0), 1.2).set_trans(Tween.TRANS_QUINT)

func _process(delta):
	$ParallaxBackground.offset.x += 30 * delta

func _on_Quit_pressed():
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	get_tree().change_scene("res://scenes/ui/main_menu.tscn")
