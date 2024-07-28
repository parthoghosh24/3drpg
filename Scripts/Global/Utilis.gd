extends Node

const SAVE_PATH = "res://savegame.bin"

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {}
	var inventory = get_node("/root/Level 1/GUI/container/Inventory")
	for i in inventory.get_child(0).get_child_count():
		if inventory.get_child(0).get_child(i).get_child_count() > 0:
			var item_data = inventory.get_child(0).get_child(i).get_child(0).data
			data[item_data.item_name] = item_data.count
			
	var jstr = JSON.stringify(data)
	file.store_line(jstr)		

func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var inventory = get_node("/root/Level 1/GUI/container/Inventory")
	if !file:
		return
	
	if file == null:
		return	
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				for i in current_line:
					for item_count in current_line[i]:
						inventory.add_item(str(i))
					
