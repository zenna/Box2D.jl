@enum ContactFeatureType e_vertex = 0 e_face = 1

"""
The features that intersect to form the contact point
This must be 4 bytes or less.
"""
struct ContactFeature
  indexA::UInt8
  indexB::UInt8
  typeA::UInt8
  typeB::UInt8
end

struct Key
  key::UInt32
end 

"Contact ids to facilitate warm starting."
const ContactID = Union{ContactFeature, Key}

"""
A manifold point is a contact point belonging to a contact
manifold. It holds details related to the geometry and dynamics
of the contact points.
The local point usage depends on the manifold type:
-e_circles: the local center of circleB
-e_faceA: the local center of cirlceB or the clip point of polygonB
-e_faceB: the clip point of polygonA
This structure is stored across time steps, so we keep it small.
Note: the impulses are used for internal caching and may not
provide reliable contact forces, especially for high speed collisions.
"""
struct ManifoldPoint{V <: Vec2, T <: Real, CID <: ContactID}
	localPoint::V		  # usage depends on manifold type
	normalImpulse::T;	# the non-penetration impulse
	tangentImpulse::T	# the friction impulse
	id::CID		       	# uniquely identifies a contact point between two shapes
end

@enum ManifoldType e_circles = 0 e_faceA = 1 e_faceB = 2

"""
A manifold for two touching convex shapes.
Box2D supports multiple types of contact:
- clip point versus plane with radius
- point versus point with radius (circles)
The local point usage depends on the manifold type:
-e_circles: the local center of circleA
-e_faceA: the center of faceA
-e_faceB: the center of faceB
Similarly the local normal usage:
-e_circles: not used
-e_faceA: the normal on polygonA
-e_faceB: the normal on polygonB
We store contacts in this way so that position correction can
account for movement, which is critical for continuous physics.
All contact scenarios must be expressed in one of these types.
This structure is stored across time steps, so we keep it small.
"""
struct Manifold{V2}
  points::Vector{ManifoldPoint} # max length is b2_maxManifoldPoints the points of contact
	localNormal::V2								# not use for Type::e_points
	localPoint::V2								# usage depends on manifold type
	type::ManifoldType
  pointCount::Int32		
end

"This is used to compute the current state of a contact manifold."
struct WorldManifold{V2 <: Vec2, V2s <: AbstractVector{V2}, F}
	normal::V2 				# world vector pointing from A to B
	points::V2s				# world contact point (point of intersection)
	separations::F 	  # a negative value indicates overlap, in meters
end

# zt: points and separations should have maxsixze [b2_maxManifoldPoints] 

"""
Evaluate the manifold with supplied transforms. This assumes
modest motion from the original state. This does not change the
point count, impulses, etc. The radii must come from the shapes
that generated the manifold.
"""
function initialize(manifold,
									  xfA::Transform, radiusA::F,
									  xfB::Transform, radiusB::F) where F <: Real
	if manifold.pointcount == 0
		return
	end

	if manifold.type == Manifold.circles
		normal = Vec2(1, 0)
		pointA = xfA * manifold.localPoint
		pointB = xfB * manifold.points[1].localPoint
		if normsquare(pointA, pointB) > eps(F) * eps(F)
			normal = normalize(pointB - pointA) # zt does distance change point
		end
		ca = pointA + radiusA * normal
		cb = pointB - radiusB * normal
		points[1] = 0.5 * cA + cB # zt F type
		separations[1] =  dot((cB - cA), normal)
		return WorldManifold(normal, points, separations)
	elseif manifold.type == e_faceA
		normal = xfA.q * manifold.localNormal
		planepoint = xfA * localPoint
		for i = i:manifold.pointCount
			clippoint = xfB * manifold.points[i].localPoint
			cA = clipPoint + (radiusA - dot(clippoint - planepoint, normal)) * normal
			cB = clippoint - radiusB * normal
			points[i] = T(0.5) * (cA + cB)
			seperations[i] = dot(cb - cA, normal)
			return WorldManifold(normal, points, separations)
		end
	elseif manifold.type == e_faceB
		normal = xfB.q * manifold.localNormal
		planePoint = xfB * manifold.localPoint
		for i = 1:manifold.pointCount
			clipPoint = xfA * manifold.points[i].localPoint
			cB = clipPoint + (radiusB - Dot(clipPoint - planePoint, normal)) * normal
			cA = clipPoint - radiusA * normal
			points[i] = T(0.5f) * (cA + cB);
			separations[i] = b2Dot(cA - cB, normal);
		end

		# Ensure normal points from A to B.
		normal = -normal
		WorldManifold(normal, points, separations)
	end
end


# This is used for determining the state of contact points.
@enum b2PointState begin
	nullState		# point does not exist
	addState		# point was added in the update
	persistState	# point persisted across the update
	removeState		# point was removed in the update
end

# Compute the point states given two manifolds. The states pertain to the transition from manifold1
# to manifold2. So state1 is either persist or remove while state2 is either add or persist.
void b2GetPointStates(b2PointState state1[b2_maxManifoldPoints], b2PointState state2[b2_maxManifoldPoints],
					  const b2Manifold* manifold1, const b2Manifold* manifold2);

"Used for computing contact manifolds."
struct ClipVertex{V2 <: Vec2, CID <: ContactID}
	v::V2
	id::CID
end

# Ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
struct RayCastInput{V2 <: Vec2, F}
	p1::V2
	p2::V2
	maxFraction::F
end

# Ray-cast output data. The ray hits at p1 + fraction * (p2 - p1), where p1 and p2
# come from b2RayCastInput.
struct RayCastOutput{V2, F}
	normal::V2
	fraction::F
end