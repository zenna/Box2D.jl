# Global tuning constants based on meters-kilograms-seconds (MKS) units.
#

# Collision

# The maximum number of contact points between two convex shapes. Do
# not change this value.
const b2_maxManifoldPoints =	2

# The maximum number of vertices on a convex polygon. You cannot increase
# this too much because b2BlockAllocator has a maximum object size.
const b2_maxPolygonVertices =	8

# This is used to fatten AABBs in the dynamic tree. This allows proxies
# to move by a small amount without triggering a tree adjustment.
# This is in meters.
const b2_aabbExtension =		0.1f0

# This is used to fatten AABBs in the dynamic tree. This is used to predict
# the future position based on the current displacement.
# This is a dimensionless multiplier.
const b2_aabbMultiplier =		2.0f0

# A small length used as a collision and constraint tolerance. Usually it is
# chosen to be numerically significant, but visually insignificant.
const b2_linearSlop =			0.005f0

# A small angle used as a collision and constraint tolerance. Usually it is
# chosen to be numerically significant, but visually insignificant.
const b2_angularSlop =			(2.0f0 / 180.0f0 * π)

# The radius of the polygon/edge shape skin. This should not be modified. Making
# this smaller means polygons will have an insufficient buffer for continuous collision.
# Making it larger may create artifacts for vertex collision.
const b2_polygonRadius =		(2.0f0 * b2_linearSlop)

# Maximum number of sub-steps per contact in continuous physics simulation.
const b2_maxSubSteps =			8


# Dynamics

# Maximum number of contacts to be handled to solve a TOI impact.
const b2_maxTOIContacts =			32

# A velocity threshold for elastic collisions. Any collision with a relative linear
# velocity below this threshold will be treated as inelastic.
const b2_velocityThreshold =		1.0f0

# The maximum linear position correction used when solving constraints. This helps to
# prevent overshoot.
const b2_maxLinearCorrection =		0.2f0

# The maximum angular position correction used when solving constraints. This helps to
# prevent overshoot.
const b2_maxAngularCorrection =		(8.0f0 / 180.0f0 * π)

# The maximum linear velocity of a body. This limit is very large and is used
# to prevent numerical problems. You shouldn't need to adjust this.
const b2_maxTranslation =			2.0f0
const b2_maxTranslationSquared =	(b2_maxTranslation * b2_maxTranslation)

# The maximum angular velocity of a body. This limit is very large and is used
# to prevent numerical problems. You shouldn't need to adjust this.
const b2_maxRotation =				(0.5f0 * π)
const b2_maxRotationSquared =		(b2_maxRotation * b2_maxRotation)

# This scale factor controls how fast overlap is resolved. Ideally this would be 1 so
# that overlap is removed in one time step. However using values close to 1 often lead
# to overshoot.
const b2_baumgarte =				0.2f0
const b2_toiBaugarte =				0.75f0


# Sleep

# The time that a body must be still before it will go to sleep.
const b2_timeToSleep =				0.5f0

# A body cannot sleep if its linear velocity is above this tolerance.
const b2_linearSleepTolerance =		0.01f0

# A body cannot sleep if its angular velocity is above this tolerance.
const b2_angularSleepTolerance =	(2.0f0 / 180.0f0 * π)

# # Memory Allocation

# # Implement this function to use your own memory allocator.
# void* b2Alloc(int32 size);

# # If you implement b2Alloc, you should also implement this function.
# void b2Free(void* mem);

# # Logging function.
# void b2Log(const char* string, ...);