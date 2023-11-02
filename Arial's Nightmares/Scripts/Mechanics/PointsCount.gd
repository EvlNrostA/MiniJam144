extends CanvasLayer

@onready var label = $Label
@onready var points = 0

func _ready():
	visible = false

func set_to(new_points):
	points = new_points
	label.text = str(points)
	
func add(new_points):
	# Display smaller fading +nwe_points next to label
	set_to(points + new_points)
