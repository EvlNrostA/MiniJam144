extends Player_library

@onready var level_timer = $"../LevelTimer"
@onready var manager = get_parent()
	
func _process(delta):
	Move2D(delta)

func killed_noam_fogle(body):
	manager.noam_fogle_count -= 1
	if (manager.noam_fogle_count == 0):
		won_game()

func won_game():
	print("Won Game")
	GManager.next_level()

func _on_level_timer_timeout():
	print("Lost Game")
	GManager.game_over()
