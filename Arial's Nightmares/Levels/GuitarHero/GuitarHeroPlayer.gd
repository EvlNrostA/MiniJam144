extends Player_library

@onready var manager = get_parent()
var fail_count : int

func _unhandled_key_input(event):	
	for direction in manager.arrow_positions.keys():
		if Input.is_action_just_pressed(direction):
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
					
				area.pressed = true

func count_miss():
	fail_count -= 1
	
	if fail_count == 0:
		manager.lost_game()
