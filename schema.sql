drop schema if exists app_public cascade;

create schema app_public;
set search_path to app_public, public;

create table users (
  id serial primary key,
  username text not null check (lower(username) = username) unique
);

insert into users (username) values
  ('alice'),
  ('bob'),
  ('caroline'),
  ('dave'),
  ('ellie'),
  ('fergus');