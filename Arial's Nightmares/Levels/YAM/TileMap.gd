extends TileMap

@onready var manager = get_parent()

func _process(delta):
	if manager.settings:
		position += manager.settings.level_velocity
	
	if position == Vector2(-1500,96):
		position = Vector2(0,96)
