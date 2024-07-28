extends Node

signal health_changed(damage)

var items = {
	"long_sword": preload("res://Scenes/GUI/Inventory/ItemResources/long_sword.tres"),
	"small_shield": preload("res://Scenes/GUI/Inventory/ItemResources/small_shield.tres"),
	"large_shield": preload("res://Scenes/GUI/Inventory/ItemResources/large_shield.tres"),
	"large_armor": preload("res://Scenes/GUI/Inventory/ItemResources/large_armor.tres"),
	"small_helmet": preload("res://Scenes/GUI/Inventory/ItemResources/small_helmet.tres"),
	"large_helmet": preload("res://Scenes/GUI/Inventory/ItemResources/large_helmet.tres"),
	"small_potion": preload("res://Scenes/GUI/Inventory/ItemResources/small_potion.tres"),
	"large_potion": preload("res://Scenes/GUI/Inventory/ItemResources/large_potion.tres")
}
var gold = 100
var player_health = 3
var player_health_max = 3
var right_hand_equipped: ItemData
var body_equipped: ItemData
var shopping = false

var player_damage = 0
var player_defense = 0

var current_xp: int = 0
var exp_to_next_level: int = 100
var player_level = 1

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	player_damage = right_hand_equipped.item_damage + body_equipped.item_damage
	player_defense = right_hand_equipped.item_defense + body_equipped.item_defense
	
func heal_player(amount):
	self.emit_signal("health_changed", -amount)
	player_health+= amount
	if player_health > player_health_max:
		player_health = player_health_max  

func gain_exp(exp_amount):
	current_xp += exp_amount
	while current_xp >= exp_to_next_level:
		#level up
		player_level += 1
		player_health_max += player_level * 10
		player_health = player_health_max
		current_xp -= exp_to_next_level
		exp_to_next_level = round(exp_to_next_level * 1.3)
		exp_to_next_level = exp_to_next_level * pow(1.2, player_level - 1)

func damage_player(damage_done):
	self.emit_signal("health_changed", damage_done)
	player_health -= damage_done		
