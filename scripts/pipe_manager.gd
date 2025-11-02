class_name PipeStateManager
extends RefCounted

var pipes: Array[Node2D] = []

func add_pipe(pipe: Node2D) -> void:
	pipes.append(pipe)

func tick() -> void:
	# Run one simultaneous simulation step.
	
	# Phase 1: Calculate all planned transfers
	var transfers: Dictionary = {}
	for pipe in pipes:
		transfers[pipe] = []

	for pipe in pipes:
		if not pipe.isOpen() or pipe.water <= 0 or pipe.is_leaf():
			continue

		# Find all connected pipes that can receive water
		var available_children: Array[Node2D] = []
		for child in pipe.connected_pipes:
			if child.water < child.capacity:
				available_children.append(child)

		var total_outflow: int = 0
		var amount_per_child: int = 0

		if available_children.size() > 0:
			total_outflow = min(pipe.water, available_children.size())
			amount_per_child = total_outflow / available_children.size()

		# Record how much to send to each connection
		for child in available_children:
			transfers[child].append(amount_per_child)

		# Deduct from parent immediately (so we don't double count)
		pipe.sub_water(total_outflow) 

	# Phase 2: Apply all inflows simultaneously
	for pipe in transfers.keys():
		for amt in transfers[pipe]:
			pipe.receive(amt)
