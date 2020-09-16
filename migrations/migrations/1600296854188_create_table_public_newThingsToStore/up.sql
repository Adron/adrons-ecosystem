CREATE TABLE "public"."newThingsToStore"("id" uuid NOT NULL, "name" text NOT NULL, "details" text, "stamp" date, PRIMARY KEY ("id") , UNIQUE ("id"), UNIQUE ("name"));
