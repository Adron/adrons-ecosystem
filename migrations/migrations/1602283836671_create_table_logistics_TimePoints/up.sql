CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."TimePoints"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "type" text, "description" text, "arrival" timestamptz, "departure" timestamptz, PRIMARY KEY ("id") , UNIQUE ("id"));
