extends GridContainer

var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	


func set_items(list_of_items):
	
	for i in range(0,5):
		
		set_texture_to_item("res://assets/2d/items/" + list_of_items[i] + ".png","Item" + str(i+1))
	
func set_texture_to_item(path:String, item_name: String):
	
	var item: TextureRect = self.get_node(item_name)
	
	var image = Image.load_from_file(path)
	
	if item:
		
		item.texture = ImageTexture.create_from_image(image)

		
	else:
	
		printerr("The item does not exist")
		
	self.show()
	
func delete_item(item_name: String):
	
	var item: TextureRect = self.get_node(item_name)
	
	if item:
		
		item.queue_free()
		
	else:

		printerr('The item does not exist')
