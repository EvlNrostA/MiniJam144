extends Player_library

@onready var manager = get_parent()
@onready var lost = false
	
func _process(delta):
	if not lost:
		Move2D(delta)

func killed_noam_fogle():
	manager.noam_fogle_count -= 1
	print(manager.noam_fogle_count)
	if (manager.noam_fogle_count == 0):
		manager.won_game()
