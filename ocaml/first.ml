module type MyStack = sig
  type 'a t

  val empty : 'a t

  val push : 'a t -> 'a -> 'a t

  val peek : 'a t -> 'a

  val pop : 'a t -> 'a t

  val peeknpop : 'a t -> 'a t * 'a
end

module MyStack : MyStack = struct
  type 'a t = 'a List.t

  let empty = []

  let push elem st =
    match st with
    | [] -> [elem]
    | _ :: x -> elem :: x

  let peek elem1 function
    | [] -> None
    | (elem2, st) :: 

end
