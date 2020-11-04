CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."trains"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, PRIMARY KEY ("id") , UNIQUE ("id"), UNIQUE ("name"));
