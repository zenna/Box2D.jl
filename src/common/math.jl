"Rotation"
struct Rot end
Rot(angle) = Rot(sin(angle), cos(angle))
identity(::Rot{T}) where T = Rot{zero(T), one(T)}

"angle in radians"
angle(r::Rot) = atan(r.s, r.c)
xaxis(r::Rot) = Vec2(r.c, r.s)
yaxis(r::Rot) = Vec2(-r.s, r.c)

"""
A transform contains translation and rotation. It is used to represent
the position and orientation of rigid frames.
"""
struct Transform{V <: Vec2, R <: Rot}
  p::V
  q::R
end

identity(::Transform{V, R}) where {V, R} = Transform(zero(V), identity(R))