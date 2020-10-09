CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "logistics"."Consist"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "trainId" uuid NOT NULL, "details" text, PRIMARY KEY ("id") , FOREIGN KEY ("trainId") REFERENCES "logistics"."trains"("id") ON UPDATE restrict ON DELETE restrict, UNIQUE ("id"));
