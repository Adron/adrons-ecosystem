alter table "railroads"."Consist"
           add constraint "Consist_trainId_fkey"
           foreign key ("trainId")
           references "railroads"."Train"
           ("id") on update restrict on delete restrict;
