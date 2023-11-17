extends TouchScreenButton

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	GManager.vibrate()
