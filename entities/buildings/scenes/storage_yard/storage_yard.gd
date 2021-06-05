extends Building

export var max_storage:int = 10
var storage: Storage

onready var full_sprite=$FullContentsSprite
onready var empty_sprite=$EmptyContentsSprite

func _ready():
	add_to_group(Global.BUILDING_ROLES.STORAGE)
	storage=Storage.new(max_storage)

func on_character_arrived(character: Character) -> void:
	.on_character_arrived(character)

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

func has_resource_quantity(resource: int, quantity:int) -> bool:
	return storage.get_resource_quantity(resource)>=quantity

func can_store(_resource: int, quantity:int)->bool:
	return storage.can_store_quantity(quantity)

func get_info()->Array:
	var info=.get_info()
	
	var space_text=String(storage.get_occupied_space())+"/"+String(storage.max_storage)
	info.append(space_text)
	var resources=storage.stored_resources
	for resource in resources:
		var resource_text=Global.resource_names[resource]+": "+String(resources[resource])
		info.append(resource_text)
	return info

func _update_sprites():
	var is_empty=storage.is_empty()
	empty_sprite.visible=is_empty
	full_sprite.visible=!is_empty

func serialize() -> Dictionary:
	return Utils.merge_dict(.serialize(), {
		"storage": storage.serialize()
	})

func load_data(data:Dictionary)->void:
	.load_data(data)
	storage.load_data(data.get("storage"))
