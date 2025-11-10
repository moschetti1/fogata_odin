package fsm

import "core:fmt"

State :: struct($T: typeid) {
	name:      string,
	on_enter:  proc(data: ^T),
	on_update: proc(data: ^T),
	on_exit:   proc(data: ^T),
}

Transition :: struct($T: typeid) {
	from:      string,
	to:        string,
	condition: proc(data: $T) -> bool,
}

FSM :: struct($T: typeid) {
	states:        map[string]State(T),
	transitions:   [dynamic]Transition(T),
	current_state: string,
	data:          ^T,
}

fsm_init :: proc(fsm: ^FSM($T), data: ^T) {
	fs.states = make(map[string]State(T))
	fsm.transitions = make([dynamic]Transition(T))
	fsm.data = data
}

fsm_destroy :: proc(fsm: ^FSM($T)) {
	delete(fsm.states)
	delete(fsm.transitions)
}

fsm_add_state :: proc(
	fsm: ^FSM($T),
	name: string,
	on_enter: proc(data: ^T) = nil,
	on_update: proc(data: ^T) = nil,
	on_exit: proc(data: ^T) = nil,
) {
	fsm.states[name] = state(T) {
		name      = name,
		on_enter  = on_enter,
		on_update = on_update,
		on_exit   = on_exit,
	}
}

fsm_add_transition :: proc(
	fsm: ^FSM($T),
	from: string,
	to: string,
	condition: proc(data: ^T) -> bool,
) {
	append(&fsm.transitions, Transition(T){from = from, to = to, condition = condition})
}


fsm_set_state :: proc(fsm: ^FSM($T), state_name: string) {
	if state_name in fsm.states {
		fsm.current_state = state_name
		state := fsm.states[state_name]
		if state.on_enter != nil {
			state.on_enter(fsm.data)
		}
	}
}

fsm_update :: proc(fsm: ^FSM($T)) {
	for &trans in fsm.transitions {
		if trans.from == fsm.current_state && trans.condition(fsm.data) {
			_transition(fsm, trans.to)
			break
		}
	}
	if fsm.current_state in fsm.states {
		state := fsm.states[fsm.current_state]
		if state.on_update != nil {
			state.on_update(fsm.data)
		}
	}
}

_transition :: proc(fsm: ^FSM($T), to_state: string) {
	if !(to_state in fsm.states) do return

	if fsm.current_state in fsm.states {
		current := fsm.states[fsm.current_state]
		if current.on_exit != nil {
			current.on_exit(fsm.data)
		}
	}

	fsm.current_state = to_state
	new_state := fsm.states[to_state]
	if new_state.on_enter != nil {
		new_state.on_enter(fsm.data)
	}
}

