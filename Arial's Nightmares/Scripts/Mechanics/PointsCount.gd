extends CanvasLayer

const ADD_TEXT_OFFSET = 50
const ADD_MOVE_OFFSET = -20
const ANIMATION_TIME = 0.5

@onready var label = $Label
@onready var add_label = $AddLabelNode/AddLabel
@onready var add_label_node = $AddLabelNode
@onready var animation_player = $AnimationPlayer
@onready var points = 0

func _ready():
	visible = false

func set_to(new_points):
	points = new_points
	label.text = str(points)
	
func add(new_points):
	# Display smaller fading +nwe_points next to label
	add_label.text = "+%d" % new_points
	
	var text_length = label.label_settings.font.get_string_size(label.text).x * label.text.length() + ADD_TEXT_OFFSET
	add_label_node.position.x = label.position.x + text_length
	
	animation_player.play("Add")
	await animation_player.animation_finished
	
	set_to(points + new_points)
