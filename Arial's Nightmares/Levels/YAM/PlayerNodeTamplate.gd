extends Player_library

@onready var manager = get_parent()
var hited : bool = false

func _ready():
	speed = 5
	self.JUMP_VELOCITY = -600

func _physics_process(delta):
	if hited == false:
		Move2DRight(delta, speed)
	else:
		position = position.move_toward($"../YAM".position, 300 * delta)

func check_hit():
	pass

func pushed():
	hited = true
	velocity += Vector2(-300, -300)
	pass	

func death():
	GManager.game_over()

