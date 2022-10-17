extends Control

func _ready():
	get_tree().paused = false
	$CenterContainer/VBoxContainer/VBoxContainer/MainLabel2.text = "Pontos: " + str(int(Autoload.score))
	var tw = create_tween()
	tw.tween_property($Fade, "color", Color(0,0,0,0), 1.2).set_trans(Tween.TRANS_QUINT)
	
	
func _on_Button_pressed():
	Autoload.score = 0
	
	var tw = create_tween()
	tw.tween_property($Fade, "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	
	get_tree().change_scene("res://scenes/main.tscn")
	
	
func _on_Quit_pressed():
	get_tree().quit()
