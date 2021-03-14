extends Building


func character_arrived(character: Character) -> void:
	.character_arrived(character)
	if character is Transporter:
		character.resource_ammount=0
