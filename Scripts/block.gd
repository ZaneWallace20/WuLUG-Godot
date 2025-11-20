'''

the block script, its very simple move on -z at set speed

'''

extends StaticBody3D

var speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# must use delta
	
	'''
	
	delta is the time (in seconds) between frames, this is so that no matter what
	the FPS we can keep the gameplay the same
	
	lets say the block needs to move 1 unit 1 second
	
	at 1 FPS we move one unit per frame
	but at 2 FPS we need to move 0.5 units per frame
	
	delta, in this trivial example, would be 1/1 and 1/2 
	
	from this we can derive this formula 
	
	block_speed * delta 
	
	to let us move correctly
	
	'''
	position.z -= delta * speed
	
	# remove block when out of bounds (we respect ram)
	if position.z <= -30:
		queue_free()
