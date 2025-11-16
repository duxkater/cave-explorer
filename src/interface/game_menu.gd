extends CanvasLayer

@onready var map: Map = %Map
@onready var tab_bar = $VBoxContainer/TabBar

@onready var stats_panel: Panel = $VBoxContainer/PanelContainer/StatsPanel
@onready var inventory_panel: Panel = $VBoxContainer/PanelContainer/InventoryPanel
@onready var spells_panel: Panel = $VBoxContainer/PanelContainer/SpellsPanel

func _on_tab_bar_tab_changed(tab: int) -> void:
	hide_all_panels()
	match tab:
		0:
			stats_panel.show()
		1:
			inventory_panel.show()
		2:
			spells_panel.show()

func hide_all_panels():
	stats_panel.hide()
	inventory_panel.hide()
	spells_panel.hide()
