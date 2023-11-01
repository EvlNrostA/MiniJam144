extends Timer

@onready var label = $Label

func start_timer(time):
	start(time)
	
func set_time(time):
	label.text = str(int(time))

func _process(_delta):
	if self.time_left >= 0 and not is_stopped():
		set_time(self.time_left)
