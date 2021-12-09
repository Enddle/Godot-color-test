extends RigidBody2D

export (float) var pos_x
export (float) var pos_y
export (float) var size
export (Color) var tint

var is_coloring = false
var coloring_i = 0.0
var new_tint
var tinted = false

# Initialize position, size, default color, and collision size
func _ready():
	var p = Vector2(pos_x, pos_y)
	var s = Vector2(size, size)
	
	position = p
	weight = size * size
	
	$sprite.scale = s
	$sprite.modulate = tint
	
	$collision.shape.radius = size * 100
	
	pass

func _physics_process(delta):
	
	# color transition by linear interpolate
	if is_coloring:
		if coloring_i > 1:
			coloring_i = 1
			is_coloring = false
		$sprite.modulate = tint.linear_interpolate(new_tint, coloring_i)
		coloring_i += delta
	
	pass

# Start coloring
#	return false when it has started already
func coloring(c) -> bool:
	if tinted:
		return false
	
	# set new color for transition
	tinted = true
	new_tint = c
	coloring_i = 0.0
	is_coloring = true
	
	return true

# Activate physics
func activate():
	custom_integrator = false
	sleeping = false

# Delete from node tree when out of screen
func _on_notifier_screen_exited():
	queue_free()
