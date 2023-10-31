extends Player_library

@onready var manager = get_parent()
var fail_count : int

func _process(_delta):	
	for direction in manager.arrow_positions.keys():
		if Input.is_action_just_pressed(direction):
			if manager.arrows_on_target.size() == 0:
				count_miss()
				
			for area in manager.arrows_on_target:
				if not area.pressed:
					if direction == area.direction:
						area.pressed = true
						area.animation_player.play("PressedRight")
					else:
						count_miss()
						area.animation_player.play("PressedWrong")

func count_miss():
	if fail_count > 0:
		fail_count -= 1
	else:
		lost_game()

func lost_game():
	manager.bpm_timer.stop()
	GManager.game_over()

func won_game():
	manager.bpm_timer.stop()
	GManager.next_level()
