extends Player_library

@onready var manager = get_parent()

func _process(delta):
	Move2D(delta)
	
func hit():
	manager.bullet_timer.stop()
	await manager.free_nodes()
	GManager.game_over()

func _on_level_timer_timeout():
	manager.bullet_timer.stop()
	await manager.free_bullets()
	GManager.next_level()
