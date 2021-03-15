extends Building

export var max_storage:int = 10
var storage: Storage

onready var full_sprite=$FullContentsSprite
onready var empty_sprite=$EmptyContentsSprite

func _ready():
	storage=Storage.new(max_storage)

func character_arrived(character: Character) -> void:
	.character_arrived(character)
	if character is Transporter:
		# TODO: validate space
		storage.store(character.resource_type,character.resource_type)
		character.resource_ammount=0
		empty_sprite.visible=false
		full_sprite.visible=true
