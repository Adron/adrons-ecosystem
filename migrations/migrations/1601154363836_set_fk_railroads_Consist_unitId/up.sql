alter table "railroads"."Consist"
           add constraint "Consist_unitId_fkey"
           foreign key ("unitId")
           references "railroads"."Unit"
           ("id") on update restrict on delete restrict;
