CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."unit"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "unitTypeId" uuid NOT NULL, "name" text NOT NULL, "started" date NOT NULL, "age" integer NOT NULL, "mileage" integer NOT NULL, "load" json NOT NULL, "ladenWeight" integer NOT NULL, "unitWeight" integer NOT NULL, PRIMARY KEY ("id") );
