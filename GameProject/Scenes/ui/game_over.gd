extends Control

func _ready():
	$CenterContainer/VBoxContainer/VBoxContainer/MainLabel2.text = "Pontos: " + str(int(Autoload.score))

func _on_Button_pressed():
	Autoload.score = 0
	get_tree().change_scene("res://scenes/main.tscn")
	
	
func _on_Quit_pressed():
	get_tree().quit()
