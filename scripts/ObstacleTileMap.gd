extends TileMap

var barrier = preload("res://prefabs/barrier.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("place_barrier")):
		var coords = local_to_map(to_local(get_global_mouse_position()))
		if(get_cell_source_id(0, coords) == -1):
			var newBarrier = barrier.instantiate()
			newBarrier.set_pos(map_to_local(coords))
			%Barriers.add_child(newBarrier)
		#set_cell(1, coords, 4, Vector2i(0, 0), 0)
