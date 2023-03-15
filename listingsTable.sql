-- Table: public.listings

CREATE TABLE IF NOT EXISTS public.listings
(
    "listingId" bigint NOT NULL,
    "listingName" text COLLATE pg_catalog."default" NOT NULL,
    "totalPrice" numeric NOT NULL,
    "itemPrice" numeric NOT NULL,
    "shippingPrice" numeric NOT NULL,
    "sellerScore" numeric NOT NULL,
    "sellerPercent" numeric NOT NULL,
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
    CONSTRAINT listings_pkey PRIMARY KEY ("listingId")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.listings
    OWNER to postgres;
