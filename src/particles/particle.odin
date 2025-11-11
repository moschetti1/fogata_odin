package particles

import "core:math"
import "core:math/rand"

Particle :: struct {
	x, y:         f32,
	vx, vy:       f32,
	noise_offset: f32,
	age:          f32,
	max_age:      f32,
	is_active:    bool,
}

get_spawn_position :: proc(emitter: ^Emitter) -> (x: f32, y: f32) {
	switch emitter.spawn_shape {
	case .RECTANGLE:
		x = emitter.x + rand.float32_range(-emitter.width / 2, emitter.width / 2)
		y = emitter.y + rand.float32_range(-emitter.height / 2, -emitter.height / 2)
	case .CIRCLE:
		angle := rand.float32() * math.TAU
		radius := math.sqrt(rand.float32()) * emitter.width
		x = emitter.x + math.cos(angle) * radius
		y = emitter.y + math.sin(angle) * radius
	case .RING:
		angle := rand.float32() * math.TAU
		x = emitter.x + math.cos(angle) * emitter.width
		y = emitter.y + math.sin(angle) * emitter.width
	}

	return x, y
}

spawn_single_particle :: proc(emitter: ^Emitter) {
	if len(emitter.particles) >= emitter.max_particles do return
	p := Particle{}
	p.is_active = true
	p.x, p.y = get_spawn_position(emitter)
	p.noise_offset = rand.float32() * 1000.0
	p.max_age =
		emitter.particle_age +
		rand.float32_range(-emitter.particle_age_noise, emitter.particle_age_noise)

	speed := emitter.initial_speed + rand.float32_range(-emitter.speed_noise, emitter.speed_noise)

	angle :=
		emitter.direction + rand.float32_range(-emitter.spread_angle / 2, emitter.spread_angle / 2)

	p.vx = math.cos(angle) * speed
	p.vy = math.sin(angle) * speed
	append(&emitter.particles, p)
}

