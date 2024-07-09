module main

import kernel

enum syscalls {
	EXIT,
	READ,
	WRITE
}

fn do_syscall(sys_code int)
{
	match sys_code :
		0 { kernel.exit()  }
		1 { kernel.read()  }
		2 { kernel.write() }
}