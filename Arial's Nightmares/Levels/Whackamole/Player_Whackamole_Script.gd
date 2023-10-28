extends Player_library

@onready var level_timer = $"../LevelTimer"
@onready var manager = $"../StateManager"
@onready var killed_count = 0

func _ready():
	level_timer.timeout.connect(lost_game)
	
func _process(delta):
	Move2D(delta)

func killed_noam_fogle():
	killed_count += 1
	print("Killed ", killed_count)
	
	if (killed_count == manager.noam_fogle_count):
		won_game()

func game_over():
	pass

func lost_game():
	print("Lost Game")
	nextLevel()

func won_game():
	print("Won Game")
	nextLevel()
