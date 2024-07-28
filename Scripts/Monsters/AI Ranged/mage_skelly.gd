extends CharacterBody3D


const SPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var state_machine_controller = get_node("StateMachine")
@export var player: CharacterBody3D
@onready var item_object_scene = preload("res://Scenes/GUI/Inventory/item_object.tscn")
@onready var fireball_scene = preload("res://Scenes/Monsters/fireball.tscn")

var direction = Vector3()
var Awakening = false
var Attacking = false
var health = 4
var damage = 2
var dying = false
var just_hit = false

func _ready():
	state_machine_controller.change_state("Idle")
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player:
		direction = (player.global_transform.origin - self.global_transform.origin)
	move_and_slide()


func _on_just_hit_timeout():
	just_hit = false


func _on_chase_player_detection_body_entered(body):
	if "player" in body.name and !dying:
		state_machine_controller.change_state("Run")


func _on_chase_player_detection_body_exited(body):
	if "player" in body.name and !dying:
		state_machine_controller.change_state("Idle")


func _on_attack_player_detection_body_entered(body):
	if "player" in body.name and !dying:
		state_machine_controller.change_state("Attack")


func _on_attack_player_detection_body_exited(body):
	if "player" in body.name and !dying:
		state_machine_controller.change_state("Run")


func _on_animation_tree_animation_finished(anim_name):
	if "Awaken" in anim_name:
		Awakening = false
	elif "Attack" in anim_name:
		if player in $AttackPlayerDetection.get_overlapping_bodies():
			state_machine_controller.change_state("Attack")
	elif "Death" in anim_name:
		death()
		
func hit(damage):
	if !just_hit:
		get_node("JustHit").start()
	health -= damage
	just_hit = true
	if health <= 0:
		state_machine_controller.change_state("Death")
	#knocback
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position - (direction / 1.5), 0.2)	


func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and Attacking:
		body.hit(damage)

func death():
	var rng = randi_range(2,4)
	for i in rng:
		var item_object_scene_temp = item_object_scene.instantiate()
		item_object_scene_temp.global_position = self.global_position
		get_node("../../Items").add_child(item_object_scene_temp)
	Game.gain_exp(100)
	
	self.queue_free()


func _on_shoot_timeout():
	if is_instance_valid(player):
		if player in get_node("AttackPlayerDetection").get_overlapping_bodies():
			shoot()
	
func shoot():
	get_node("AnimationTree").get("parameters/playback").travel("Attack")
	await get_tree().create_timer(0.3).timeout
	var target_position = (player.global_position - self.global_position).normalized()
	#create fireball
	var fireball_temp = fireball_scene.instantiate()
	fireball_temp.direction = target_position
	fireball_temp.speed = 3
	fireball_temp.owner_name = "monster"
	fireball_temp.damage = self.damage
	fireball_temp.look_at(target_position)
	fireball_temp.global_position = get_node("Aim").global_position
	get_node("../../Projectiles").add_child(fireball_temp)
	await get_node("AnimationTree").animation_finished
	get_node("AnimationTree").get("parameters/playback").travel("Idle_Combat")
	if player in get_node("AttackPlayerDetection").get_overlapping_bodies():
		get_node("Shoot").start()
		
