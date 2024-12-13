extends StaticBody3D

@onready var area_3d: Area3D = $Area3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.is_multiplayer_authority() and body._controller.interactable:
		var item: Item = body._controller.interactable
		GameController.ui.ItemsToPickContainer.delete_item_by_name(item.item_name)
		GameController.delete_item(item.item_name)
		
