extends TouchScreenButton

const LIMIT_MULTIPLIER = 0.5
const START_POS = Vector2(6, 6)
const MIN_OFFSET = 0.2

@onready var input = $InputButton
@onready var size = Vector2(bitmask.get_size())
@onready var max_distance = size / 2
@onready var max_length = max_distance.x * LIMIT_MULTIPLIER

func _process(_delta):
	if visible and GManager.is_mobile:
		move()

func move():
	if is_pressed():
		var mouse_pos = get_local_mouse_position() - max_distance
		var movement = clamp(mouse_pos.length(), 0, max_length) * mouse_pos.normalized()
		
		input.position = movement + START_POS
		apply_input(movement)
		
	else:
		input.position = START_POS

func apply_input(movement):
	reset_input()
	
	var strength = movement / max_length
	Input.action_press("Right" if strength.x > 0 else "Left", abs(strength.x))
	Input.action_press("Down" if strength.y > 0 else "Up", abs(strength.y))

func _on_released():
	reset_input()

func _on_tree_exiting():
	reset_input()
	
func reset_input():
	Input.action_release("Right")
	Input.action_release("Down")
	Input.action_release("Left")
	Input.action_release("Up")

func _on_pressed():
	GManager.vibrate()
