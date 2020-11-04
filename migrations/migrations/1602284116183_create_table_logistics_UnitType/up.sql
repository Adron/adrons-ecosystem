CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."UnitType"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "description" text NOT NULL, "unitLoadType" jsonb, PRIMARY KEY ("id") , UNIQUE ("id"));
