module main

import vm.hardware as vm

struct J{
	pub mut:
		rd i8
		imm u32
}

struct R{
	pub mut:
		rd  u8;
		rs1 u8;
		rs2 u8;
}

struct I{
	pub mut:
		rd  u8;
		rs1 u8;
		imm u16;
}

struct U{
	pub mut:
		rd  u8;
		imm u32;
}

struct B{
	pub mut:
		rs1 u8;
		rs2 u8;
		imm u16;
}

struct Instruction{
	pub mut:
		fmt_r R
		fmt_i I
		fmt_b B
		fmt_u U
}

fn (inst Instruction) add() {
	
	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.sum(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) sub() {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.sub(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) xor() {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.xor(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) _or () {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu._or(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) and() {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.and(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) sll() {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.sll(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) sra() {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.sra(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) slt() {

	mut rd  := inst.fmt_r.rd
	mut rs1 := inst.fmt_r.rs1
	mut rs2 := inst.fmt_r.rs2

	vm.cpu.registers[rd] = vm.cpu.alu.slt(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
}

fn (inst Instruction) sltu() { inst.slt() }

fn (inst Instruction) lw() { 
	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.RAM[vm.cpu.slu.sum(vm.cpu.registers[rs1], imm)]
}

fn (inst Instruction) beq() {
	mut rs1 := inst.fmt_b.rs1
	mut rs2 := inst.fmt_b.rs2
	mut imm := inst.fmt_b.imm

	vm.cpu.alu.beq(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
	
	if vm.cpu.alu.s == 1 { vm.cpu.pc += imm }
}

fn (inst Instruction) bne() {
	
	mut rs1 := inst.fmt_b.rs1
	mut rs2 := inst.fmt_b.rs2
	mut imm := inst.fmt_b.imm

	vm.cpu.alu.beq(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
	
	if vm.cpu.alu.s == 0 { vm.cpu.pc += imm }
}

fn (inst Instruction) blt() {
	
	mut rs1 := inst.fmt_b.rs1
	mut rs2 := inst.fmt_b.rs2
	mut imm := inst.fmt_b.imm

	vm.cpu.alu.slt(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
	
	if vm.cpu.alu.s == 1 { vm.cpu.pc += imm }
}

fn (inst Instruction) bge() {
	
	mut rs1 := inst.fmt_b.rs1
	mut rs2 := inst.fmt_b.rs2
	mut imm := inst.fmt_b.imm

	vm.cpu.alu.beq(vm.cpu.registers[rs1], vm.cpu.registers[rs2])	
	if vm.cpu.alu.s == 1 { vm.cpu.pc += imm }

	vm.cpu.alu.slt(vm.cpu.registers[rs1], vm.cpu.registers[rs2])
	if vm.cpu.alu.s == 1 { vm.cpu.pc += imm }
}

fn (inst Instruction) bltu() { inst.blt() }

fn (inst Instruction) bgeu() { inst.bgeu() }

fn (inst Instruction) jal() {
	mut rd  := inst.fmt_j.rd
	mut imm := inst.fmt_j.imm

	vm.cpu.registers[rd] = vm.cpu.pc + 4
	vm.cpu.pc += imm
}

fn (inst Instruction) jalr() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.pc + 4
	vm.cpu.pc = vm.cpu.registers[rs1] + imm
}

fn (inst Instruction) lui() {

	mut rd  := inst.fmt_u.rd
	mut imm := inst.fmt_u.imm

	vm.cpu.registers[rd] = vm.cpu.alu.sll(imm, 12)
}

fn (inst Instruction) auipc() {
	mut rd  := inst.fmt_u.rd
	mut imm := inst.fmt_u.imm

	vm.cpu.registers[rd] = vm.cpu.pc + vm.cpu.alu.sll(imm, 12)
}

fn (inst Instruction) ecall() {
	vm.cpu.cpu_control = 'kernel'
}

fn (inst Instruction) addi() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.addi(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) subi() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.subi(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) xori() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.xori(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) ori () {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.ori(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) andi() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.andi(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) slli() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.slli(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) srai() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.srai(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) slti() {

	mut rd  := inst.fmt_i.rd
	mut rs1 := inst.fmt_i.rs1
	mut imm := inst.fmt_i.imm

	vm.cpu.registers[rd] = vm.cpu.alu.slti(vm.cpu.registers[rs1], imm)
}

fn (inst Instruction) sltiu() { inst.slti() }

