drop table if exists registry;
create table registry (
  vin text primary key,
  model_year text not null,
  paint_code text not null,     -- references paint_codes(paint_code)
  interior_code text not null,  -- references interior_code(interior_code)
  trim_code text not null,      -- references trim_codes(trim_code)
  body_style integer not null,  -- references body_styles(body_style_id)
  roof_color integer,           -- references roof_colors(roof_color_id)
  location text,
  notes text,
  owner text
);

drop table if exists paint_codes;
create table paint_codes (
  paint_code text primary key,
  paint_color text not null unique,
  exclusive boolean
);
insert into paint_codes values
  ("C2C2","Avus Silver",    0),
  ("6Y6Y","Daytona Gray",   0),
  ("1T1T","Imola Yellow",   0),
  ("N9N9","Misano Red",     0),
  ("5W5W","Mugello Blue",   0),
  ("L8L8","Phantom Black",  0),
  ("5N5N","Sprint Blue",    0),
  ("T9T9","Ibis White",     0),
  ("B5B5","Artic White",    1),
  ("M1M1","Suzuka Gray",    1),
  ("1R1R","Lava Gray",      1),
  ("X3X3","Papaya Orange",  1),
  ("3F3F","Glut Orange",    1),
  ("5B5B","Light Silver",   1),
  ("5Q5Q","Condor Gray",    1);

drop table if exists interior_codes;
create table interior_codes (
  interior_code text primary key,
  interior_color text not null unique,
  exclusive boolean
);
insert into interior_codes values
  ("QH",  "Black",                    0),
  ("QJ",  "Silver",                   0),
  ("PYP", "Audi Exclusive",           1),
  ("EXC", "Audi Exclusive (custom)",  1);

drop table if exists trim_codes;
create table trim_codes (
  trim_code text primary key,
  trim text not null unique,
  exclusive boolean
);
insert into trim_codes values
  ("STD","Carbon Fiber",        0),
  ("5TG","Aluminum",            0),
  ("5MR","Myrtle Nutmeg Wood",  0),
  ("5TL","Piano Black",         0),
  ("EXC","Exclusive",           1);

drop table if exists body_styles;
create table body_styles (
  body_style_id integer primary key,
  body_style text not null unique
);
insert into body_styles values
  (1, "Sedan"),
  (2, "Cabriolet");

drop table if exists roof_colors;
create table roof_colors (
  roof_color_id integer primary key,
  roof_color text not null unique
);
insert into roof_colors values
  (1, "Black"),
  (2, "Red");

drop table if exists packages;
create table packages (
  package text primary key,
  description text not null unique
);
insert into packages values
  ("STD","No Premium Package"),
  ("WSR","Sirius Radio (PP-S)"),
  ("WXM","XM Radio (PP-X)"),
  ("WIP","CD changer (PP-CD)"),
  ("WPX","iPod (PP-iPod)"),
  ("UF1","iPod Glove Box Interface"),
  ("W??","Unknown"),
  ("W--","Neither"),
  ("3FA","Sunroof delete"),
  ("4X4","Rear Side Airbags"),
  ("PQE","Titanium package"),
  ("CAB","Standard cabriolet");

drop table if exists car_packages;
create table car_packages (
  vin text not null,      -- references car(vin)
  package text not null,  -- references packages(package)
  unique(vin, package)
);
