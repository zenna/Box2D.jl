using Box2D

# This is a simple example of building and running a simulation
# using Box2D. Here we create a large ground box and a small dynamic
# box.
# There are no graphics for this example. Box2D is meant to be used
# with your rendering engine in your game engine.
function main()
	# Define the gravity vector.
	gravity = Vec2(0.0f0, -10.0f0)

	# Construct a world object, which will hold and simulate the rigid bodies.
	world = World(gravity)

	# Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0.0f0, -10.0f0);

	# Call the body factory which allocates memory for the ground body
	# from a pool and creates the ground box shape (also from a pool).
	# The body is also added to the world.
	b2Body* groundBody = world.CreateBody(&groundBodyDef)

	# Define the ground box shape.
	b2PolygonShape groundBox;

	# The extents are the half-widths of the box.
	groundBox.SetAsBox(50.0f0, 10.0f0)

	# Add the ground fixture to the ground body.
	groundBody->CreateFixture(&groundBox, 0.0f0)

	# Define the dynamic body. We set its position and call the body factory.
	b2BodyDef bodyDef
	bodyDef.type = b2_dynamicBody
	bodyDef.position.Set(0.0f0, 4.0f0)
	b2Body* body = world.CreateBody(&bodyDef)

	# Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox
	dynamicBox.SetAsBox(1.0f, 1.0f)

	# Define the dynamic body fixture.
	b2FixtureDef fixtureDef
	fixtureDef.shape = &dynamicBox

	# Set the box density to be non-zero, so it will be dynamic.
	fixtureDef.density = 1.0f

	# Override the default friction.
	fixtureDef.friction = 0.3f

	# Add the shape to the body.
	body->CreateFixture(&fixtureDef)

	# Prepare for simulation. Typically we use a time step of 1/60 of a
	# second (60Hz) and 10 iterations. This provides a high quality simulation
	# in most game scenarios.
	float32 timeStep = 1.0f0 / 60.0f0
	int32 velocityIterations = 6
	int32 positionIterations = 2

	# This is our little game loop.
	for i = 0:60
		# Instruct the world to perform a single step of simulation.
		# It is generally best to keep the time step and iterations fixed.
		step!(world, timeStep, velocityIterations, positionIterations)

		# Now print the position and angle of the body.
		b2Vec2 position = body->GetPosition()
		float32 angle = body->GetAngle()

		printf("%4.2f %4.2f %4.2f\n", position.x, position.y, angle);
  end

	# When the world destructor is called, all bodies and joints are freed. This can
	# create orphaned pointers, so be careful about your world management.
end
