CREATE TABLE "GlobalSurfaceSummaryOfTheDay" (
  "STN" varchar,
  "WBAN" varchar,
  "YEARMODA" varchar,
  "TEMP" float,
  "TEMPA" int,
  "DEWP" float,
  "DEWPA" int,
  "SLP" float,
  "SLPA" int,
  "STP" float,
  "STPA" int,
  "VISIB" float,
  "VISIBA" int,
  "WDSP" float,
  "WDSPA" int,
  "MXSPD" float,
  "GUST" float,
  "MAX" float,
  "MAXb" boolean,
  "MIN" float,
  "MINb" boolean,
  "PRCP" varchar,
  "SNDP" varchar,
  "FRSGTT" varchar
);

CREATE TABLE "Train" (
  "id" uuid PRIMARY KEY,
  "name" text,
  "historical_start" datetime,
  "historical_end" datetime,
  "description" text,
  "notes" text
);

CREATE TABLE "Railroad" (
  "id" uuid PRIMARY KEY,
  "name" text,
  "history" text,
  "description" text,
  "hqCity" text,
  "serviceArea" text,
  "mapLink" text
);

CREATE TABLE "Operator" (
  "trainId" uuid,
  "railroad" uuid,
  "details" text
);

CREATE TABLE "Consist" (
  "id" uuid PRIMARY KEY,
  "trainId" uuid,
  "details" text
);

CREATE TABLE "TrainSchedules" (
  "trainId" uuid,
  "scheduleId" uuid
);

CREATE TABLE "Schedule" (
  "id" uuid PRIMARY KEY,
  "name" text
);

ALTER TABLE "Operator" ADD FOREIGN KEY ("trainId") REFERENCES "Train" ("id");

ALTER TABLE "Operator" ADD FOREIGN KEY ("railroad") REFERENCES "Railroad" ("id");

ALTER TABLE "Consist" ADD FOREIGN KEY ("trainId") REFERENCES "Train" ("id");

ALTER TABLE "TrainSchedules" ADD FOREIGN KEY ("trainId") REFERENCES "Train" ("id");

ALTER TABLE "TrainSchedules" ADD FOREIGN KEY ("scheduleId") REFERENCES "Schedule" ("id");
