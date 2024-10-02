type 'a t = 'a List.t

let empty = []

let push st elem = elem :: st

let peek = function
  | [] -> None
  | h :: _ -> Some h

let pop = function
  | [] -> None
  | _ :: t -> Some t

let peek_n_pop = function
  | [] -> None
  | h :: t -> Some (h, t)
