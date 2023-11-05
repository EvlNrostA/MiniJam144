extends TouchScreenButton

const LIMIT_MULTIPLIER = 0.6667
const START_POS = Vector2(16, 16.5)
const MIN_OFFSET = 1.5

@onready var input = $InputSprite2D
@onready var size = Vector2(bitmask.get_size())

func _process(_delta):
	if visible and GManager.is_mobile:
		move()

func move():
	reset_input()
	
	if is_pressed():
		var mouse_pos = get_local_mouse_position()
		input.position = Vector2(clamp(mouse_pos.x, START_POS.x * LIMIT_MULTIPLIER, size.x * LIMIT_MULTIPLIER), 
								 clamp(mouse_pos.y, START_POS.y * LIMIT_MULTIPLIER, size.y * LIMIT_MULTIPLIER))
		apply_input()
	else:
		input.position = START_POS

func apply_input():
	var movement = input.position - START_POS
	print(movement)
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
