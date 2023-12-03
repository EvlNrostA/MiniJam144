extends Player_library

@onready var manager = get_parent()
@onready var lost = false
var base_speed
var is_dash = false
var is_cooldown = true

func _ready():
	speed = 2
	base_speed = speed
	

func _process(delta):
	if not lost:
		Move2D(delta)
		
	if Input.is_action_just_pressed("Space") and is_cooldown == true:
		is_dash = true
		is_cooldown = false
		$speed_on_dash.start()
		$cooldown.start()
	
	# dashes
	if is_dash:
		speed = base_speed * 3
	else:
		speed = base_speed

func death():
	if not lost:
		lost = true 
		await death_animation()
		GManager.game_over()

func _on_cooldown_timeout():
	is_cooldown = true

func _on_speed_on_dash_timeout():
	is_dash = false
