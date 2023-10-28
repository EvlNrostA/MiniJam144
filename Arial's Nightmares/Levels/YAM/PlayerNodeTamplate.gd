extends Player_library

func _ready():
	self.speed = 5000
	self.JUMP_VELOCITY = -600
	

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if is_on_floor() and Input.is_action_pressed("Right"):
		velocity.x = speed * delta
	elif is_on_floor():
		velocity.x -= 100 * delta		
	
	move_and_slide()

func check_hit():
	pass

func pushed():
	velocity = Vector2(-300, -300)
	pass	

func death():
	print("died")

