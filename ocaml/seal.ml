module type StackSig = sig
  type 'a t

  val empty : 'a t
end

(* EXAMPLE №1: SAVED CONSISTENCY WITH THE INTERFACE (SIGNATURE), BUT SEALED AT DECLARATION *)
module Stack : StackSig = struct
  type 'a t = 'a List.t

  let empty = []
end

let example_ok : int Stack.t = Stack.empty
let example_err : int Stack.t = [] (* error: expected `int Stack.t`, got `int List.t` *)

(* EXAMPLE №2: SAVED CONSISTENCY WITH THE INTERFACE (SIGNATURE), BUT WAS NOT SEALED *)
module StackImpl = struct
  type 'a t = 'a List.t

  let empty = []
end

module Stack : StackSig = StackImpl

let example_ok : int Stack.t = Stack.empty
let example_err : int StackImpl.t = [] (* no error: it was not sealed at declaration *)

(** EXPLANATION: in a second example, when we assign `StackImpl` module to newly created module `Stack`,
    OCaml had only just checked the consistency with interface (`: StackSig`) of `StackImpl`, but haven't
    sealed any declarations inside `StackImpl` because we _assigned_ it to the newly created module `Stack`,
    that now represents implementation of a `StackSig` signature we just created. Now, `Stack` has sealed
    interface definitions, but `StackImpl` has not and we can use it as if we got no abstraction type of `t`. *)
