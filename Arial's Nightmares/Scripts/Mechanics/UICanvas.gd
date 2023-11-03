extends CanvasLayer

const POINT_ADD_TEXT_OFFSET = 50
const POINT_ADD_MOVE_OFFSET = -20

@onready var timer_label = $TimerLabel
@onready var level_timer = $Timer

@onready var point_label = $PointLabel
@onready var point_add_label = $PointAddLabelNode/PointAddLabel
@onready var point_add_label_node = $PointAddLabelNode
@onready var animation_player = $AnimationPlayer

var points

func _ready():
	visible = false
	pass

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
	point_add_label.text = "+%d" % new_points
	
	var text_length = point_label.get_theme_font_size(point_label.text) + POINT_ADD_TEXT_OFFSET
	point_add_label_node.position.x = point_label.position.x + text_length
	
	animation_player.play("Add")
	await animation_player.animation_finished
	
	points_set(points + new_points)
