extends Area2D

var position_delay
var reveal_delay
var objects
var position_timer
var reveal_timer
var sprite
var current_object

func start_timer_randomly(timer, delay_range) -> void:
	timer.wait_time = randf_range(delay_range[0], delay_range[1])
	#print(timer.name + " wait time: ", timer.wait_time)
	timer.start()

func reveal_noam_fogle() -> void:
	sprite.visible = true
	start_timer_randomly(reveal_timer, reveal_delay)
	
func reposition_noam_fogle() -> void:
	sprite.visible = false
	
	var new_object = current_object
	while (new_object.get_meta("occupied")):
		var object_index = randi() % objects.size()
		new_object = objects[object_index]
	
	current_object.set_meta("occupied", false)
	new_object.set_meta("occupied", true)
	
	self.position = new_object.position
	current_object = new_object
	
	start_timer_randomly(position_timer, position_delay)
	
func start(new_objects, new_position_delay, new_reveal_delay) -> void:
	randomize()
	
	position_timer = $PositionTimer
	reveal_timer = $RevealTimer
	sprite = $Sprite2D
	
	objects = new_objects
	position_delay = new_position_delay
	reveal_delay = new_reveal_delay
	
	current_object = objects[0]
	current_object.set_meta("occupied", true)
	
	reposition_noam_fogle()

func _on_position_timer_timeout():
	reveal_noam_fogle()

func _on_reveal_timer_timeout():
	reposition_noam_fogle()

func _on_body_entered(body):
	# Add animation
	if (sprite.visible):
		body.killed_noam_fogle()
		current_object.set_meta("occupied", false)
		queue_free()
