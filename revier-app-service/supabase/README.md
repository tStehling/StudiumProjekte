# Revier App Supabase Schema

This directory contains the database schema for the Revier App, implemented using Supabase.

## Database Structure

The database is designed to manage hunting grounds, animals, sightings, and related data for a hunting management application. The main entities in the database are:

- **Hunting Grounds**: Areas where hunting activities take place
- **Animals**: Wildlife tracked within hunting grounds
- **Species**: Types of animals (deer, boar, etc.)
- **Sightings**: Observations of animals in the field
- **Shooting**: Records of hunting activities
- **Weather Conditions**: Environmental data during sightings
- **Users**: People who use the application
- **Media**: Photos and videos related to sightings and shootings

## Migration Files

The schema is defined in a single migration file that contains all the necessary database objects:

`20240304_complete_schema.sql`: This file includes:
1. Table definitions and relationships
2. Functions and triggers for automatic timestamp updates and soft deletes
3. Row Level Security policies to control data access
4. Indexes to optimize query performance

## Seed Data

The `seed.sql` file contains initial data to populate the database with:

- Countries and federal states
- Animal species
- Hunting seasons
- Tags for animal categorization
- Calibers for weapons
- Allowed calibers for different species and regions

## Row Level Security

The database uses Supabase's Row Level Security (RLS) to ensure that users can only access data they are authorized to see:

- Users can only view hunting grounds they are members of
- Only admin users can update hunting ground information
- Users can only manage animals in their hunting grounds
- Users can only view and manage their own weapons and shootings

## How to Apply Migrations

To apply these migrations to your Supabase project:

1. Make sure you have the Supabase CLI installed
2. Run `supabase start` to start the local Supabase instance
3. The migration will be automatically applied

For a production environment:

1. Connect to your Supabase project: `supabase link --project-ref your-project-ref`
2. Apply the migration: `supabase db push`

## Database Diagram

For a visual representation of the database schema, you can use tools like [dbdiagram.io](https://dbdiagram.io) or [Supabase's built-in database viewer](https://app.supabase.io/project/your-project-ref/database/tables).

## Development Guidelines

When making changes to the database schema:

1. For small changes, create a new migration file with the date prefix (YYYYMMDD_description.sql)
2. For larger changes, consider updating the complete schema file and resetting the database
3. Test the migration locally before applying it to production
4. Update this README if you add new entities or significantly change the schema
5. Consider the impact on existing data and provide migration paths if necessary 