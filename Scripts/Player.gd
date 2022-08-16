extends KinematicBody2D

#Move
const SPEED = 500
const ACC = 10

#Jump
var fall_gravity_scale := 150.0
var low_jump_gravity_scale := 100.0
var jump_power := 700.0
var jump_released = false

#Physics
var motion = Vector2()
var gravity = 9.807
var gravity_scale := 100.0

func _physics_process(delta):
	move()
	jump(delta)
	
	motion = move_and_slide(motion, Vector2.UP)

func move():
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = max(motion.x - ACC, -SPEED)
		$Sprite.flip_h = true
		$Sprite.position.x = 15
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = min(motion.x + ACC, SPEED)
		$Sprite.flip_h = false
		$Sprite.position.x = 0
	else:
		motion.x = lerp(motion.x, 0, 0.25)

func jump(delta):
	if Input.is_action_just_released("jump"):
		jump_released = true
	
	motion += Vector2.DOWN * gravity * gravity_scale * delta
	
	if motion.y > 0: motion += Vector2.DOWN * gravity * fall_gravity_scale * delta
	
	elif motion.y < 0 && jump_released: motion += Vector2.DOWN * gravity * low_jump_gravity_scale * delta
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion += Vector2.UP * jump_power
			jump_released = false
