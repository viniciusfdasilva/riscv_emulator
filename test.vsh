
import readline

mut t := []string{}

fn start_cpu(){

	mut pc := 0

	for{
		if t.len != 0 {

			print(t[pc])
			pc++;
		}
	}
}

fn start_mem(){

	read := readline.Readline{}
	mut pc := 0

	for{
		mut str := read.read_line()
		t << str
	}
}

fn main(){

	mut threads := []thread{}

	threads << spawn start_cpu()
	threads << spawn start_mem()
	thread.wait()
}