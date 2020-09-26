CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "railroads"."Train"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "historical_start" date, "historical_end" date, "description" text, "notes" text, PRIMARY KEY ("id") , UNIQUE ("id"), UNIQUE ("name"));
