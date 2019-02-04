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
	type::Type # zt: What is this 
  pointCount::Int32 ;		
end

"This is used to compute the current state of a contact manifold."
struct WorldManifold

	void Initialize(const b2Manifold* manifold,
					const b2Transform& xfA, float32 radiusA,
					const b2Transform& xfB, float32 radiusB);

	b2Vec2 normal;								///< world vector pointing from A to B
	b2Vec2 points[b2_maxManifoldPoints];		///< world contact point (point of intersection)
	float32 separations[b2_maxManifoldPoints];	///< a negative value indicates overlap, in meters
end

"""
/// Evaluate the manifold with supplied transforms. This assumes
/// modest motion from the original state. This does not change the
/// point count, impulses, etc. The radii must come from the shapes
/// that generated the manifold.
"""
initialize()
  b2Vec2 normal;								///< world vector pointing from A to B
  b2Vec2 points[b2_maxManifoldPoints];		///< world contact point (point of intersection)
  float32 separations[b2_maxManifoldPoints];	///< a negative value indicates overlap, in meters
end 

/// This is used for determining the state of contact points.
enum b2PointState
{
	b2_nullState,		///< point does not exist
	b2_addState,		///< point was added in the update
	b2_persistState,	///< point persisted across the update
	b2_removeState		///< point was removed in the update
};

/// Compute the point states given two manifolds. The states pertain to the transition from manifold1
/// to manifold2. So state1 is either persist or remove while state2 is either add or persist.
void b2GetPointStates(b2PointState state1[b2_maxManifoldPoints], b2PointState state2[b2_maxManifoldPoints],
					  const b2Manifold* manifold1, const b2Manifold* manifold2);

/// Used for computing contact manifolds.
struct b2ClipVertex
{
	b2Vec2 v;
	b2ContactID id;
};

/// Ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
struct b2RayCastInput
{
	b2Vec2 p1, p2;
	float32 maxFraction;
};

/// Ray-cast output data. The ray hits at p1 + fraction * (p2 - p1), where p1 and p2
/// come from b2RayCastInput.
struct b2RayCastOutput
{
	b2Vec2 normal;
	float32 fraction;
};