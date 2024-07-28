extends Area3D

var range

func _ready():
	var tween = create_tween()
	var rng_position = Vector3(randi_range(-1,1), 1, randi_range(-1,1))
	tween.tween_property(self, "position", position + rng_position, 0.3)
	
	range = randi_range(0,7)
	get_node("small_potion").hide()
	get_node("large_potion").hide()
	get_node("long_sword").hide()
	get_node("large_armor").hide()
	get_node("small_shield").hide()
	get_node("large_shield").hide()
	get_node("small_helmet").hide()
	get_node("large_helmet").hide()
	
	match range:
		0:
			get_node("small_potion").show()
		1:
			get_node("large_potion").show()
		2:
			get_node("long_sword").show()
		3:
			get_node("small_shield").show()
		4:
			get_node("large_shield").show()
		5:
			get_node("small_helmet").show()
		6:
			get_node("large_helmet").show()
		7:
			get_node("large_armor").show()					
			


func _on_body_entered(body):
	if body.is_in_group("player"):
		match range:
			0:
				get_node("../../GUI/container/Inventory").add_item("small_potion")
			1:
				get_node("../../GUI/container/Inventory").add_item("large_potion")
			2:
				get_node("../../GUI/container/Inventory").add_item("long_sword")
			3:
				get_node("../../GUI/container/Inventory").add_item("small_shield")			
			4:
				get_node("../../GUI/container/Inventory").add_item("large_shield")
			5:
				get_node("../../GUI/container/Inventory").add_item("small_helmet")
			6:
				get_node("../../GUI/container/Inventory").add_item("large_helmet")
			7:	
				get_node("../../GUI/container/Inventory").add_item("large_armor")
			
		self.queue_free()		
				
		
