extends Node2D

export(PackedScene) var PlayerClone

onready var parent_rb := get_parent() as RigidBody2D
onready var initial_rb_mode := parent_rb.mode
onready var RecordingState := $RecordingState
onready var PlayingState := $PlayingState
onready var LoopingState := $LoopingState

var recording := false
var playing := false
var looping := false
var time := 0.0
var clone = null

var start_position: Vector2
var start_rotation: float
var start_velocity: Vector2
var input_buffer := []

func enable_record_ability():
	print("enabled record")
	set_physics_process(true)

func disable_record_ability():
	print("disabled record")
	if recording:
		stop_recording()
	if playing:
		stop_playing()
	set_physics_process(false)
	
func _ready() -> void:
	RecordingState.visible = false
	PlayingState.visible = false
	LoopingState.visible = false
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_record"):
		if playing:
			# Error out
			print("cant record while playing")
			pass
		else:
			if not recording:
				start_recording()
			else:
				stop_recording()
	
	if Input.is_action_just_pressed("toggle_playback"):
		if recording:
			# Error out
			print("cant play while recording")
			pass
		else:
			if not playing:
				start_playing()
			else:
				stop_playing()
				
	if Input.is_action_just_pressed("toggle_looping"):
		looping = not looping
		LoopingState.visible = looping
		if clone != null:
			clone.looping = looping
	
	time += delta
	RecordingState.position = Vector2.UP * 5.0 * abs(sin(6.0 * time))
	PlayingState.position = Vector2.UP  * 5.0 * abs(sin(6.0 * time))
	
	if recording:
		input_buffer.append(parent_rb.get_input_state())


func start_recording() -> void:
	recording = true
	RecordingState.visible = true
	PlayingState.visible = false
	start_position = parent_rb.global_position
	start_rotation = parent_rb.global_rotation
	start_velocity = parent_rb.linear_velocity
	input_buffer = []
	input_buffer.append(parent_rb.get_input_state())
	
func stop_recording() -> void:
	recording = false
	RecordingState.visible = false
	PlayingState.visible = false
	
func start_playing() -> void:
	playing = true
	RecordingState.visible = false
	PlayingState.visible = true
	
	clone = PlayerClone.instance()
	clone.start_position = start_position
	clone.start_rotation = start_rotation
	clone.start_velocity = start_velocity
	clone.input_buffer = input_buffer
	clone.looping = looping
	
	# clone.rec_position = rec_position
	# clone.rec_rotation = rec_rotation
	# clone.rec_velocity = rec_velocity
	clone.recorder = self
	owner.add_child(clone)
	
func stop_playing() -> void:
	playing = false
	RecordingState.visible = false
	PlayingState.visible = false
	if clone != null:
		clone.queue_free()
