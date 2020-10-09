CREATE TABLE "logistics"."operator"("railroadId" uuid NOT NULL, "trainId" uuid NOT NULL, "details" text, PRIMARY KEY ("railroadId","trainId") , FOREIGN KEY ("railroadId") REFERENCES "logistics"."Railraod"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("trainId") REFERENCES "logistics"."trains"("id") ON UPDATE restrict ON DELETE restrict);