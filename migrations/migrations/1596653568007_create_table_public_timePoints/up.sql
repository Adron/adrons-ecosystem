CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."timePoints"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "type" text NOT NULL, "description" text NOT NULL, "arrival" timetz NOT NULL, "departure" timetz NOT NULL, PRIMARY KEY ("id") , UNIQUE ("id"));
