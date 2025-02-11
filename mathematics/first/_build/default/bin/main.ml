open Base

let a0 = 0.6768
let a1 = -0.144
let a2 = -0.47
let a3 = 0.1
(* let eps = 0.0001 *)

(* F(x) = 0.6788 - 0.144x - 0.47x^2 + 0.1x^3 = 0 *)
let f x a0 a1 a2 a3 =
  a0 +. (a1 *. x) +. (a2 *. (x **. 2.)) +. (a3 *. (x **. 3.))

let (--) i j = 
  let rec aux n acc =
    if n < i then acc else aux (n - 1) (n :: acc)
  in
    aux j []

let values =
  (-5--4)
    |> List.map ~f:(fun x -> (x, f (Float.of_int x) a0 a1 a2 a3))

let windows lst =
  let rec aux acc lst =
    match lst with
      | a :: (b :: _ as rest) -> aux ((a, b) :: acc) rest
      | _ -> []
    in
      List.rev (aux [] lst)

let ranges =
  let root a b = Float.of_int (a + b) /. 2. in
  values
    |> windows
    |> List.fold ~init:[] ~f:(fun acc ((lidx, lval), (ridx, rval)) ->
        if Float.(lval > 0. && rval < 0.) then (root lidx ridx) :: acc
        else if Float.(rval > 0. && lval < 0.) then (root ridx lidx) :: acc
        else acc
    )

let () =
  let print_list lst =
    let stringified_list = List.map lst ~f:(fun x -> Printf.sprintf "%.5f" x) in
    Stdio.Out_channel.printf "[%s]\n" (String.concat ~sep:"; " stringified_list)
  in
    Stdio.Out_channel.printf "\n|";
    (-5--4)
      |> List.map ~f:Float.of_int
      |> List.iter ~f:(fun elem ->
        Stdio.Out_channel.printf " x = %i -> %f |" (Int.of_float elem) (f elem a0 a1 a2 a3)
      );
    Stdio.Out_channel.printf "\n";
    Stdio.Out_channel.printf "Determined roots are: ";
    print_list ranges
