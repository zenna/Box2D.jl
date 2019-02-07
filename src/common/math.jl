GeometryTypes.@fixed_vector Rot StaticVector

# struct Rot end
Rot(angle) = Rot(sin(angle), cos(angle))
id(::Rot{T}) where T = Rot(zero(T), one(T))
id(::Type{Rot{N, T}}) where {N, T} = Rot(zero(T), one(T))

"angle in radians"
angle(r::Rot) = atan(r[1], r[2])
xaxis(r::Rot) = Vec2(r[2], r[1])
yaxis(r::Rot) = Vec2(-r[1], r[2])

"""
A transform contains translation and rotation. It is used to represent
the position and orientation of rigid frames.
"""
struct Transform{V <: Vec2, R <: Rot}
  p::V
  q::R
end

id(::Transform{V, R}) where {V, R} = Transform(zero(V), id(R))
id(::Type{Transform{V, R}}) where {V, R} = Transform(zero(V), id(R))