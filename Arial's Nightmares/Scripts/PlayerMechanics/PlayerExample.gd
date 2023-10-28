extends Player_library

func _ready():
	self.speed = 3
	self.JUMP_VELOCITY = -600
	

func _process(delta):
	PlatformMove2D(delta)

func check_hit():
	pass
