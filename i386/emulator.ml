open Core
open Types

let to_signed8 x =
  let sign = x lsr 7 in
  let body = lnot (x - 1) |> (land) 0xFF in
  if sign = 0 then x else (-1) * body

let create_emu memory_size eip esp: t =
  let init_reg = {eax = 0; ebx = 0; ecx = 0; edx = 0; esi = 0; edi = 0; esp = esp; ebp = 0;} in
  {registers = init_reg; eflags = 0; memory = Array.create ~len:memory_size 0; eip = eip;}

let update_memory (emu: t) data =
  if List.length data >= Array.length emu.memory
  then failwith "Data is bigger than memory size";
  {emu with memory = List.to_array data}

let update_register (registers: registers) reg data =
  let open Const in
  if reg = n_eax then {registers with eax = data}
  else failwith @@ Printf.sprintf "Register %x does not exist" reg

let dump_registers emu =
  Printf.printf
    ("EAX = 0x%08x\nECX = 0x%08x\nEDX = 0x%08x\n"
     ^^ "EBX = 0x%08x\nESP = 0x%08x\nEBP = 0x%08x\n"
     ^^ "ESI = 0x%08x\nEDI = 0x%08x\nEIP = 0x%08x\n")
    emu.registers.eax emu.registers.ecx emu.registers.edx
    emu.registers.ebx emu.registers.esp emu.registers.ebp
    emu.registers.esi emu.registers.edi emu.eip

let instruction_of =
  function
  | 0xEB -> Some short_jump
  | x when 0xB8 <= x && x < 0xB8 + Const.register_count -> Some mov_r32_imm32
  | _ -> None
(*  let instraction = Array.create ~len:256 None in
  List.iter ~f:(fun i -> instraction.(0xB8 + i) <- Some mov_r32_imm32) (List.range 0 8);
  instraction.(0xEB) <- Some short_jump;
  fun code -> instraction.(code) *)

(*
let run emu =
  let memory_size = Array.length emu.memory in
  let rec main_loop emu =
    if emu.eip >= memory_size then failwith "Out of Memory"
    else
      let code = get_code8 emu 0 in
      match instruction_of code with
      | None -> failwith @@ Printf.sprintf "Not Implemented: %x" code
      | Some inst ->
         let emu' = inst emu in
         print_endline @@ "program_counter:" ^ (string_of_int emu'.eip);
         if emu'.eip = 0x00 then emu' else main_loop emu'
  in
  main_loop emu |> dump_registers
*)
  
