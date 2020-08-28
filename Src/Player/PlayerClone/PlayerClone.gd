extends RigidBody2D

var start_position
var start_rotation
var start_velocity
var input_buffer

var current_frame := 0
var total_frames := 0
var recorder
var looping : bool

const WALK_ACCEL = 1000.0
const WALK_DEACCEL = 1000.0
const WALK_MAX_VELOCITY = 300.0
const AIR_ACCEL = 600.0
const AIR_DEACCEL = 600.0
const JUMP_VELOCITY = 650
const STOP_JUMP_FORCE = 450.0
const MAX_SHOOT_POSE_TIME = 0.3
const MAX_FLOOR_AIRBORNE_TIME = 0.15

var jumping = false
var stopping_jump = false
var shooting = false

var floor_h_velocity = 0.0

var airborne_time = 1e20
var shoot_time = 1e20

# input states
var move_left: bool
var move_right: bool
var jump: bool

func _ready() -> void:
	global_position = start_position
	global_rotation = start_rotation
	linear_velocity = start_velocity
	current_frame = 0
	total_frames = len(input_buffer)
	pass

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if current_frame < total_frames:
		# Get player input from buffer.
		move_left = input_buffer[current_frame].move_left
		move_right = input_buffer[current_frame].move_right
		jump = input_buffer[current_frame].jump
		
		simulate_player_movement(state)
		current_frame += 1
	else:
		if looping:
			global_position = start_position
			global_rotation = start_rotation
			linear_velocity = start_velocity
			current_frame = 0
		else:
			queue_free()
			recorder.stop_playing()
	
func simulate_player_movement(state: Physics2DDirectBodyState) -> void:
	var lv = state.get_linear_velocity()
	var step = state.get_step()
	
	# Deapply prev floor velocity.
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	if lv.x < -100.0:
		$PlayerGraphics.scale.x = -abs($PlayerGraphics.scale.x)
	if lv.x > 100.0:
		$PlayerGraphics.scale.x = abs($PlayerGraphics.scale.x)
	
	# Find the floor (a contact with upwards facing collision normal).
	var found_floor = false
	var floor_index = -1
	
	for x in range(state.get_contact_count()):
		var ci = state.get_contact_local_normal(x)
		
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x
	
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air.
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump.
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down.
			jumping = false
		elif not jump:
			stopping_jump = true
		
		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step
	
	if on_floor:
		# Process logic when character is on floor.
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				var accel_boost := 1.0
				if lv.x > 0.0:
					accel_boost = 2.0
				lv.x -= accel_boost * WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				var accel_boost := 1.0
				if lv.x < 0.0:
					accel_boost = 2.0
				lv.x += accel_boost * WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		# Check jump.
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false

	else:
		# Process logic when the character is in the air.
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
	
	# Apply floor velocity.
	if found_floor:
		floor_h_velocity = state.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity
	
	# Finally, apply gravity and set back the linear velocity.
	lv += state.get_total_gravity() * step
	state.set_linear_velocity(lv)

func destroy():
	queue_free()
	recorder.stop_playing()
	print("Player clone killed")
	pass
