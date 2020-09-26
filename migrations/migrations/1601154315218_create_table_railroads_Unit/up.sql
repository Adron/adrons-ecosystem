CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "railroads"."Unit"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "UnitTypeId" uuid NOT NULL, "name" text NOT NULL, "started" date, "age" integer, "mileage" integer, "load" json, "ladenWeight" integer, "unitWeight" integer, PRIMARY KEY ("id") , UNIQUE ("id"));
