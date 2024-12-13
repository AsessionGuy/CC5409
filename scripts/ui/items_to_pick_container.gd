extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_texture_to_item("res://assets/2d/items/soda_can.png", "Item1")


func set_texture_to_item(path:String, item_name: String):
	
	var item: TextureRect = self.get_node(item_name)
	
	var image = Image.load_from_file(path)
	
	if item:
		
		item.texture = ImageTexture.create_from_image(image)
		
	else:
		printerr("The item does not exist")
