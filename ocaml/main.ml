let drop amt lst  =
  if List.length lst <= amt
  then []
  else
    let rec aux cnt lst =
    match lst with    
    | [] -> lst
    | h :: t -> if cnt = amt then lst else aux (cnt + 1) t
    in
    aux 0 lst;;
(* val drop : int -> 'a list -> 'a list = <fun> *)

let take amt lst  =
  if List.length lst < amt
  then lst
  else
    let rec aux acc cnt = function
    | [] -> List.rev acc
    | h :: t -> if cnt = amt then acc else aux (acc @ [h]) (cnt + 1) t
    in
    aux [] 0 lst;;
(* val take : int -> 'a list -> 'a list = <fun> *)

module MyTree = struct
  type 'a tree =
    | Leaf
    | Node of 'a * 'a tree * 'a tree

  let depth tr =
    let rec aux acc = function
    | Leaf -> acc
    | Node (_, l, r) -> max (aux (acc + 1) l) (aux (acc + 1) r)
    in
    aux 0 tr;;
  (* val depth : 'a tree -> int = <fun> *)

  let rec same_shape first second =
    match first, second with
    | Leaf, Leaf -> true
    | Node (_, _, _), Leaf | Leaf, Node (_, _, _) -> false
    | Node (_, l1, r1), Node (_, l2, r2) -> (same_shape l1 l2) && (same_shape r1 r2);;
  (* val same_shape : 'a tree -> 'b tree -> bool = <fun> *)

end

let list_max lst =
  if List.length lst = 0
  then failwith "list_max"
  else
    let rec aux acc = function
    | [] -> acc
    | h :: t -> if h > acc then aux h t else aux acc t
    in
    aux (List.nth lst 0) lst;;
(* val list_max : 'a list -> 'a = <fun> *)

let list_max_string lst =
  if List.length lst = 0
  then "empty"
  else
    let rec aux acc = function
    | [] -> string_of_int acc
    | h :: t -> if h > acc then aux h t else aux acc t
    in
    aux (List.nth lst 0) lst;;
(* val list_max_string : int list -> string = <fun> *)

let float_list_product lst = List.fold_left (fun acc x -> x *. acc) 1. lst;;
(* val float_list_product : float list -> float = <fun> *)

let terse_product_left = List.fold_left ( *. ) 1.;;
(* val terse_product_left : float list -> float = <fun>, improved version of `float_list_product` that is called via partial application *)

let rec create a b = if a > b then [] else a :: create (a + 1) b;;
(* val create : int -> int -> int list = <fun> *)

let sum_cube_odd n =
  create 0 n
  |> List.filter (fun x -> x mod 2 = 1)
  |> List.map (fun x -> x * x * x)
  |> List.fold_left (fun acc x -> x + acc) 0;;
(* val sum_cube_odd : int -> int = <fun> *)

let uncurried_nth (lst, n) = List.nth lst n;;
(* val uncurried_nth : 'a list * int -> 'a = <fun> *)

let keys assoc =
  assoc
  |> List.sort_uniq (fun (k1, _) (k2, _) -> Stdlib.compare k1 k2)
  |> List.fold_left (fun acc (k, _) -> k :: acc) [];;
(* val keys : ('a * 'b) list -> 'a list = <fun> *)

let is_valid_matrix = function
  | [] -> false
  | r :: rows ->
    let len = List.length r in
    len > 0 && List.for_all (fun r' -> len = List.length r') rows;;
(* val is_valid_matrix : 'a list list -> bool = <fun> *)

let add_row_vectors = List.map2 (fun elem1 elem2 -> elem1 + elem2);;
(* val add_row_vectors : int list -> int list -> int list = <fun> *)

module MyStack = struct
  type 'a stack = 'a List.t

  let empty = []

  let push elem st = elem :: st

  let peek = function
    | [] -> None
    | h :: _ -> Some h

  let pop = function
    | [] -> None
    | _ :: t -> Some t

  let peek_then_pop st =
    match peek st with
    | None -> None
    | Some elem -> Some (elem, match pop st with | None -> failwith "Unreachable" | Some st -> st)
end

let value =
  MyStack.empty
  |> MyStack.push 1
  |> MyStack.peek_then_pop;;
(* val value : (int * int list) option = Some (1, []) *)
