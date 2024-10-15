module type Map = sig
  (** [('k, 'v) t] is the type of maps that bind keys of type
      ['k] to values of type ['v]. *)
  type ('k, 'v) t

  (** [insert k v m] is the same map as [m], but with an additional
      binding from [k] to [v].  If [k] was already bound in [m],
      that binding is replaced by the binding to [v] in the new map. *)
  val insert : 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t

  (** [find k m] is [Some v] if [k] is bound to [v] in [m],
      and [None] if not. *)
  val find : 'k -> ('k, 'v) t -> 'v option

  (** [remove k m] is the same map as [m], but without any binding of [k].
      If [k] was not bound in [m], then the map is unchanged. *)
  val remove : 'k -> ('k, 'v) t -> ('k, 'v) t

  (** [empty] is the empty map. *)
  val empty : ('k, 'v) t

  (** [of_list lst] is a map containing the same bindings as
      association list [lst].
      Requires: [lst] does not contain any duplicate keys. *)
  val of_list : ('k * 'v) list -> ('k, 'v) t

  (** [bindings m] is an association list containing the same
      bindings as [m]. There are no duplicates in the list. *)
  val bindings : ('k, 'v) t -> ('k * 'v) list
end

module AssocListMap: Map = struct
  type ('k, 'v) t = ('k * 'v) list

  let insert k v m = (k, v) :: m

  let rec find k = function
    | [] -> None
    | (k', v) :: rest -> if k' = k then Some v else find k rest

  let rec remove_aux acc k = function
    | [] -> acc
    | ((k', v) :: rest) as old -> if k' = k then remove_aux k rest else remove_aux old k rest

  let remove k m = remove_aux empty k m

  let empty = []

  let rec of_list_aux acc = function
    | [] -> acc
    | kv :: rest -> of_list_aux (kv :: acc) rest

  let of_list assoc = of_list_aux empty assoc

  let rec bindings_aux acc = function
    | [] -> acc
    | kv :: rest -> bindings_aux (kv :: acc) rest

  let bindings m = bindings_aux (empty) m
end
