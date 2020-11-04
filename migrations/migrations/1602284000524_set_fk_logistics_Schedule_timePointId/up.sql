alter table "logistics"."Schedule"
           add constraint "Schedule_timePointId_fkey"
           foreign key ("timePointId")
           references "logistics"."TimePoint"
           ("id") on update restrict on delete restrict;
