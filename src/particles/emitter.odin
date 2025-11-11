package particles

import utils "../utils"

EmitterSpawnShape :: enum {
	RECTANGLE,
	CIRCLE,
	RING,
}

Emitter :: struct {
	particles:          [dynamic]Particle,
	max_particles:      int,
	x, y:               f32,
	width, height:      f32,
	spawn_shape:        EmitterSpawnShape,
	spawn_rate:         f32,
	initial_speed:      f32,
	speed_noise:        f32,
	gravity:            f32,
	friction:           f32,
	spread_angle:       f32,
	direction:          f32,
	is_active:          bool,
	particle_age:       f32,
	particle_age_noise: f32,
}


activate_emiter :: proc(emitter: ^Emitter) {
	emitter.is_active = true
}

destroy_emitter :: proc(emitter: ^Emitter) {
	emitter.is_active = false
	delete(emitter.particles)
}

emitter_update :: proc(emitter: ^Emitter, dt: f32) {
	if !emitter.is_active do return

	particles_to_emit := emitter.spawn_rate * dt
	for i in 0 ..< int(particles_to_emit) {
		spawn_single_particle(emitter)
	}

	for &p, ix in emitter.particles {
		p.age += dt
		if p.age >= p.max_age {
			p.is_active = false
		}
		p.vy += emitter.gravity * dt

		if emitter.friction > 0 {
			noise_x := utils.noise_1d(p.age * 3.0) * emitter.friction
			p.vx += noise_x * dt * 100.0

			noise_y := utils.noise_1d(p.age * 2.5 + 100) * emitter.friction * 0.5
			p.vy += noise_y * dt * 100.0
		}
		p.x += p.vx * dt
		p.y += p.vy * dt
	}

	for i in 0 ..< len(emitter.particles) {
		if !emitter.particles[i].is_active {
			ordered_remove(&emitter.particles, i)
		}
	}
}

