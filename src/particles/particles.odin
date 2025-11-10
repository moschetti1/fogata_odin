package particles

Particle :: struct {
	x, y:       f32,
	vx, vy:     f32,
	accx, accv: f32,
	mass:       f32,
	lifetime:   f32,
}

Emitter :: struct {
	particles:        [dynamic]Particle,
	x, y:             f32,
	originx, originy: f32,
	recx, recy:       f32,
	gravity:          f32,
	is_active:        bool,
	max_lifetime:     f32,
	spawn_rate:       f32,
}

new_emitter :: proc(posx, posy, recx, recy, gravity: f32) -> (emitter: Emitter) {
	emitter.x = posx
	emitter.y = posy
	emitter.recx = recx
	emitter.recy = recy
	emitter.gravity = gravity
	return emitter
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
	// TODO: make this a function to have more control over noise calculations
	for i in 0 ..< particles_to_emit {
		p := &Particle{}
		p.x = emitter.originx
		p.y = emitter.originy
		append(&emitter.particles, p^)
	}

	for &p, ix in emitter.particles {
		p.lifetime += dt
		p.vy += emitter.gravity * dt
		p.y += p.vy * dt
	}
	for i in 0 ..< len(emitter.particles) {
		ordered_remove(&emitter.particles, i)
	}
}

