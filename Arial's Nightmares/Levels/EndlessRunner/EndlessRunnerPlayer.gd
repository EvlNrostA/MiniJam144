extends Player_library

@onready var manager = get_parent()
@onready var yam = $"../Yam"
@onready var hit = false

func _ready():
	self.JUMP_VELOCITY = -400

func _physics_process(delta):
	if not hit:
		Move2DRight(delta)
	else:
		position = position.move_toward(yam.position, manager.settings.level_velocity * delta)
		animationPlayer.play("Fall")

func pushed():
	hit = true
	velocity += Vector2(-300, -300)

func death():
	GManager.game_over()

