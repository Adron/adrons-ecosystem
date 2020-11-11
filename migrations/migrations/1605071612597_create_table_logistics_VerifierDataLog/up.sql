CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."VerifierDataLog"("Id" uuid NOT NULL DEFAULT gen_random_uuid(), "Details" text NOT NULL, "Stamp" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("Id") , UNIQUE ("Id"));
