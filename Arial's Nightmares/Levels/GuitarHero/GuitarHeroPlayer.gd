extends Player_library

const FAIL_COUNT = 3

@onready var manager = get_parent()
@onready var missed_count = 0

func _process(_delta):
	for direction in manager.arrow_positions.keys():
		if Input.is_action_just_pressed(direction):
			if manager.arrows_on_target.size() == 0:
				count_miss()
				
			for area in manager.arrows_on_target:
				if direction == area.direction:
					print("yes")
					area.pressed = true
				else:
					print("no")
					count_miss()

func count_miss():
	missed_count += 1
	print(missed_count)
	if missed_count == FAIL_COUNT:
		lost_game()

func lost_game():
	print("Lost Game") 
	GManager.game_over()

func won_game():
	manager.stopped = true
	print("Won Game")
	GManager.next_level()
