extends CharacterBody2D


@onready var deal_damage_zone = $DealDamageZone


var speed = 150
var gravity = 20
var jump_power = -350
var current_attack = false
var attack_type
var can_attack = false

func _ready() -> void:
	$DealDamageZone/Collision_attack2.disabled = true
	$DealDamageZone/Collision_attack1.disabled = true

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power
	
	velocity.x = speed * direction
	velocity.y += gravity
	
	if !current_attack and can_attack:
		if Input.is_action_just_pressed("attack1") or Input.is_action_just_pressed("attack2"):
			current_attack = true
			can_attack = false
			speed = 20
			if Input.is_action_just_pressed("attack1"):
				attack_type = "1"
			if Input.is_action_just_pressed("attack2"):
				attack_type = "2"
			handler_attack_animation(attack_type)
	
	
	handle_slopes()
	move_and_slide()
	handler_movement_animations(direction)
	
	
func handler_movement_animations(dir):
	if is_on_floor() and !current_attack:
		if !velocity:
			$AnimatedSprite2D.play("idle")
		if velocity:
			$AnimatedSprite2D.play("run")
			toggle_flip_sprite(dir)
	else:
		if !is_on_floor() and !current_attack:
			$AnimatedSprite2D.play("fall")
	

func handler_attack_animation(attack_type):
	if current_attack:
		print(attack_type)
		var animation = str("attack", attack_type)
		$AnimatedSprite2D.play(animation)
		
		toggle_damage_collisions(attack_type)


func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("Collision_attack2")
	var damage_zone_collision2 = deal_damage_zone.get_node("Collision_attack1")
	var wait_time = 1
	
	if attack_type == "2":
		damage_zone_collision.disabled = false
	if attack_type == "1":
		damage_zone_collision2.disabled = false
	await get_tree().create_timer(wait_time).timeout
	if attack_type == "2":
		damage_zone_collision.disabled = true
	if attack_type == "1":
		damage_zone_collision2.disabled = true
	
	
func toggle_flip_sprite(dir):
	if dir == 1:
		$AnimatedSprite2D.flip_h = false
		deal_damage_zone.scale.x = 1
	if dir == -1:
		$AnimatedSprite2D.flip_h = true
		deal_damage_zone.scale.x = -1
	
func handle_slopes():
	var is_slope
	var slope = get_floor_normal().x
	if is_on_floor() and slope > 0:
		is_slope = true
		floor_snap_length = 8
	else:
		is_slope = false
		

func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false
	$Timer.start()
	speed = 150


func _on_timer_timeout() -> void:
	can_attack = true
