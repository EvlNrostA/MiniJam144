extends Sprite2D

const MIN_WAIT = 4
const MAX_WAIT = 13

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var animation

func start(animation):
	rotation = 0
	self.animation = animation
	start_timer()
	
func start_timer():
	timer.start(randf_range(MIN_WAIT, MAX_WAIT))

func _on_timer_timeout():
	animation_player.play(animation)
	start_timer()
