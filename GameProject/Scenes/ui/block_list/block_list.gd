extends Control

export (Resource) var inventory_data = inventory_data as Inventory
onready var item_list = $PanelContainer/HBoxContainer/ItemList

func _process(delta):
	item_list.set_item_text(0, "Test " + str(inventory_data.bus_count))
	item_list.set_item_text(1, "Rampa " + str(inventory_data.ramp_count))
	item_list.set_item_text(2, "Bloco " + str(inventory_data.block_count))
