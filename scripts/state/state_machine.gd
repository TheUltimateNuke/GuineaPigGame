extends Node

@export var initial_state: BaseState

var current_state: BaseState
var states: Dictionary = {}

func _ready():
    for child in get_children():
        if child is BaseState:
            states[child.name] = child
            child.transitioned.connect(_on_child_transition)

    if initial_state:
        initial_state.enter()
        current_state = initial_state

func _process(delta):
    if current_state:
        current_state.update(delta)

func _physics_process(delta):
    if current_state:
        current_state.phys_update(delta)

func _on_child_transition(state, new_state_name):
    if state != current_state:
        return

    var new_state = states.get(new_state_name.to_lower())
    if !new_state:
        return

    if current_state:
        current_state.exit()
    