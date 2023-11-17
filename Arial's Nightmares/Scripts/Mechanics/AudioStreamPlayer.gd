extends AudioStreamPlayer

@onready var menu_music = preload("res://Assets/Music/MenuMusic.mp3")
@onready var level_music = preload("res://Assets/Music/LevelMusic.mp3")
@onready var animation_player = $AnimationPlayer

func play_music(music):
	stream = music
	play()
