extends Component
class_name MovementComponent

@export_subgroup("References")
@export var body: CharacterBody2D
@export var collider: CollisionShape2D
@export var nav_agent: NavigationAgent2D

@export_subgroup("Values")
@export var move_speed: float = 200
@export var move_friction: float = 5
@export var jump_velocity: float = 500

var dest: Vector2

func _ready():
    assert(body)