extends Area2D

var death_delay = [0.2, 0.4]

@onready var position_timer = $PositionTimer
@onready var reveal_timer = $RevealTimer
@onready var death_timer = $DeathTimer
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var position_delay
var reveal_delay
var objects
var current_object

func start_timer_randomly(timer, delay_range) -> void:
	timer.wait_time = randf_range(delay_range[0], delay_range[1])
	#print(timer.name + " wait time: ", timer.wait_time)
	timer.start()

func reveal_noam_fogle() -> void:
	sprite.visible = true
	animation_player.play("Jumping")
	await animation_player.animation_finished
	
	start_timer_randomly(reveal_timer, reveal_delay)
	
func reposition_noam_fogle() -> void:
	animation_player.play_backwards("Jumping")
	await animation_player.animation_finished
	sprite.visible = false
	
	var new_object = current_object
	#while new_object.get_meta("occupied"):
	var object_index = randi() % objects.size()
	new_object = objects[object_index]
	
	#current_object.set_meta("occupied", false)
	#new_object.set_meta("occupied", true)
	print(new_object)
	
	self.position = new_object.position
	current_object = new_object
	
	start_timer_randomly(position_timer, position_delay)
	
func start(objects, position_delay, reveal_delay) -> void:
	randomize()
	
	self.objects = objects
	self.position_delay = position_delay
	self.reveal_delay = reveal_delay
	
	current_object = objects[0]
	#current_object.set_meta("occupied", true)
	
	reposition_noam_fogle()

func _on_position_timer_timeout():
	reveal_noam_fogle()

func _on_reveal_timer_timeout():
	reposition_noam_fogle()

func _on_body_entered(body):	
	if sprite.visible:
		body.killed_noam_fogle()
		
		position_timer.stop()
		reveal_timer.stop()
		animation_player.play("Death")
		await animation_player.animation_finished
		
		self.visible = false
		current_object.set_meta("occupied", false)

func _on_area_entered(area):
	print("overlap")
