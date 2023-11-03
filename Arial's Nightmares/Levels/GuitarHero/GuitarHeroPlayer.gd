extends Player_library

@onready var manager = get_parent()
var fail_count : int

func _unhandled_key_input(event):
	if UI.timer_running():
		for direction in manager.arrow_positions.keys():
			if event.is_action_pressed(direction):
				check_arrows(direction)

func check_arrows(direction):
	var arrows_on_target = manager.arrows_on_target
	if arrows_on_target.size() == 0:
		count_miss()
				
	for area in arrows_on_target:
		var correct_direction = direction == area.direction
		if not correct_direction or area.pressed:
			count_miss()
					
		if not area.pressed:
			var animation_name = "PressedRight" if correct_direction else "PressedWrong"
			area.animation_player.queue(animation_name)
			
			if correct_direction:
				manager.score(area)
	
		area.pressed = true

func count_miss():
	fail_count -= 1
	if fail_count == 0:
		manager.lost_game()
