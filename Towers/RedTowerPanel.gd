extends Panel

@onready var tower = preload("res://Towers/RedBullet.tscn")
var currTile
var placingTank = false
var tempTower = null

func _on_gui_input(event):
	if Game.Gold >= 10:
		if event is InputEventMouseButton and event.button_mask == 1:
			if !placingTank:
				# Inicia la colocación del tanque en el primer clic
				placingTank = true
				tempTower = tower.instantiate()
				add_child(tempTower)
				tempTower.scale = Vector2(0.32, 0.32)
				tempTower.global_position = event.global_position
				Game.Gold -= 25
				return

			if tempTower != null:
				# Coloca el tanque en la posición del segundo clic
				tempTower.global_position = event.global_position

		elif event is InputEventMouseMotion and event.button_mask == 1:
			# Actualiza la posición del tanque mientras se arrastra
			if placingTank and tempTower != null:
				tempTower.global_position = event.global_position
				# Aquí puedes realizar las comprobaciones adicionales si es necesario

		elif event is InputEventMouseButton and event.button_mask == 0:
			if placingTank:
				placingTank = false
				if event.global_position.x >= 2944:
					# Cancela la colocación si se hace clic fuera del área válida
					if tempTower != null:
						tempTower.queue_free()
				else:
					if currTile == Vector2i(4, 5):
						# Coloca el tanque en el mapa si el clic se realiza en una posición válida
						var path = get_tree().get_root().get_node("Main/Towers")
						path.add_child(tempTower)
						tempTower.get_node("Area").hide()
						Game.Gold -= 10  # Resta 10 de oro al colocar una torreta
		else:
			# En caso de otros eventos o clics, cancela la colocación del tanque
			if placingTank:
				placingTank = false
				if tempTower != null:
					tempTower.queue_free()
