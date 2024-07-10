module main

import readline { read_line }

import syscall

fn sh(){

	print("# ")
	mut read_line := readline.Readline{}
	cmd := read_line()!

	sys_code := syscall[cmd] or { panic('Command not found:\n') } 
	kernel.do_syscall(sys_code)
}