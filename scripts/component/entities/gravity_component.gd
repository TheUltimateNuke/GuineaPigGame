extends Component
class_name GravComponent

@export var body: CharacterBody2D

var gravity: float = ProjectSettings.get("physics/2d/default_gravity")

func _ready():
    assert(body)

func _physics_process(delta: float):
    if not body.is_on_floor():
        body.velocity.y += gravity * delta