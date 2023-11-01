extends Player_library

@onready var manager = get_parent()

func _process(delta):
	Move2D(delta)
	
func hit():
	await manager.free_nodes()
	GManager.game_over()

func won_game():
	await manager.free_nodes()
	GManager.next_level()
