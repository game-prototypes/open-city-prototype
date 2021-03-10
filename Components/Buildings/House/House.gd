extends Building


func character_arrived(character: Character) -> void:
	.character_arrived(character)
	if character.type == "farmer":
		print("Farmer arrived")
