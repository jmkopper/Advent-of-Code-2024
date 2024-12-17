fn parse_instructions(text: String) raises -> List[Int]:
    var instructions = List[Int]()
    var s = text.strip().split(": ")[1].split(",")
    for c in s:
        instructions.append(atol(c[]))
    return instructions


fn parse_registers(text: String) raises -> List[Int]:
    var registers = List[Int]()
    var s = text.strip().splitlines()
    for line in s:
        var t = line[].split(": ")
        registers.append(atol(t[1]))
    return registers


struct VirtualMachine:
    var register_a: Int
    var register_b: Int
    var register_c: Int
    var instructions: List[Int]
    var ip: Int
    var outputs: List[Int]

    fn __init__(
        inout self, a: Int, b: Int, c: Int, owned instructions: List[Int]
    ):
        self.register_a = a
        self.register_b = b
        self.register_c = c
        self.instructions = instructions
        self.ip = 0
        self.outputs = List[Int]()

    fn get_operand(self, operand: Int) -> Int:
        if operand <= 3:
            return operand
        elif operand == 4:
            return self.register_a
        elif operand == 5:
            return self.register_b
        elif operand == 6:
            return self.register_c
        else:
            return -1

    fn opcode_adv(inout self):
        var denom = 2 ** self.get_operand(self.instructions[self.ip + 1])
        self.register_a //= denom

    fn opcode_bxl(inout self):
        self.register_b ^= self.instructions[self.ip + 1]

    fn opcode_bst(inout self):
        var val = self.get_operand(self.instructions[self.ip + 1])
        self.register_b = val % 8

    fn opcode_jnz(inout self):
        if self.register_a == 0:
            return
        self.ip = (
            self.instructions[self.ip + 1] - 2
        )  # ip is always incremented by 2

    fn opcode_bxc(inout self):
        self.register_b ^= self.register_c

    fn opcode_out(inout self):
        var operand = self.get_operand(self.instructions[self.ip + 1])
        self.outputs.append(operand % 8)

    fn opcode_bdv(inout self):
        var denom = 2 ** self.get_operand(self.instructions[self.ip + 1])
        self.register_b = self.register_a // denom

    fn opcode_cdv(inout self):
        var denom = 2 ** self.get_operand(self.instructions[self.ip + 1])
        self.register_c = self.register_a // denom

    fn run(inout self):
        while self.ip < len(self.instructions):
            var opcode = self.instructions[self.ip]
            if opcode == 0:
                self.opcode_adv()
            elif opcode == 1:
                self.opcode_bxl()
            elif opcode == 2:
                self.opcode_bst()
            elif opcode == 3:
                self.opcode_jnz()
            elif opcode == 4:
                self.opcode_bxc()
            elif opcode == 5:
                self.opcode_out()
            elif opcode == 6:
                self.opcode_bdv()
            elif opcode == 7:
                self.opcode_cdv()
            self.ip += 2


fn part1(inout v: VirtualMachine) -> String:
    v.run()
    var s = String()
    for val in v.outputs:
        s += str(val[]) + ","
    return s[:-1]


fn part2(instructions: List[Int]) raises -> Int:
    var q = List[Int](0)
    while len(q) > 0:
        var u = q.pop(0)
        u *= 8
        for n in range(8):
            var reg_a = u + n
            var vm = VirtualMachine(reg_a, 0, 0, instructions)
            vm.run()
            if vm.outputs == instructions[-len(vm.outputs) :]:
                q.append(reg_a)
            if vm.outputs == instructions:
                return reg_a
    return -1


fn main() raises:
    var contents: List[String]
    with open("input.txt", "r") as f:
        contents = f.read().strip().split("\n\n")
    var instructions = parse_instructions(contents[1])
    var registers = parse_registers(contents[0])
    var v = VirtualMachine(
        registers[0], registers[1], registers[2], instructions
    )
    print("Part 1:", part1(v))
    print("Part 2:", part2(instructions))
