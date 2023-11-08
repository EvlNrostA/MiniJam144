extends Player_library

@onready var manager = get_parent()
@onready var lost = false

func _process(delta):
	if not lost:
		Move2D(delta)
	
func hit():
	lost = true
	await death_animation()
	GManager.game_over()
