extends Player_library

@onready var manager = get_parent()
@onready var yam = $"../Yam"
@onready var hit = false

func _ready():
	#speed = 5
	self.JUMP_VELOCITY = -600

func _physics_process(delta):
	if not hit:
		Move2DRight(delta)
	else:
		position = position.move_toward(yam.position, 300 * delta)
		animationPlayer.play("Fall")

func check_hit():
	pass

func pushed():
	hit = true
	velocity += Vector2(-300, -300)
	pass	

func death():
	GManager.game_over()

