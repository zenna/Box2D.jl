"Mass data computed for a shape."
struct b2MassData{M <: Real, C <: Vec2, I <: Real}
  mass::M    # The mass of the shape, usually in kilograms.
  center::C  # The position of the shape's centroid relative to the shape's origin.
  I::I       # The rotational inertia of the shape about the local origin.
end

"Get the number of child primitives."
function childcount end

"""
Test a point `p` for containment in this shape. This only works for convex shapes.
@param `xf` the shape world transform.
@param `p` a point in world coordinates.
"""
function testpoint end


"""
Cast a ray against a child shape.
@param output the ray-cast results.
@param input the ray-cast input parameters.
@param transform the transform to be applied to the shape.
@param childIndex the child shape index
"""
function raycast end

"""
Given a transform, compute the associated axis aligned bounding box for a child shape.
@param aabb returns the axis aligned box.
@param xf the world transform of the shape.
@param childIndex the child shape
"""
function computeAABB end

"""
Compute the mass properties of this shape using its dimensions and density.
The inertia tensor is computed about the local origin.
@param massData returns the mass data for this shape.
@param density the density in kilograms per meter squared.
"""
function computemass end

"""
Radius of a shape. For polygonal shapes this must be b2_polygonRadius. There is no support for
making rounded polygons.
"""
function m_radius end