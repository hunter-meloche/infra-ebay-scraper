-- Table: public.listings

CREATE TABLE IF NOT EXISTS public.listings
(
    "itemId" bigint NOT NULL,
    "listingName" text COLLATE pg_catalog."default" NOT NULL,
    price numeric NOT NULL,
    link text COLLATE pg_catalog."default" NOT NULL,
    keywords text COLLATE pg_catalog."default" NOT NULL,
    "buyItNow" boolean,
    "priceMin" numeric,
    "priceMax" numeric,
    "itemCondition" text COLLATE pg_catalog."default",
    "extraFilters" text COLLATE pg_catalog."default",
    "dateTime" timestamp with time zone NOT NULL,
    ignore boolean DEFAULT false,
    "ignoreReason" text COLLATE pg_catalog."default",
    CONSTRAINT listings_pkey PRIMARY KEY ("itemId")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.listings
    OWNER to postgres;
