## Generic state machine. Initializes states and delegates engine callbacks
## (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

## Emitted when transitioning to a new state.
signal transitioned(state_name)

## Path3D to the initial active state. We export it to be able to pick the initial state in the inspector.
@export 
var initial_state := NodePath()

@export 
var update_physics_process: bool = true
@export 
var update_process: bool = true

## The current active state. At the start of the game, we get the `initial_state`.
@onready 
var state: State = get_node(initial_state)

## Starting function
func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.s_enter()

## The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.s_handle_input(event)

## Normal Game Loop
func _process(delta: float) -> void:
	if !update_process: 
		return
	state.s_update(delta)

## Physics Loop
func _physics_process(delta: float) -> void:
	if !update_physics_process: 
		return
	state.s_physics_update(delta)

## Initial Physics Step Before Anything
func integrate_forces(physics_state) -> void:
	if state.has_method("s_integrate_forces"):
		state.s_integrate_forces(physics_state)

## This function calls the current state's exit() function, then changes the active state,
## and calls its enter function.
## It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not has_node(target_state_name):
		return

	state.s_exit()
	state = get_node(target_state_name)
	state.s_enter(msg)
	emit_signal("transitioned", state.name)
