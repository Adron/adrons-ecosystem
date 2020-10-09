CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."Unit"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "unitId" uuid NOT NULL, "name" text NOT NULL DEFAULT 'unit X', "started" date NOT NULL DEFAULT now(), "mileage" integer NOT NULL DEFAULT 0, "load" jsonb, "ladenWeight" integer NOT NULL DEFAULT 0, "unitWeight" integer NOT NULL DEFAULT 0, PRIMARY KEY ("id") , UNIQUE ("id"));
