extends CanvasLayer

const HIGHSCORE_FILE_PATH = "user://highscore.save"

const POINT_ADD_XOFFSET = 100
const POINT_ADD_YOFFSET = 70
const POINT_ADD_SIZE = 32
const POINT_ADD_COLORHEX = 0xfed447ff

const TOOLTIP_OFFSET = Vector2(144, 144)
const TOOLTIP_FADEIN_TIME = 0.3
const TOOLTIP_FADEOUT_TIME = 0.2
const TOOLTIP_WAIT_TIME = 3

@onready var timer_label = $RightLayout/TimerPanel/TimerLabel
@onready var level_timer = $Timer

@onready var point_label = $RightLayout/PointPanel/PointLabel
@onready var floating_text = $RightLayout/FloatingText

@onready var tooltip_panel = $LeftLayout/TooltipPanel
@onready var tooltip_sprite = $LeftLayout/TooltipPanel/Sprite2D
@onready var tooltip_timer = $LeftLayout/TooltipPanel/Timer

var points : int = 0
var highscore : int = 0
var tween

func _ready():
	visible = false
	
func timer_running() -> bool:
	return UI.level_timer.time_left > 0

func set_timer(time, function):
	level_timer.timeout.connect(function)
	level_timer.wait_time = time
	set_time(time)
	
func start_timer():
	level_timer.start()

func set_and_start_timer(time, function):
	set_timer(time, function)
	start_timer()
	
func set_time(time):
	timer_label.text = str(round(time))

func _process(_delta):
	if level_timer.time_left >= 0 and not level_timer.is_stopped():
		set_time(level_timer.time_left)

func points_set(new_points):
	points = new_points
	point_label.text = str(points)
	
	set_highscore()

func set_highscore():
	if FileAccess.file_exists(HIGHSCORE_FILE_PATH):
		var highscore_file = FileAccess.open(HIGHSCORE_FILE_PATH, FileAccess.READ_WRITE)

		if int(highscore_file.get_as_text()) < points:
			highscore_file.store_string(str(points))
	
		highscore_file.close()
	
	elif highscore < points:
		highscore = points
	
func get_highscore() -> int:
	if FileAccess.file_exists(HIGHSCORE_FILE_PATH):
		return int(FileAccess.get_file_as_string(HIGHSCORE_FILE_PATH))
		
	else:
		return highscore

func points_add(new_points : int):
	if new_points > 0:
		var point_add_text = "+%d" % new_points
		var point_add_xpos = point_label.position.x + point_label.get_theme_font_size(point_label.text) + POINT_ADD_XOFFSET
		var point_add_ypos = point_label.position.y + POINT_ADD_YOFFSET
		await floating_text.display(point_add_text, 
								Vector2(point_add_xpos, point_add_ypos),
	 							POINT_ADD_SIZE,
								Color.hex(POINT_ADD_COLORHEX))
	
		points_set(points + new_points)

func points_add_time_left(multiplier=1):
	points_add(round(level_timer.time_left) * multiplier)

func show_tooltip(tooltip_scene):
	var tooltip_foreground = load(tooltip_scene).instantiate()
	tooltip_panel.add_child(tooltip_foreground)
	
	var window_position = GManager.get_shown_window_rect().position
	var texture_xsize = tooltip_sprite.texture.get_size().x * tooltip_sprite.scale.x
	
	var start_position = window_position + Vector2(-texture_xsize, TOOLTIP_OFFSET.y)
	var end_position = window_position + TOOLTIP_OFFSET
	
	tooltip_panel.position = start_position
	tooltip_panel.show()
	
	await GManager.tween_and_wait(tooltip_panel, "position:x", end_position.x, TOOLTIP_FADEIN_TIME, tooltip_timer)
	tooltip_timer.start(TOOLTIP_WAIT_TIME)
	await tooltip_timer.timeout
	await GManager.tween_and_wait(tooltip_panel, "position:x", start_position.x, TOOLTIP_FADEOUT_TIME, tooltip_timer)
	
	tooltip_panel.hide()
