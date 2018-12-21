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