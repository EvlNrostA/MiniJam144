extends Player_library

@onready var manager = get_parent()
var fail_count = 0

func _process(_delta):
	if manager.stopped:
		return
	
	for direction in manager.arrow_positions.keys():
		if Input.is_action_just_pressed(direction):
			if manager.arrows_on_target.size() == 0:
				count_miss()
				
			for area in manager.arrows_on_target:
				if direction == area.direction:
					area.animation_player.play("PressedRight")
					area.pressed = true
				else:
					area.animation_player.play("PressedWrong")
					count_miss()

func count_miss():
	fail_count -= 1
	print(fail_count)
	if fail_count == 0:
		lost_game()

func lost_game():
	manager.stopped = true
	GManager.game_over()

func won_game():
	manager.stopped = true
	GManager.next_level()
