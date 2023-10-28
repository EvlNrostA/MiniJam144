extends Player_library

@onready var level_timer = $"../LevelTimer"
@onready var manager = get_parent()

func _ready():
	level_timer.timeout.connect(lost_game)

func _process(delta):
	# 
	pass

func lost_game():
	print("Lost Game")
	GManager.next_level()

func won_game():
	print("Won Game")
	GManager.next_level()
