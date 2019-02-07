childcount(::Circle) = 1

function testpoint(c::Circle, transform, p)
  center = transform.p + transform.q * c.center
	d = p - center
	dot(d, d) <= c.r * c.r
end

# function raycast(c::Circle, ) end

function AABB(c::Circle, aabb, transform, childindex)
	p = transform.p + transform.q * c.center
	lb = p.x - c.r, p.y - c.r
  ub = p.x + c.r, p.y + c.r
  AABB(lb, ub)
end

function computemass(c::Circle, ::MassData, density)
	mass = density * π * c.r * c.r
	center = c.center

	# inertia about the local origin
  I = mass * (0.5 * c.r * c.r + dot(c.center, c.center))
  MassData(mass, center, I)
end

Base.zero(::Type{Circle}, ::Type{T} = Float32, ::Type{P} = Point2f0) where {T, P} =
  Circle(zero(T), zero(P))
