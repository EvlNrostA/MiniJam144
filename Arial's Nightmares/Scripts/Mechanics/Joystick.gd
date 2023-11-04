extends TouchScreenButton

const LIMIT_MULTIPLIER = 0.6667
const START_POS = Vector2(16, 16.5)

@onready var input = $InputSprite2D
@onready var size = Vector2(bitmask.get_size())

func _process(_delta):
	if GManager.is_mobile:
		move()

func move():
	if is_pressed():
		var mouse_pos = get_local_mouse_position()
		input.position = Vector2(clamp(mouse_pos.x, START_POS.x * LIMIT_MULTIPLIER, size.x * LIMIT_MULTIPLIER), 
								 clamp(mouse_pos.y, START_POS.y * LIMIT_MULTIPLIER, size.y * LIMIT_MULTIPLIER))
		apply_input()
	else:
		input.position = START_POS
		reset_input()

func apply_input():
	var movement = input.position - START_POS
	print(movement)
	
	if movement.x > 0:
		#Input.action_press("Right")
		#print("Right")
		GManager.add_input("Right", true)
	if movement.y > 0:
		#Input.action_press("Down")
		#print("Down")
		GManager.add_input("Down", true)
	if movement.x < 0:
		#Input.action_press("Left")
		#print("Left")
		GManager.add_input("Left", true)
	if movement.y < 0:
		#Input.action_press("Up")
		#print("Up")
		GManager.add_input("Up", true)
		
func reset_input():
	Input.action_release("Right")
	Input.action_release("Down")
	Input.action_release("Left")
	Input.action_release("Up")
