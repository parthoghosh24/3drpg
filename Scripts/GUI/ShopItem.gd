extends Panel

var item_info: ItemData


func _on_button_pressed():
	get_node("../../").current_item = item_info
	get_node("../../ItemInfo").show()
	get_node("../../ItemInfo/item_name").text = item_info.item_name
	get_node("../../ItemInfo/item_desc").text = "%s \nStats: %s Damage, %s Defense, %s Health" % [item_info.description, item_info.item_damage, item_info.item_defense, item_info.item_health]
	get_node("../../ItemInfo/item_sprite").texture = item_info.item_texture
