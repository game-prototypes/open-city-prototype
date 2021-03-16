extends Building

export var max_storage:int = 10
var storage: Storage

onready var full_sprite=$FullContentsSprite
onready var empty_sprite=$EmptyContentsSprite

func _ready():
	storage=Storage.new(max_storage)

func character_arrived(character: Character) -> void:
	.character_arrived(character)

func try_to_store(resource: int, quantity:int)->bool:
	if storage.can_store_quantity(quantity):
		storage.store(resource,quantity)
		empty_sprite.visible=false
		full_sprite.visible=true
		return true
	else:
		return false
