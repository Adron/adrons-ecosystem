CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."schedule"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "timePointId" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("timePointId") REFERENCES "public"."timePoints"("id") ON UPDATE restrict ON DELETE restrict, UNIQUE ("id"), UNIQUE ("name"));
