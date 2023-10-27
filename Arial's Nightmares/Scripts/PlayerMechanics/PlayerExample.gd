extends Player_library

func _ready():
	self.speed = 3

func _process(delta):
	Move2D(delta)

func check_hit():
	pass
