extends Player_library

@onready var manager = get_parent()

func _process(delta):
	Move2D(delta)
	
func hit():
	GManager.game_over()
