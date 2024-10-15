module type Tree = sig
  type 'a t

  (** [insert v t] inserts a [v] into a [t]. *)
  val insert : 'a -> 'a t -> 'a t

  (** [mem v t] checks if a [v] is a member of a [t]. *)
  val mem : 'a -> 'a t -> 'a t option
end

module BinaryTree: Tree = struct
  type 'a t =
    | Leaf
    | Node of { l : 'a t; v : 'a; r : 'a t }

  let rec insert v = function
    | Leaf -> Node { l = Leaf; v = v; r = Leaf }
    | Node { l = l'; v = v'; r = r' } as curr ->
      if v < v' then Node { l = insert v l'; v = v'; r = r' }
      else if v > v' then Node { l = l'; v = v'; r = insert v r' }
      else curr

  let rec mem v = function
    | Leaf -> None
    | Node { l = l'; v = v'; r = r' } as curr ->
      if v < v' then mem v l'
      else if v > v' then mem v r'
      else Some curr
end
