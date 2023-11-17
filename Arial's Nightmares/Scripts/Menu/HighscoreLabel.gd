extends Label

func _ready():
	text = "Highscore\n%d" % UI.get_highscore()
