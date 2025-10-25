-- Custom types
create type public.hunting_ground_permission as enum ('hunting_ground.delete', 'hunting_ground.update', 'hunting_ground.create', 'hunting_ground.read', 'hunting_ground.manage_members');
create type public.hunting_ground_role as enum ('owner', 'co-owner', 'member');