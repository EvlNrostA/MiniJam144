extends Player_library

@onready var manager = get_parent()

func _unhandled_key_input(event):
	if UI.timer_running():
		for direction in manager.arrow_positions.keys():
			if event.is_action_pressed(direction):
				manager.check_arrows(direction)
