"Julia Port of Box2D"
module Box2D
using GeometryTypes: Circle, Point, Vec, Vec2, HyperRectangle, Point2f0, Vec2f0
using DocStringExtensions
using LinearAlgebra

include("common/b2settings.jl")
include("shapes/b2Shape.jl")


include("collision/collision.jl")
include("collision/dynamictree.jl")


end # module
