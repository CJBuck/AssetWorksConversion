--
TRUNCATE TABLE TransformComponent
TRUNCATE TABLE TransformComponentLegacyXwalk

EXEC spTransformComponent

SELECT * FROM TransformComponent
SELECT * FROM TransformComponentLegacyXwalk
