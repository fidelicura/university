open Base

module Defs = struct
  let a0 = 0.6768
  let a1 = -0.144
  let a2 = -0.47
  let a3 = 0.1

  let eps = 0.0001

  (* Function definition *)
  let f x = a0 +. a1 *. x +. a2 *. x *. x -. a3 *. x *. x *. x

  (* Fixed point iteration function *)
  let g x = x -. f x

  (* Applied function derivative *)
  (* let g' x = 1. -. a1 -. 2. *. a2 *. x +. 3. *. a3 *. x *. x *)
  let g' x = (* 0. * a0 + *) 1. +. a1 +. 2. *. a2 *. x -. 3. *. a3 *. x *. x
end

module Range = struct
  let initial = List.init
    10
    ~f:(fun x ->
      (x, Defs.f (Float.of_int x))
    ) 

  let _windows lst =
    let rec aux acc = function
      | a :: b :: rest -> aux ((a, b) :: acc) rest
      | _ -> acc
    in
      aux [] lst

  let _calc a b = (a +. b) /. 2.

  let _idx elem lst =
    let rec aux acc elem = function
      | [] -> raise (Invalid_argument "_idx")
      | h :: t -> if Float.(h = elem) then acc else aux (acc + 1) elem t
    in
      aux 0 elem lst

  let windowed = _windows initial

  let indexed = List.fold
    windowed
    ~init:[]
    ~f:(fun acc ((a', a), (b', b)) ->
      if Float.(a > 0. && b < 0.) then (a', b') :: acc
      else if Float.(a < 0. && b > 0.) then (b', a') :: acc
      else acc
    )

  let roots = List.map
    indexed
    ~f:(fun (a, b) -> _calc (Float.of_int a) (Float.of_int b))

  let convergence root =
    Float.((abs (Defs.g' root)) < 1.)

  let rec iteration x_n =
      let open Float in
      let x_next = Defs.g x_n in
      if abs (x_next -. x_n) < Defs.eps then 
          Some x_next
      else if not (convergence x_next) then 
          None
      else 
          iteration x_next
end

let () =
  let open Stdio in
  printf "initial values:\n";
  List.iter Range.initial ~f:(fun (idx, elem) -> printf "%i=%.4f " idx elem);
  printf "\nraw roots: ";
  List.iter Range.roots ~f:(fun root -> printf "%.4f " root);
  printf "\nthe convergence: %b" (List.for_all Range.roots ~f:Range.convergence);
  match Range.iteration (List.hd_exn Range.roots) with
  | Some root -> printf "\nfixed point root: %.4f\n" root
  | None -> printf "\nmethod did not converge\n"
