extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vel = Vector2.RIGHT

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		vel.y += gravity * delta
	# Handle Jump.
	#velocity.y = JUMP_VELOCITY
	
	#vel.x = delta * SPEED

	move_and_collide(vel, SPEED * delta)
