extends Player_library

@onready var manager = get_parent()
@onready var yam = $"../Yam"
@onready var running = true

func _physics_process(delta):
	if running and manager:
		Move2DRight(delta, manager.should_move)
	else:
		position = position.move_toward(Vector2(yam.position.x, manager.items_start_position.y), manager.settings.level_velocity * delta)
		
func pushed():
	position.y = manager.items_start_position.y
	running = false
	await death_animation()

func death():
	if running:
		await pushed()
		
	GManager.game_over()
