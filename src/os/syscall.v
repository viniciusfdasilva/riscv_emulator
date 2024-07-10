module main

import kernel as os

cmds := {
	'EXIT'  : 0
	'READ'  : 1
	'WRITE' : 2
}

fn do_syscall(sys_code int)
{
	match sys_code :
		0 { os.kernel.exit()  }
		1 { os.kernel.read()  }
		2 { os.kernel.write() }
}