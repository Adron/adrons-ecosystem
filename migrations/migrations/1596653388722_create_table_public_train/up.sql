CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."train"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "historical_start" date NOT NULL, "historical_end" date NOT NULL, "description" text NOT NULL, "notes" text NOT NULL, PRIMARY KEY ("id") , UNIQUE ("id"));
