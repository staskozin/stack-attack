extends Box

func on_consume() -> void:
	for i in range(Field.width):
		for j in range(Field.height):
			if Field.field[i][j] != self \
			and Field.field[i][j] is Box:
				Field.field[i][j].destroy()
