extends TouchScreenButton

const LIMIT_MULTIPLIER = 0.1667
const START_POS = Vector2(6, 6)
const MIN_OFFSET = 0.2

@onready var input = $InputButton
@onready var size = Vector2(bitmask.get_size())
@onready var max_distance = size / 2
@onready var max_length = max_distance.x

func _process(_delta):
	if visible and GManager.is_mobile:
		move()

func move():
	if is_pressed():
		#input.position = mouse_pos.clamp(size * LIMIT_MULTIPLIER, size * (1 - LIMIT_MULTIPLIER)) - START_POS
		var mouse_pos = get_local_mouse_position()
		var normalized_pos = mouse_pos - max_distance
		
		var angle = atan2(normalized_pos.x, normalized_pos.y)
		var movement = clamp(normalized_pos.length(), 0, max_length) * Vector2(sin(angle), cos(angle))
		input.position = movement + START_POS

		apply_input(movement)
	else:
		input.position = START_POS

func apply_input(movement):
	reset_input()
	
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
	
	Input.action_press("Right", movement.distance_to(Vector2(-max_length, 0)) / max_length)
	Input.action_press("Down", movement.distance_to(Vector2(0, -max_length)) / max_length)
	Input.action_press("Left", movement.distance_to(Vector2(max_length, 0)) / max_length)
	Input.action_press("Up", movement.distance_to(Vector2(0, max_length)) / max_length)
		
func reset_input():
	Input.action_release("Right")
	Input.action_release("Down")
	Input.action_release("Left")
	Input.action_release("Up")

func _on_released():
	reset_input()

func _on_tree_exiting():
	reset_input()
