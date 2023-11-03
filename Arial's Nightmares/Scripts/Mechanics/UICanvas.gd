extends CanvasLayer

const POINT_ADD_XOFFSET = 100
const POINT_ADD_YOFFSET = 70
const POINT_ADD_SIZE = 32
const POINT_ADD_COLORHEX = 0xfed447ff

@onready var timer_label = $TimerLabel
@onready var level_timer = $Timer

@onready var point_label = $PointLabel
@onready var floating_text = $FloatingText

var points

func _ready():
	visible = false
	pass
	
func timer_running() -> bool:
	return UI.level_timer.time_left > 0

func start_timer(time, function):
	level_timer.timeout.connect(function)
	level_timer.start(time)
	
func set_time(time):
	timer_label.text = str(round(time))

func _process(_delta):
	if level_timer.time_left >= 0 and not level_timer.is_stopped():
		set_time(level_timer.time_left)

func points_set(new_points):
	points = new_points
	point_label.text = str(points)
	
func points_add(new_points):
	if new_points > 0:
		var point_add_text = "+%d" % new_points
		var point_add_xpos = point_label.global_position.x + point_label.get_theme_font_size(point_label.text) + POINT_ADD_XOFFSET
		var point_add_ypos = point_label.global_position.y + POINT_ADD_YOFFSET
		await floating_text.display(point_add_text, 
								Vector2(point_add_xpos, point_add_ypos),
	 							POINT_ADD_SIZE,
								Color.hex(POINT_ADD_COLORHEX))
	
		points_set(points + new_points)
