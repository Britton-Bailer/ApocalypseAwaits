extends Control

@onready var itemSprite = $VBoxContainer/ItemSprite
@onready var itemStats = $VBoxContainer/ItemStats
@onready var buttonsContainer = $VBoxContainer/ButtonsContainer
@onready var buyButton = $VBoxContainer/ButtonsContainer/BuyButton
@onready var itemName = $VBoxContainer/ItemName

@onready var itemHelper = ItemHelper.new()

var item: BaseItemResource

func _ready():
	pass

func set_vars(itm: BaseItemResource):
	item = itm
	_ready()
	
	itemSprite = item.itemSprite
	itemStats.text = itemHelper.get_item_description(item.affectedStats)
	buyButton.text = "$" + str(item.itemCost)
	itemName.text = "[center]" + str(item.itemName) + "[/center]"

func _on_buy_button_pressed():
	if(ExpeditionManager.currency >= item.itemCost):
		ExpeditionManager.add_item(item)
		buyButton.disabled = true
		buyButton.text = "Sold"
