extends KinematicBody2D

var wheel_base = 25
var steering_angle = 15
var engine_power = 600
var friction = -0.9
var drag = -0.001
var braking = -450
var max_speed_reverse = 250
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7
var hp = 10

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction

var max_velocity
var impact_velocity
    
func _ready():
    max_velocity = calculate_max_velocity()
    
func _physics_process(delta):
    acceleration = Vector2.ZERO
    get_input()
    apply_friction()
    calculate_steering(delta)
    velocity += acceleration * delta
    impact_velocity = velocity
    velocity = move_and_slide(velocity)
    impact_velocity = impact_velocity - velocity
    handle_collision()

func calculate_max_velocity():
    return -friction/(2*drag) + sqrt(pow(friction/(2*drag),2) - engine_power/drag)
    
func handle_collision():
    if get_slide_count() > 0 and $CollisionCooldownTimer.time_left == 0:
        hp -= 1
        $CollisionCooldownTimer.start()
        flash()
        shake_screen()

func shake_screen():
    var trauma = 2 * impact_velocity.length() / max_velocity
    if trauma > 0:
        $ShakeCamera2D.current = true
        $ShakeCamera2D.add_trauma(trauma)
    
func unshake_screen():
    $Camera2D.current = true
    $ShakeCamera2D.trauma = 0.0

func flash():
    $Sprite.material.set_shader_param("flash_modifier", 1)
    $FlashTimer.start()

func unflash():
    $Sprite.material.set_shader_param("flash_modifier", 0)
    $FlashTimer.stop()

func apply_friction():
    if velocity.length() < 5:
        velocity = Vector2.ZERO
    var friction_force = velocity * friction
    var drag_force = velocity * velocity.length() * drag
    acceleration += drag_force + friction_force
    
func get_input():
    var turn = 0
    if Input.is_action_pressed("steer_right"):
        turn += 1
    if Input.is_action_pressed("steer_left"):
        turn -= 1
    steer_direction = turn * deg2rad(steering_angle)
    if Input.is_action_pressed("accelerate"):
        acceleration = transform.x * engine_power
    if Input.is_action_pressed("brake"):
        acceleration = transform.x * braking
        
func calculate_steering(delta):
    var rear_wheel = position - transform.x * wheel_base/2.0
    var front_wheel = position + transform.x * wheel_base/2.0
    rear_wheel += velocity * delta
    front_wheel += velocity.rotated(steer_direction) * delta
    var new_heading = (front_wheel - rear_wheel).normalized()
    var traction = traction_slow
    if velocity.length() > slip_speed:
        traction = traction_fast
    var d = new_heading.dot(velocity.normalized())
    if d > 0:
        velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
    if d < 0:
        velocity = -new_heading * min(velocity.length(), max_speed_reverse)
    rotation = new_heading.angle()
    
func _on_FlashTimer_timeout():
    var flash_modifier = $Sprite.material.get_shader_param("flash_modifier")
    $Sprite.material.set_shader_param("flash_modifier", abs(flash_modifier - 1))
    
func _on_CollisionCooldownTimer_timeout():
    unflash()
    unshake_screen()
