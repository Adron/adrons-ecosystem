CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "newSchemaStuff"."newTableWhatever"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "Stamper" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") , UNIQUE ("id"));
