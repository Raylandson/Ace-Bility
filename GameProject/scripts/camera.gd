extends Camera2D


export (NodePath) onready var player = get_node(player)

var following_player = false
var start_position = Vector2.ZERO
var start_zoom = Vector2(1.75, 1.75)
var cam_vel = 600

#func _ready():
#	GameEvents.connect("reset", self, "reset_anim")
#	GameEvents.connect("started", self, "start_anim")
#	start_position = self.global_position
#	start_zoom = self.zoom


#func _process(delta):
#	self.zoom += Vector2(0.005, 0.005) * delta

	
	
func reset_anim():
	following_player = false
	var tw = create_tween().set_parallel(true)
	tw.tween_property(self, 'zoom', start_zoom, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "global_position", start_position, 0.3).set_trans(Tween.TRANS_QUAD)
	
	
func start_anim():
	var tw = create_tween().set_parallel(true)
	tw.tween_property(self, 'zoom', Vector2(0.75, 0.75), 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "global_position", player.global_position, 0.3).set_trans(Tween.TRANS_QUAD)
	following_player = true
