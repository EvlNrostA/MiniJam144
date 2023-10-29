extends Player_library

@onready var manager = get_parent()

func _ready():
	self.JUMP_VELOCITY = -600

func _physics_process(delta):
	Move2DRight(delta, speed)

func check_hit():
	pass

func pushed():
	velocity += Vector2(-300, -300)
	pass	

func death():
	GManager.game_over()

