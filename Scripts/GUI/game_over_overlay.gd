extends CanvasLayer


func _ready():
	self.hide()


func _on_retry_pressed():
	Game.player_health = Game.player_health_max
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.show()
	get_tree().paused = true	
