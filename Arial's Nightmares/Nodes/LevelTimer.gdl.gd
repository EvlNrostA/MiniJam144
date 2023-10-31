extends Label

@onready var level_timer = $LevelTimer

func start(time):
	level_timer.start(time)
	
func set_time(time):
	print(time)
	text = str(int(time))

func _process(delta):
	if level_timer and level_timer. and level_timer.time_left >= 0:
		set_time(level_timer.time_left)
