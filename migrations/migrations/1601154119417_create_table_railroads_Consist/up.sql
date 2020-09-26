CREATE TABLE "railroads"."Consist"("trainId" uuid NOT NULL, "unitId" uuid NOT NULL, "details" text NOT NULL, PRIMARY KEY ("trainId","unitId") );
