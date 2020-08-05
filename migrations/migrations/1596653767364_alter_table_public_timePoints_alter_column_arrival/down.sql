ALTER TABLE "public"."timePoints" ALTER COLUMN "arrival" TYPE time with time zone;
ALTER TABLE "public"."timePoints" ALTER COLUMN "arrival" DROP NOT NULL;
