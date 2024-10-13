module type GeometryObject = sig
  type t

  val create : bool -> t

  val area : t -> float

  val perimeter : t -> float
end

module Circle: GeometryObject = struct
  type t = { mutable radius : float }

  let create = function
    | _ -> { radius = 0. }

  let area self = self.radius ** 2. *. Float.pi

  let perimeter self = 2. *. Float.pi *. self.radius
end

module Quadrangle: GeometryObject = struct
  type t =
    | Square of { mutable diag: float }
    | Rectangle of { mutable vdiag: float; mutable hdiag: float }

  let create = function
    | true -> Square { diag = 0. }
    | false -> Rectangle { vdiag = 0.; hdiag = 0. }

  let area = function
    | Square { diag } -> diag ** 2.
    | Rectangle { vdiag; hdiag } -> vdiag *. hdiag

  let perimeter = function
    | Square { diag } -> diag *. 4.
    | Rectangle { vdiag; hdiag } -> 2. *. (vdiag +. hdiag)
end
