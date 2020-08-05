ALTER TABLE "public"."timePoints" ALTER COLUMN "arrival" TYPE timetz;
ALTER TABLE "public"."timePoints" ALTER COLUMN "arrival" DROP NOT NULL;
