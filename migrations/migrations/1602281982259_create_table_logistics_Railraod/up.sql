CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."Railraod"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "history" text, "hqCity" text, "serviceArea" text, "mapLink" text, PRIMARY KEY ("id") , UNIQUE ("id"), UNIQUE ("name"));
