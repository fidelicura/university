module Pointer = struct
  type 'a t = 'a ref option

  exception Segfault

  let null : 'a t = None

  let deref (ptr : 'a t) : 'a =
    match ptr with
    | None -> raise Segfault
    | Some x -> !x

  let malloc data = Some (ref data)
end
