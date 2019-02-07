"Julia Port of Box2D"
module Box2D
using GeometryTypes: Circle, Point, Vec, Vec2, HyperRectangle, Point2f0, Vec2f0
import GeometryTypes
using DocStringExtensions
using LinearAlgebra
using StaticArrays

include("common/settings.jl")
include("common/math.jl")

include("shapes/Shape.jl")


# include("collision/collision.jl")
# include("collision/dynamictree.jl")


end # module
