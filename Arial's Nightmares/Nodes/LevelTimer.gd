extends Label

@onready var level_timer = $LevelTimer
@onready var stopped = true

func start(time):
	stopped = false
	level_timer.start(time)
	
func set_time(time):
	text = str(int(time))

func _process(delta):
	if level_timer and level_timer.time_left >= 0 and not stopped:
		set_time(level_timer.time_left)


func _on_level_timer_timeout():
	stopped = true
