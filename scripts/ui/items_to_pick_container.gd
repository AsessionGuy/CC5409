extends GridContainer

var timer

# Called when the node enters the scene tree for the first time.

var items_by_name = []


func _ready() -> void:
	set_process(false)
	


func set_items(list_of_items):
	Debug.log(list_of_items)
	for i in range(0,5):
		
		set_texture_to_item(list_of_items[i] ,"Item" + str(i+1))
	
func set_texture_to_item(name:String, item_name: String):
	
	var path = "res://assets/2d/items/" + name + ".png"
	
	var item: TextureRect = self.get_node(item_name)
	
	var image = Image.load_from_file(path)
	
	if item:
		
		item.texture = ImageTexture.create_from_image(image)
		
		items_by_name.append([name,item_name])

		
	else:
	
		printerr("The item does not exist")
		
	self.show()
	
	
func delete_item_by_name(name: String):
	Debug.log(name)
	Debug.log(items_by_name)
	var pair = null
	var index 

	for i in items_by_name:

		if i[0] == name:
			pair = i
			break

	if not pair:
		return 


	var item: TextureRect = self.get_node(pair[1])

	if item:

		item.queue_free()

		items_by_name.erase(pair)

	else:

		printerr('The item does not exist')
