extends Node2D

@onready var shark = preload("res://shark.tscn")
var top = 267
var top_vel = 0
var bottom = 281
var bottom_vel = 0
var grav = 1400
var top_lock = false
var bottom_lock = false
var top_buf = []
var over = false
var bottom_buf = []
var top_dist = 3
var bottom_dist = 5
var speed = 1.2
var count = 0
var score = 0
var doubloons = []
var doubloons_areas = []
var bottom_buf_areas = []
var top_buf_areas = []
@onready var score_num = $ScoreNumber
@onready var pirate_top = $PirateTop
@onready var pirate_bottom = $PirateBottom

func _process(delta: float) -> void:
	if not over:
		if Input.is_action_just_pressed("top_up") and not top_lock:
			top_vel = 650
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
			bottom_vel = 650
			bottom_lock = true
		else:
			pirate_bottom.play("default")
			bottom_vel -= grav*delta
		pirate_bottom.position.y += bottom_vel*delta
		if pirate_bottom.position.y < 422:
			pirate_bottom.position.y = 422
		if pirate_bottom.position.y < 427:
			bottom_lock = false
		
		if speed < 2:
			if count < 2:
				count += delta
			else:
				speed += delta/175
		else:
			speed += delta/1500
		
		top_dist -= delta
		bottom_dist -= delta
		
		score += delta*10
		score_num.text = str(floor(score))
		
		if top_dist <= 0:
			var n_shark = shark.instantiate()
			n_shark.position = Vector2(1200,267)
			var n_shark_body = n_shark.get_node("Body")
			n_shark_body.collision_layer = 0b100
			add_child(n_shark)
			top_buf.append(n_shark)
			top_buf_areas.append(n_shark_body)
			top_dist = (randi_range(20,40)/10)/speed
		
		if bottom_dist <= 0:
			var n_shark = shark.instantiate()
			n_shark.position = Vector2(1200,381)
			n_shark.rotation = PI
			var n_shark_body = n_shark.get_node("Body")
			n_shark_body.collision_layer = 0b1000
			add_child(n_shark)
			bottom_buf.append(n_shark)
			bottom_buf_areas.append(n_shark_body)
			bottom_dist = (randi_range(20,40)/10)/(speed*1.08)
		
		for i in doubloons:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				i.queue_free()
				doubloons.erase(i)
				doubloons_areas.erase(i.get_node("Body"))
		
		for i in top_buf:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				i.queue_free()
				top_buf.erase(i)
				top_buf_areas.erase(i.get_node("Body"))
		
		for i in bottom_buf:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				i.queue_free()
				bottom_buf.erase(i)
				bottom_buf_areas.erase(i.get_node("Body"))
	else:
		pirate_top.pause()
		pirate_bottom.pause()

func _on_body_area_entered(area: Area2D) -> void:
	if area in top_buf_areas or area in bottom_buf_areas:
		over = true
		print(over)
	elif area in doubloons_areas:
		score += 50
