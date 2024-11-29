extends Node2D

@onready var shark = preload("res://shark.tscn")
var top = 267
var top_vel = 0
var bottom = 281
var bottom_vel = 0
var grav = 1200
var top_lock = false
var bottom_lock = false
var top_buf = []
var bottom_buf = []
var top_ready = 0
var bottom_ready = 0
@onready var pirate_top = $PirateTop
@onready var pirate_top_body = $PirateTop/Body
@onready var pirate_bottom = $PirateBottom
@onready var pirate_bottom_body = $PirateBottom/Body

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("top_up") and not top_lock:
		top_vel = 700
		top_lock = true
	else:
		pirate_top.play("default")
		top_vel -= grav*delta
	pirate_top.position.y -= top_vel*delta
	if pirate_top.position.y > 225:
		pirate_top.position.y = 225
	if pirate_top.position.y > 220:
		top_lock = false
	
	if Input.is_action_just_pressed("bottom_down") and not bottom_lock:
		bottom_vel = 700
		bottom_lock = true
	else:
		pirate_bottom.play("default")
		bottom_vel -= grav*delta
	pirate_bottom.position.y += bottom_vel*delta
	if pirate_bottom.position.y < 422:
		pirate_bottom.position.y = 422
	if pirate_bottom.position.y < 427:
		bottom_lock = false
	
	top_ready += delta
	bottom_ready += delta
	
	if top_ready > 2:
		if randf() < top_ready/10:
			var n_shark = shark.instantiate()
			add_child(n_shark)
			top_buf.append(n_shark)
			top_buf[-1].position = Vector2(1200,267)
			top_ready = 0
			print('Top Shark!')
	
	if bottom_ready > 2:
		if randf() < bottom_ready/10:
			var n_shark = shark.instantiate()
			add_child(n_shark)
			bottom_buf.append(n_shark)
			bottom_buf[-1].position = Vector2(1200,381)
			bottom_buf[-1].rotation = PI
			bottom_ready = 0
			print('Bottom Shark!')
	
	for i in top_buf:
		i.position.x -= delta*300
		if i.position.x <= -60:
			i.queue_free()
			top_buf.erase(i)
	
	for i in bottom_buf:
		i.position.x -= delta*300
		if i.position.x <= -60:
			i.queue_free()
			bottom_buf.erase(i)
