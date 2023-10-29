extends TileMap

@onready var manager = get_parent()

func _process(delta):
	position += manager.LEVEL_VELOCITY
	
	if position == Vector2(-1500,96):
		position = Vector2(0,96)
