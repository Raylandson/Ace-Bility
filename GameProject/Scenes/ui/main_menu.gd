extends Control

func _ready():
	get_tree().paused = false
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,0), 1.2).set_trans(Tween.TRANS_QUINT)


func _process(delta):
	$ParallaxBackground.offset.x += delta * -30

func _on_Button_pressed():
	Autoload.score = 0
	
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_Quit_pressed():
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	get_tree().quit()


func _on_instru_pressed():
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	get_tree().change_scene("res://scenes/ui/howtoplay.tscn")


func _on_credits_pressed():
	var tw = create_tween()
	tw.tween_property($Fade/Fade, "color", Color(0,0,0,1), 0.8).set_trans(Tween.TRANS_QUINT)
	yield(tw, "finished")
	get_tree().change_scene("res://scenes/ui/credits.tscn")
