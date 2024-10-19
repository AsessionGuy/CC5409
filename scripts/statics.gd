class_name Statics
extends Node

const MAX_CLIENTS = 3
const PORT = 5409 # Number between 1024 and 65535.

enum Role {
	NONE,
	ROLE_A,
	ROLE_B,
}

class PlayerData:
	var id: int
	var name: String
	var index: int = 0
	var role: Role
	
	func _init(new_id: int, new_name: String, new_index: int = 0, new_role: Role = Role.NONE) -> void:
		id = new_id
		name = new_name
		index = new_index
		role = new_role
	
	func to_dict() -> Dictionary:
		return {
			"id": id,
			"name": name,
			"index": index,
			"role": role,
		}

enum ItemType {
	CerealBox,
	Chips,
	Soda
}

enum MeshType {
	Box,
	Bag,
	Bottle
}

const ITEMS = {
	ItemType.CerealBox: {
		"name": "Cereal Box",
		"description": "A delicious box of cereal.",
		"mesh_type": MeshType.Box,
		"mesh": "reference",
		"collision_shape": "reference"
	},
	ItemType.Chips: {
		"name": "Bag of Chips",
		"description": "A crunchy bag of potato chips.",
		"mesh_type": MeshType.Bag,
		"mesh": "reference",
		"collision_shape": "reference"
	},
	ItemType.Soda: {
		"name": "Soda Bottle",
		"description": "A refreshing bottle of soda.",
		"mesh_type": MeshType.Bottle,
		"mesh": "reference",
		"collision_shape": "reference"
	}
}

func get_item_data(item_type: ItemType) -> Dictionary:
	return ITEMS.get(item_type, {})
	
@rpc("any_peer", "call_local")
func get_item_data_rpc(item_id: int):
	var item_type = ItemType.values()[item_id]
	var item_data = get_item_data(item_type)
	rpc_id(get_tree().get_rpc_sender_id(), "receive_item_data_rpc", item_data)

@rpc("any_peer", "call_local")
func receive_item_data_rpc(item_data: Dictionary):
	print("Received item data: ", item_data)
