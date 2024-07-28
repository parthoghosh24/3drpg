class_name InventorySlot
extends PanelContainer

@export var type: ItemData.Type

func init(t: ItemData.Type, cms: Vector2):
	type = t
	custom_minimum_size = cms

func _can_drop_data(at_position, data):
	if data is InventoryItem:
		if type == ItemData.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).data.type == data.data.type	
		else:
			return data.data.type == type
	return false		

func _drop_data(at_position, data):
	if get_child_count() > 0:
		var item = get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	data.reparent(self)	

func _physics_process(delta):
	# check equipment
	if get_child_count() > 0:
		var item = get_child(0)
		
		match type:
			ItemData.Type.WEAPON:
				Game.right_hand_equipped = item.data
			ItemData.Type.BODY:
				Game.body_equipped = item.data	
			_:
				Game.right_hand_equipped = load("res://Scenes/GUI/Inventory/DefaultStats/default_sword.tres")
				Game.body_equipped = load("res://Scenes/GUI/Inventory/DefaultStats/default_body_armor.tres")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.button_mask == 0:
			if get_child_count() > 0:
				if get_child(0).data.type == ItemData.Type.MISC:
					Game.heal_player(get_child(0).data.item_health)
					get_child(0).data.count -= 1
					get_child(0).get_child(0).text = str(get_child(0).data.count)
					if get_child(0).data.count <= 0:
						get_child(0).queue_free()
