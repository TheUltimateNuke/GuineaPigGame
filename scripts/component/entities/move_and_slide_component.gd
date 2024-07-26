extends Component
class_name MoveAndSlideComponent

@export var body: CharacterBody2D

func _ready():
	assert(body)

func _physics_process(_delta):
	body.move_and_slide()
