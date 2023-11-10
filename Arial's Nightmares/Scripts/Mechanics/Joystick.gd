extends TouchScreenButton

const LIMIT_MULTIPLIER = 0.1667
const START_POS = Vector2(6, 6)
const MIN_OFFSET = 0.2

@onready var input = $InputButton
@onready var size = Vector2(bitmask.get_size())
@onready var max_distance = size.x / 2

func _process(_delta):
	if visible and GManager.is_mobile:
		move()

func move():
	if is_pressed():
		var mouse_pos = get_local_mouse_position()
		input.position = mouse_pos.clamp(size * LIMIT_MULTIPLIER, size * (1 - LIMIT_MULTIPLIER)) - START_POS
		apply_input()
	else:
		input.position = START_POS

func apply_input():
	reset_input()
	
	var movement = input.position - START_POS
	
	"""
	var distance = movement.distance_to(Vector2.ZERO) / max_distance
	if distance > MIN_OFFSET:
		var angle = rad_to_deg(atan2(movement.y, movement.x))
		if angle > -60 and angle < 60:
			Input.action_press("Right")
		if angle > 30 and angle < 150:
			Input.action_press("Down")
		if angle > 120 or angle < -120:
			Input.action_press("Left")
		if angle > -150 and angle < -30:
			Input.action_press("Up")
	"""
	
	Input.action_press("Right", movement.distance_to(Vector2(-max_distance, 0)) / max_distance)
	Input.action_press("Down", movement.distance_to(Vector2(0, -max_distance)) / max_distance)
	Input.action_press("Left", movement.distance_to(Vector2(max_distance, 0)) / max_distance)
	Input.action_press("Up", movement.distance_to(Vector2(0, max_distance)) / max_distance)
		
func reset_input():
	Input.action_release("Right")
	Input.action_release("Down")
	Input.action_release("Left")
	Input.action_release("Up")

func _on_released():
	reset_input()

func _on_tree_exiting():
	reset_input()
