extends Timer

@onready var label = $Label
@onready var stopped = true

func start_timer(time):
	stopped = false
	start(time)
	
func set_time(time):
	label.text = str(int(time))

func _process(delta):
	if self.time_left >= 0 and not stopped:
		set_time(self.time_left)

func _on_level_timer_timeout():
	stopped = true
