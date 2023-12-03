extends Node2D

@onready var manager = get_parent()
@onready var light = $Light

@onready var elapsed = 0
@onready var active = false

var min_deg
var max_deg
var speed

func _ready():
	light.hide()
	# off camera texture
	pass

func start(min_deg, max_deg, speed):
	self.min_deg = min_deg
	self.max_deg = max_deg
	self.speed = speed

	light.show()
	# on camera texture
	self.active = true

func _process(delta):
	if active:
		rotation = sin_wave(min_deg, max_deg, speed, elapsed)
		print(rotation_degrees)
		elapsed += delta
	
func sin_wave(min_deg: float, max_deg: float, period: float, time: float):
	var min_rad = deg_to_rad(min_deg)
	var max_rad = deg_to_rad(max_deg)
	
	var amplitude = (max_rad + min_rad) / 2.0
	var offset = (max_rad - min_rad) / 2.0
	
	var degrees = offset * sin(PI * period * time) + amplitude
	return degrees
	
func triangle_wave(min_deg: float, max_deg: float, frequency: float, time: float):
	var min_rad = deg_to_rad(min_deg)
	var max_rad = deg_to_rad(max_deg)
	
	var amplitude = (max_rad + min_rad) / 2.0
	var offset = (max_rad - min_rad) / 2.0
	var period = 1.0 / frequency
	
	var degrees = ((4.0 * amplitude) / period) * abs(fmod((time - (period / 4.0)), period) - (period / 2.0)) - amplitude + offset
	return degrees
