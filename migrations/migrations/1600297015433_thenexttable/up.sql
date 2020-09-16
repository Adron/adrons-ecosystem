create table trains
(
    id uuid default gen_random_uuid() not null,
    name text not null,
    origination text,
    destination text,
    details text
);

comment on table trains is 'This is a table that stores trains information.';

create unique index trains_id_uindex
	on trains (id);

create unique index trains_name_uindex
	on trains (name);

alter table trains
    add constraint trains_pk
        primary key (id);

