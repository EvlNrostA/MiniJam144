extends TouchScreenButton

const LIMIT_MULTIPLIER = 0.1667
const START_POS = Vector2(6, 6)
const MIN_OFFSET = 2

@onready var input = $InputButton
@onready var size = Vector2(bitmask.get_size())

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
	if movement.x > MIN_OFFSET and not Input.is_action_pressed("Right"):
		Input.action_press("Right")
	if movement.y > MIN_OFFSET and not Input.is_action_pressed("Down"):
		Input.action_press("Down")
	if movement.x < -MIN_OFFSET and not Input.is_action_pressed("Left"):
		Input.action_press("Left")
	if movement.y < -MIN_OFFSET and not Input.is_action_pressed("Up"):
		Input.action_press("Up")
		
func reset_input():
	Input.action_release("Right")
	Input.action_release("Down")
	Input.action_release("Left")
	Input.action_release("Up")

func _on_released():
	reset_input()
