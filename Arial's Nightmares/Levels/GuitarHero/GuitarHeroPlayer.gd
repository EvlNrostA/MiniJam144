extends Player_library

@onready var level_timer = $"../LevelTimer"
@onready var manager = get_parent()

func _ready():
	#level_timer.timeout.connect(lost_game)
	pass

func _process(delta):
	for direction in manager.arrow_positions.keys():
		if Input.is_action_just_pressed(direction):
			if manager.current_arrows.any(func(area): return area.is_on_target):
				print("yes")
			else:
				print("no")

func lost_game():
	print("Lost Game")
	GManager.next_level()

func won_game():
	print("Won Game")
	GManager.next_level()
