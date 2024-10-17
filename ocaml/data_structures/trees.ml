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
    | Node { l = l'; v = v'; r = r' } as self ->
      if v < v' then Node { l = insert v l'; v = v'; r = r' }
      else if v > v' then Node { l = l'; v = v'; r = insert v r' }
      else self

  let rec mem v = function
    | Leaf -> None
    | Node { l = l'; v = v'; r = r' } as self ->
      if v < v' then mem v l'
      else if v > v' then mem v r'
      else Some self
end

module RedBlackTree: Tree = struct
  type 'a t =
    | Leaf
    | Node of color * 'a * 'a t * 'a t
  and color =
    | Red
    | Black

  let balance = function
    | Node (Black, z, Node (Red, y, Node (Red, x, a, b), c), d)
    | Node (Black, z, Node (Red, x, a, Node (Red, y, b, c)), d)
    | Node (Black, x, a, Node (Red, z, Node (Red, y, b, c), d))
    | Node (Black, x, a, Node (Red, y, b, Node (Red, z, c, d)))
      -> Node (Red, y, Node (Black, x, a, b), Node (Black, z, c, d))
    | Node (a, b, c, d) as self -> self
    | Leaf -> failwith "unreachable"

  let rec insert_aux v = function
    | Leaf -> Node (Red, v, Leaf, Leaf)
    | Node (_, v', l, r) as self ->
      if v > v' then balance (insert_aux v r)
      else if v < v' then balance (insert_aux v l)
      else self

  let insert v t =
    match insert_aux v t with
    | Leaf -> failwith "unreachable"
    | Node (_, v', l, r) -> Node (Black, v', l, r)

  let rec mem v = function
    | Leaf -> None
    | Node (_, v', l, r) as self ->
      if v < v' then mem v r
      else if v > v' then mem v l
      else Some self
end
