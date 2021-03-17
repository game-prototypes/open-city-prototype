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
		_update_sprites()
		return true
	else:
		return false

func try_to_get(resource: int, quantity:int)->int:
	var returned_quantity=min(quantity, storage.get_resource_quantity(resource))
	storage.remove(resource,returned_quantity)
	_update_sprites()
	return returned_quantity

func _update_sprites():
	var is_empty=storage.is_empty()
	empty_sprite.visible=is_empty
	full_sprite.visible=!is_empty
