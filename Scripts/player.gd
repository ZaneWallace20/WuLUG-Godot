'''

player script, used for moving around

'''

extends CharacterBody3D

@onready var head: Node3D = $Head

const SPEED = 5.0
const JUMP_VELOCITY = 5.5
const MOUSE_SENSE = 0.1


func  _unhandled_input(event: InputEvent) -> void:
	
	# grab mouse events ONLY
	if event is InputEventMouseMotion:
		
		# make sure the mouse mode is what we want
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			
			# must be neg as it grabs relative position from last input
			rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSE))
			head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSE))
			
			# prevent going in virt circles
			head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# used for sprint
	var speed_multiplier := 1
	
	if Input.is_action_pressed("run"):
		speed_multiplier = 2
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	# must use vectors to prevent going sqrt(2) * speed when pressing multiple keys
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * speed_multiplier
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
