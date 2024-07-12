
module main

import vm
import instruction

struct Alu{
	pub mut:
		a u8
		b u8
		s u8
}

fn (alu Alu) sum() { alu.s = alu.a + alu.b; }
fn (alu Alu) sub() { alu.s = alu.a - alu.b; }
fn (alu Alu) mul() { alu.s = alu.a * alu.b; }
fn (alu Alu) div() { alu.s = alu.a / alu.b; }

fn (alu Alu) or()  { alu.s = alu.a |  alu.b  }
fn (alu Alu) and() { alu.s = alu.a &  alu.b  }
fn (alu Alu) xor() { alu.s = alu.a ^  alu.b  }
fn (alu Alu) sll() { alu.s = alu.a << alu.b  }
fn (alu Alu) sra() { alu.s = alu.a >> alu.b  }
fn (alu Alu) slt() { alu.s = alu.a <  alu.b ? 1 : 0}
fn (alu Alu) slt() { alu.s = alu.a >  alu.b ? 1 : 0}
fn (alu Alu) beq() { alu.s = alu.a == alu.b ? 1 : 0}

struct CPU{
	pub:
		num_of_registers := 32

	pub mut:
		pc u32 := 0
		ic u32 := 0
		registers[num_of_registers]u8
		alu Alu
		cpu_control := none	
		current_instruction := Instruction{
			fmt_r: R{}, 
			fmt_i: I{}, 
			fmt_b: B{}, 
			fmt_u: U{}, 
			fmt_j: J{},
		}
}

fn (cpu CPU) start_cpu()
{
	for
	{
		if cpu.ic != 0 {
			u32 instruction := cpu.fetch()
			cpu.decode(instruction)
			cpu.run()
		}
	}
}

fn (cpu CPU) fetch() u32
{
	u32 instruction := vm.RAM[cpu.pc];
	cpu.pc += 4

	return instruction 
}

fn (cpu CPU) decode(u32 instruction)
{
	mut opcode := (instruction & 0x7F)

	match opcode {
		
		0x33 {

			mut funct3 := (instruction & 0xA80)	 >> 7
			mut rd     := 
			mut rs1    := 
			mut rs2    := 
			mut funct7 := 

			cpu.current_instruction.fmt_r.opcode := opcode 
			cpu.current_instruction.fmt_r.funct3 := funct3
			cpu.current_instruction.fmt_r.funct7 := funct7
			cpu.current_instruction.fmt_r.rs1    := rs1
			cpu.current_instruction.fmt_r.rs2    := rs2
			cpu.current_instruction.fmt_r.rd     := rd
			
			cpu.current_instruction.fmt_i = none
			cpu.current_instruction.fmt_j = none
			cpu.current_instruction.fmt_s = none
			cpu.current_instruction.fmt_b = none
			cpu.current_instruction.fmt_u = none
		}

		0x13, 0x03, 0x37, 0x73 {

			// I
			
			mut funct3 := (instruction & 0x7000) >> 12

			opcode u8;
			funct3 u8;
			rd     u8;
			rs1    u8;
			imm    u16;

			cpu.current_instruction.fmt_i.opcode := opcode 
			cpu.current_instruction.fmt_i.funct3 := funct3
			cpu.current_instruction.fmt_i.imm 	 := imm
			cpu.current_instruction.fmt_i.rs1    := rs1
			cpu.current_instruction.fmt_i.rs2    := rs2
			cpu.current_instruction.fmt_i.rd     := rd

			cpu.current_instruction.fmt_r = none
			cpu.current_instruction.fmt_j = none
			cpu.current_instruction.fmt_s = none
			cpu.current_instruction.fmt_b = none
			cpu.current_instruction.fmt_u = none
		}
	
		0x23 {
			// S	

			opcode u8;
			funct3 u8;
			rs1    u8;
			rs2    u8;
			imm2   u8;
			imm1   u8;	

			cpu.current_instruction.fmt_s.opcode := opcode 
			cpu.current_instruction.fmt_s.funct3 := funct3
			cpu.current_instruction.fmt_s.imm2   := imm2
			cpu.current_instruction.fmt_s.imm1   := imm1
			cpu.current_instruction.fmt_s.rs1 	 := rs1
			cpu.current_instruction.fmt_s.rs2    := rs2

			cpu.current_instruction.fmt_r = none
			cpu.current_instruction.fmt_j = none
			cpu.current_instruction.fmt_i = none
			cpu.current_instruction.fmt_b = none
			cpu.current_instruction.fmt_u = none

		}

		0x63 {
			// B

			opcode u8;
			funct3 u8;
			rs1    u8;
			rs2    u8;
			imm1   u8;
			imm2   u8;

			cpu.current_instruction.fmt_b.opcode := opcode 
			cpu.current_instruction.fmt_b.funct3 := funct3
			cpu.current_instruction.fmt_b.imm2   := imm2
			cpu.current_instruction.fmt_b.imm1   := imm1
			cpu.current_instruction.fmt_b.rs1 	 := rs1
			cpu.current_instruction.fmt_b.rs2    := rs2

			cpu.current_instruction.fmt_r = none
			cpu.current_instruction.fmt_j = none
			cpu.current_instruction.fmt_s = none
			cpu.current_instruction.fmt_i = none
			cpu.current_instruction.fmt_u = none
		}

		0x6F {
			// J

			opcode u8;
			rd     u8;
			imm    u32;

			cpu.current_instruction.fmt_j.opcode := opcode 
			cpu.current_instruction.fmt_j.imm    := imm
			cpu.current_instruction.fmt_j.rd     := rd

			cpu.current_instruction.fmt_r = none
			cpu.current_instruction.fmt_i = none
			cpu.current_instruction.fmt_s = none
			cpu.current_instruction.fmt_b = none
			cpu.current_instruction.fmt_u = none
		}

		0x17 {
			// U
			opcode u8;
			rd     u8;
			imm    u32;

			cpu.current_instruction.fmt_u.opcode := opcode 
			cpu.current_instruction.fmt_u.rd     := rd
			cpu.current_instruction.fmt_u.imm    := imm

			cpu.current_instruction.fmt_r = none
			cpu.current_instruction.fmt_j = none
			cpu.current_instruction.fmt_s = none
			cpu.current_instruction.fmt_b = none
			cpu.current_instruction.fmt_i = none
		}
	}

}

fn (cpu CPU) run(u32 instruction)
{
	if cpu.current_instruction.fmt_j != none {

		// inserir elementos
		cpu.jal()

	}else if cpu.current_instruction.fmt_r != none {

		match cpu.current_instruction.funct3 {
		
			0x0 {

				match cpu.current_instruction.funct7 {
					0x00 { cpu.current_instruction.add() }
					0x20 { cpu.current_instruction.sub() }
				}	
			}

			0x4 { cpu.current_instruction.xor() }
			0x6 { cpu.current_instruction._or() }
			0x7 { cpu.current_instruction.and() }
			0x1 { cpu.current_instruction.sll() }

			0x5 {

				match cpu.current_instruction.funct7 {
					0x00 { cpu.current_instruction.srl() }
					0x20 { cpu.current_instruction.sra() }
				}
			}

			0x2 { cpu.current_instruction.slt()  }
			0x3 { cpu.current_instruction.sltu() }
		}

	}else if cpu.current_instruction.fmt_s != none {

		match cpu.current_instruction.funct3 {
			0x0 { cpu.current_instruction.sb() }
			0x1 { cpu.current_instruction.sh() }
			0x2 { cpu.current_instruction.sw() }
		}


	}else if cpu.current_instruction.fmt_b != none {

		match cpu.current_instruction.funct3 {

			0x0 { cpu.current_instruction.beq()  }
			0x1 { cpu.current_instruction.bne()  }
			0x4 { cpu.current_instruction.blt()  }
			0x5 { cpu.current_instruction.bge()  }
			0x6 { cpu.current_instruction.bltu() }
			0x7 { cpu.current_instruction.bgeu() }

		} 

	}else if chip.current_instruction.fmt_i != none {

		match cpu.current_instruction.opcode {
			
			0x13 {

				match cpu.current_instruction.funct3 {

					0x0 { cpu.current_instruction.addi()  }
					0x4 { cpu.current_instruction.xori()  }
					0x6 { cpu.current_instruction.ori()   }
					0x7 { cpu.current_instruction.andi()  }
					0x1 { cpu.current_instruction.slli()  }

					0x5 {
						cpu.current_instruction.srli()
						cpu.current_instruction.srai()	
					}

					0x2 { cpu.current_instruction.slti()  }
					0x3 { cpu.current_instruction.sltiu() }
				}
			}

			0x73 {

				match cpu.current_instruction.imm {

					0x0 { cpu.current_instruction.ecall()  }
					0x1 { cpu.current_instruction.ebreak() }
				}
			}
		}

		chip.ic--
	}
}