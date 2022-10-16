extends Label

func _process(delta):
	self.text = str(int(Autoload.score))
