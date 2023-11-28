extends Node2D

@onready var light_particles = $LightParticles
@onready var dark_particles = $DarkParticles

func explode():
	light_particles.emitting = true
	dark_particles.emitting = true
