extends CharacterBody2D

@export var speed = 120
@export var attack_cooldown = 1.5
@export var is_retreating: bool
@export var retreat_time = 1
@export var retreat_speed = 400

var attack_range = 50
var gravity = 20
var jump_power = -350
var current_attack = false
var attack_type
var can_attack = false

@onready var player = $"../Player"

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity.x = speed * direction.x
	velocity.y += gravity
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

func toggle_flip_sprite(dir):
	if dir.x > 0:
		$AnimatedSprite2D.flip_h = false
	print(dir)
	if dir.x < 0:
		$AnimatedSprite2D.flip_h = true
