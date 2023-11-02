extends CanvasLayer

@onready var label = $Label
@onready var points = 0

func _ready():
	label.text = ""

func display():
	label.text = str(points)

func set_to(new_points):
	points = new_points
	display()
	
func add(new_points):
	# Display smaller fading +nwe_points next to label
	set_to(points + new_points)
