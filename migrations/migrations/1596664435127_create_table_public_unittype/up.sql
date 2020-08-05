CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."unittype"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "description" text, "unitLoadType" json NOT NULL, PRIMARY KEY ("id") , UNIQUE ("id"), UNIQUE ("name"));
