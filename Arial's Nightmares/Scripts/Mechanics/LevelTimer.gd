extends CanvasLayer

@onready var label = $Label
@onready var timer = $Timer

func _ready():
	label.text = ""

func start_timer(time, function):
	timer.timeout.connect(function)
	timer.start(time)
	
func set_time(time):
	label.text = str(round(time))

func _process(_delta):
	if timer.time_left >= 0 and not timer.is_stopped():
		set_time(timer.time_left)
