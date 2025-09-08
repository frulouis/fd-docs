-- This script completely removes the 'ordersdb' database and all objects within it.
-- The CASCADE keyword ensures that all tables, views, stages, and other objects
-- inside the database are dropped before the database itself is dropped.
-- This is a destructive operation and should be used with caution.
DROP DATABASE IF EXISTS ordersdb CASCADE; 