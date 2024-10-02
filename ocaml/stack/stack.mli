(** [t] represents a [Stack] *)
type 'a t

(** [empty] returns a new empty [Stack].
    @return [Stack] with no elements. *)
val empty : 'a t

(** [push st elem] appends an [elem] to a [st].
    @param st [Stack] to be appended element in.
    @param elem An element to be appended to a [Stack].
    @return [Stack] with a new element on a top. *)
val push : 'a t -> 'a -> 'a t

(** [peek st] returns a last element in a [st].
    @param st [Stack] which we extract element from.
    @return Last element of the [Stack] if it was not iempty, otherwise [None]. *)
val peek : 'a t -> 'a option

(** [pop st] removes last element from a [st].
    @param st [Stack] which we remove last element from.
    @return New [Stack] without removed element if it was not empty, otherwise [None]. *)
val pop : 'a t -> 'a t option

(** [peek_n_pop st] removes last element from a [st] and returns it.
    @param st [Stack] which we remove last element from.
    @return Removed elements with a new [Stack] without removed element if it was not empty, otherwise [None]. *)
val peek_n_pop : 'a t -> ('a * 'a t) option
