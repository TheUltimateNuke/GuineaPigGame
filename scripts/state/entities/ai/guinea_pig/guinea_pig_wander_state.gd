extends BaseState # Basically just a Node

@export var movement_component: MovementComponent
@export var nav_agent: NavigationAgent2D

@export var wander_radius: float = 20
@export var min_wander_time: float = 1
@export var max_wander_time: float = 4
@export var closeness_disregard_distance: float = 1

var wander_time: float
var previous_path_pos: Vector2
var next_path_pos: Vector2
var already_jumped_this_time: bool

func _ready():
    nav_agent.path_desired_distance = 4.0
    nav_agent.target_desired_distance = 4.0

func _randomize_wander():
    wander_time = randf_range(min_wander_time, max_wander_time)
    movement_component.dest = movement_component.body.global_position + RandomUtils.random_inside_unit_circle() * wander_radius

func should_jump() -> bool:
    var collider_shape = movement_component.collider.shape
    if not collider_shape is CapsuleShape2D:
        return false

    return movement_component.body.is_on_floor() and movement_component.dest and ComparisonUtils.is_within_range(next_path_pos.y, movement_component.body.global_position.y - movement_component.jump_velocity, movement_component.body.global_position.y - collider_shape.radius)

func enter(): # Think of as _ready()
    assert(min_wander_time < max_wander_time)

func update(delta: float):
    if wander_time > 0:
        wander_time -= delta
    else:
        _randomize_wander()
        nav_agent.target_position = movement_component.dest

func phys_update(_delta):
    var current_agent_position: Vector2 = movement_component.body.global_position
    movement_component.body.velocity.x = movement_component.body.velocity.move_toward(Vector2.ZERO, movement_component.move_friction).x

    if nav_agent.is_navigation_finished():
        return
    
    if previous_path_pos != next_path_pos:
        previous_path_pos = next_path_pos
        already_jumped_this_time = false
    next_path_pos = nav_agent.get_next_path_position()

    movement_component.body.velocity.x = movement_component.body.velocity.move_toward((current_agent_position.direction_to(next_path_pos) * movement_component.move_speed), movement_component.move_speed).x
    if should_jump() and (not previous_path_pos or previous_path_pos.distance_to(next_path_pos) < closeness_disregard_distance) and not already_jumped_this_time:
        movement_component.body.velocity.y = -movement_component.jump_velocity
        already_jumped_this_time = true