CREATE TABLE "transaction" (
  "transaction_id" integer PRIMARY KEY,
  "customer_id" integer,
  "product_cat_id" integer,
  "transaction_date" date,
  "online_order" varchar,
  "order_status" varchar,
  "list_price" decimal,
  "standard_cost" decimal
);

CREATE TABLE "product" (
  "product_cat_id" integer PRIMARY KEY,
  "product_id" integer,
  "brand" varchar,
  "product_line" varchar,
  "product_class" varchar,
  "product_size" varchar
);

CREATE TABLE "customer" (
  "customer_id" integer PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "gender" varchar,
  "DOB" date,
  "job_title" varchar,
  "job_industry_category" varchar,
  "wealth_segment" varchar,
  "deceased_indicator" varchar,
  "owns_car" varchar,
  "address" varchar,
  "postcode" integer,
  "property_valuation" integer
);

CREATE TABLE "postcodes" (
  "postcode" integer PRIMARY KEY,
  "state" varchar,
  "country" varchar
);

ALTER TABLE "transaction" ADD FOREIGN KEY ("product_cat_id") REFERENCES "product" ("product_cat_id");

ALTER TABLE "transaction" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("customer_id");

ALTER TABLE "customer" ADD FOREIGN KEY ("postcode") REFERENCES "postcodes" ("postcode");
