module main

import readline { read_line }

import kernel

cmds := {
	'EXIT'  : 0
	'READ'  : 1
	'WRITE' : 2
}

fn sh(){

	print("# ")
	mut read_line := readline.Readline{}
	cmd := read_line()!

	sys_code := cmds[cmd] or { panic('Command not found:\n')} 
	kernel.do_syscall(sys_code)
}