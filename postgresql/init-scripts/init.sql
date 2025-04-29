--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
-- SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.users_useractivity DROP CONSTRAINT IF EXISTS users_useractivity_user_id_83265632_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.users_profile DROP CONSTRAINT IF EXISTS users_profile_user_id_2112e78d_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialaccount DROP CONSTRAINT IF EXISTS socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialapp_sites DROP CONSTRAINT IF EXISTS socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialapp_sites DROP CONSTRAINT IF EXISTS socialaccount_social_site_id_2579dee5_fk_django_si;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialtoken DROP CONSTRAINT IF EXISTS socialaccount_social_app_id_636a42d7_fk_socialacc;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialtoken DROP CONSTRAINT IF EXISTS socialaccount_social_account_id_951f210e_fk_socialacc;
ALTER TABLE IF EXISTS ONLY public."Articles_tags" DROP CONSTRAINT IF EXISTS news_article_tags_tag_id_8c2bd5d5_fk_news_tag_id;
ALTER TABLE IF EXISTS ONLY public."Articles_tags" DROP CONSTRAINT IF EXISTS news_article_tags_article_id_6c2f9e1e_fk_news_article_id;
ALTER TABLE IF EXISTS ONLY public."Articles" DROP CONSTRAINT IF EXISTS news_article_category_id_7ede7614_fk_news_category_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.article_tag DROP CONSTRAINT IF EXISTS article_tag_tag_id_fkey;
ALTER TABLE IF EXISTS ONLY public.article_tag DROP CONSTRAINT IF EXISTS article_tag_article_id_fkey;
ALTER TABLE IF EXISTS ONLY public.article DROP CONSTRAINT IF EXISTS article_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.account_emailconfirmation DROP CONSTRAINT IF EXISTS account_emailconfirm_email_address_id_5b7f8c58_fk_account_e;
ALTER TABLE IF EXISTS ONLY public.account_emailaddress DROP CONSTRAINT IF EXISTS account_emailaddress_user_id_2c513194_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public."Likes" DROP CONSTRAINT IF EXISTS "Likes_user_id_a13ef4c7_fk_auth_user_id";
ALTER TABLE IF EXISTS ONLY public."Likes" DROP CONSTRAINT IF EXISTS "Likes_article_id_5f17686e_fk_Articles_id";
ALTER TABLE IF EXISTS ONLY public."Favorites" DROP CONSTRAINT IF EXISTS "Favorites_user_id_0e4c994c_fk_auth_user_id";
ALTER TABLE IF EXISTS ONLY public."Favorites" DROP CONSTRAINT IF EXISTS "Favorites_article_id_4369c90a_fk_Articles_id";
ALTER TABLE IF EXISTS ONLY public."Comments" DROP CONSTRAINT IF EXISTS "Comments_user_id_ed7fb3fe_fk_auth_user_id";
ALTER TABLE IF EXISTS ONLY public."Comments" DROP CONSTRAINT IF EXISTS "Comments_parent_id_5710fb4d_fk_Comments_id";
ALTER TABLE IF EXISTS ONLY public."Comments" DROP CONSTRAINT IF EXISTS "Comments_article_id_75f4e820_fk_Articles_id";
ALTER TABLE IF EXISTS ONLY public."CommentLikes" DROP CONSTRAINT IF EXISTS "CommentLikes_user_id_356c9fba_fk_auth_user_id";
ALTER TABLE IF EXISTS ONLY public."CommentLikes" DROP CONSTRAINT IF EXISTS "CommentLikes_comment_id_7ec9e1de_fk_Comments_id";
ALTER TABLE IF EXISTS ONLY public."Articles" DROP CONSTRAINT IF EXISTS "Articles_author_id_391eefb7_fk_auth_user_id";
DROP TRIGGER IF EXISTS trigger_update_slug ON public.article;
DROP INDEX IF EXISTS public.users_useractivity_user_id_83265632;
DROP INDEX IF EXISTS public.unique_verified_email;
DROP INDEX IF EXISTS public.unique_primary_email;
DROP INDEX IF EXISTS public.socialaccount_socialtoken_app_id_636a42d7;
DROP INDEX IF EXISTS public.socialaccount_socialtoken_account_id_951f210e;
DROP INDEX IF EXISTS public.socialaccount_socialapp_sites_socialapp_id_97fb6e7d;
DROP INDEX IF EXISTS public.socialaccount_socialapp_sites_site_id_2579dee5;
DROP INDEX IF EXISTS public.socialaccount_socialaccount_user_id_8146e70c;
DROP INDEX IF EXISTS public.news_tag_name_8821d338_like;
DROP INDEX IF EXISTS public.news_article_tags_tag_id_8c2bd5d5;
DROP INDEX IF EXISTS public.news_article_tags_article_id_6c2f9e1e;
DROP INDEX IF EXISTS public.news_article_slug_5328fdc5_like;
DROP INDEX IF EXISTS public.news_article_category_id_7ede7614;
DROP INDEX IF EXISTS public.idx_article_title;
DROP INDEX IF EXISTS public.idx_article_slug;
DROP INDEX IF EXISTS public.django_site_domain_a2e37b91_like;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
DROP INDEX IF EXISTS public.account_emailconfirmation_key_f43612bd_like;
DROP INDEX IF EXISTS public.account_emailconfirmation_email_address_id_5b7f8c58;
DROP INDEX IF EXISTS public.account_emailaddress_user_id_2c513194;
DROP INDEX IF EXISTS public.account_emailaddress_email_03be32b2_like;
DROP INDEX IF EXISTS public.account_emailaddress_email_03be32b2;
DROP INDEX IF EXISTS public."Likes_user_id_a13ef4c7";
DROP INDEX IF EXISTS public."Likes_article_id_5f17686e";
DROP INDEX IF EXISTS public."Favorites_user_id_0e4c994c";
DROP INDEX IF EXISTS public."Favorites_article_id_4369c90a";
DROP INDEX IF EXISTS public."Comments_user_id_ed7fb3fe";
DROP INDEX IF EXISTS public."Comments_parent_id_5710fb4d";
DROP INDEX IF EXISTS public."Comments_article_id_75f4e820";
DROP INDEX IF EXISTS public."CommentLikes_user_id_356c9fba";
DROP INDEX IF EXISTS public."CommentLikes_comment_id_7ec9e1de";
DROP INDEX IF EXISTS public."Articles_author_id_391eefb7";
ALTER TABLE IF EXISTS ONLY public.users_useractivity DROP CONSTRAINT IF EXISTS users_useractivity_pkey;
ALTER TABLE IF EXISTS ONLY public.users_profile DROP CONSTRAINT IF EXISTS users_profile_user_id_key;
ALTER TABLE IF EXISTS ONLY public.users_profile DROP CONSTRAINT IF EXISTS users_profile_pkey;
ALTER TABLE IF EXISTS ONLY public.tag DROP CONSTRAINT IF EXISTS tag_pkey;
ALTER TABLE IF EXISTS ONLY public.tag DROP CONSTRAINT IF EXISTS tag_name_key;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialtoken DROP CONSTRAINT IF EXISTS socialaccount_socialtoken_pkey;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialtoken DROP CONSTRAINT IF EXISTS socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialapp_sites DROP CONSTRAINT IF EXISTS socialaccount_socialapp_sites_pkey;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialapp DROP CONSTRAINT IF EXISTS socialaccount_socialapp_pkey;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialapp_sites DROP CONSTRAINT IF EXISTS socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialaccount DROP CONSTRAINT IF EXISTS socialaccount_socialaccount_provider_uid_fc810c6e_uniq;
ALTER TABLE IF EXISTS ONLY public.socialaccount_socialaccount DROP CONSTRAINT IF EXISTS socialaccount_socialaccount_pkey;
ALTER TABLE IF EXISTS ONLY public."Tags" DROP CONSTRAINT IF EXISTS news_tag_pkey;
ALTER TABLE IF EXISTS ONLY public."Tags" DROP CONSTRAINT IF EXISTS news_tag_name_key;
ALTER TABLE IF EXISTS ONLY public."Categories" DROP CONSTRAINT IF EXISTS news_category_pkey;
ALTER TABLE IF EXISTS ONLY public."Articles_tags" DROP CONSTRAINT IF EXISTS news_article_tags_pkey;
ALTER TABLE IF EXISTS ONLY public."Articles_tags" DROP CONSTRAINT IF EXISTS news_article_tags_article_id_tag_id_e8bdf741_uniq;
ALTER TABLE IF EXISTS ONLY public."Articles" DROP CONSTRAINT IF EXISTS news_article_slug_key;
ALTER TABLE IF EXISTS ONLY public."Articles" DROP CONSTRAINT IF EXISTS news_article_pkey;
ALTER TABLE IF EXISTS ONLY public.django_site DROP CONSTRAINT IF EXISTS django_site_pkey;
ALTER TABLE IF EXISTS ONLY public.django_site DROP CONSTRAINT IF EXISTS django_site_domain_a2e37b91_uniq;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.category DROP CONSTRAINT IF EXISTS category_pkey;
ALTER TABLE IF EXISTS ONLY public.category DROP CONSTRAINT IF EXISTS category_name_key;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
ALTER TABLE IF EXISTS ONLY public.article_tag DROP CONSTRAINT IF EXISTS article_tag_pkey;
ALTER TABLE IF EXISTS ONLY public.article DROP CONSTRAINT IF EXISTS article_slug_key;
ALTER TABLE IF EXISTS ONLY public.article DROP CONSTRAINT IF EXISTS article_pkey;
ALTER TABLE IF EXISTS ONLY public.account_emailconfirmation DROP CONSTRAINT IF EXISTS account_emailconfirmation_pkey;
ALTER TABLE IF EXISTS ONLY public.account_emailconfirmation DROP CONSTRAINT IF EXISTS account_emailconfirmation_key_key;
ALTER TABLE IF EXISTS ONLY public.account_emailaddress DROP CONSTRAINT IF EXISTS account_emailaddress_user_id_email_987c8728_uniq;
ALTER TABLE IF EXISTS ONLY public.account_emailaddress DROP CONSTRAINT IF EXISTS account_emailaddress_pkey;
ALTER TABLE IF EXISTS ONLY public."Likes" DROP CONSTRAINT IF EXISTS "Likes_pkey";
ALTER TABLE IF EXISTS ONLY public."Likes" DROP CONSTRAINT IF EXISTS "Likes_article_id_user_id_23e2c280_uniq";
ALTER TABLE IF EXISTS ONLY public."Favorites" DROP CONSTRAINT IF EXISTS "Favorites_pkey";
ALTER TABLE IF EXISTS ONLY public."Favorites" DROP CONSTRAINT IF EXISTS "Favorites_article_id_user_id_e1173a09_uniq";
ALTER TABLE IF EXISTS ONLY public."Comments" DROP CONSTRAINT IF EXISTS "Comments_pkey";
ALTER TABLE IF EXISTS ONLY public."CommentLikes" DROP CONSTRAINT IF EXISTS "CommentLikes_pkey";
ALTER TABLE IF EXISTS ONLY public."CommentLikes" DROP CONSTRAINT IF EXISTS "CommentLikes_comment_id_user_id_4d1f248d_uniq";
ALTER TABLE IF EXISTS public.tag ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.category ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.article_tag ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.article ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.users_useractivity;
DROP TABLE IF EXISTS public.users_profile;
DROP SEQUENCE IF EXISTS public.tag_id_seq;
DROP TABLE IF EXISTS public.tag;
DROP TABLE IF EXISTS public.socialaccount_socialtoken;
DROP TABLE IF EXISTS public.socialaccount_socialapp_sites;
DROP TABLE IF EXISTS public.socialaccount_socialapp;
DROP TABLE IF EXISTS public.socialaccount_socialaccount;
DROP TABLE IF EXISTS public.django_site;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP SEQUENCE IF EXISTS public.category_id_seq;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
DROP SEQUENCE IF EXISTS public.article_tag_id_seq;
DROP TABLE IF EXISTS public.article_tag;
DROP SEQUENCE IF EXISTS public.article_id_seq;
DROP TABLE IF EXISTS public.article;
DROP TABLE IF EXISTS public.account_emailconfirmation;
DROP TABLE IF EXISTS public.account_emailaddress;
DROP TABLE IF EXISTS public."Tags";
DROP TABLE IF EXISTS public."Likes";
DROP TABLE IF EXISTS public."Favorites";
DROP TABLE IF EXISTS public."Comments";
DROP TABLE IF EXISTS public."CommentLikes";
DROP TABLE IF EXISTS public."Categories";
DROP TABLE IF EXISTS public."Articles_tags";
DROP TABLE IF EXISTS public."Articles";
DROP FUNCTION IF EXISTS public.update_slug();
--
-- Name: update_slug(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_slug() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.slug IS NULL THEN
        NEW.slug := slugify(NEW.title); -- Функция slugify должна быть определена заранее
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_slug() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Articles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Articles" (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    publication_date timestamp with time zone NOT NULL,
    views integer NOT NULL,
    category_id bigint NOT NULL,
    slug character varying(50) NOT NULL,
    is_active boolean NOT NULL,
    status boolean NOT NULL,
    image character varying(100),
    author_id integer
);


ALTER TABLE public."Articles" OWNER TO postgres;

--
-- Name: Articles_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Articles_tags" (
    id bigint NOT NULL,
    article_id bigint NOT NULL,
    tag_id bigint NOT NULL
);


ALTER TABLE public."Articles_tags" OWNER TO postgres;

--
-- Name: Categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Categories" (
    id bigint NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public."Categories" OWNER TO postgres;

--
-- Name: CommentLikes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CommentLikes" (
    id bigint NOT NULL,
    is_like boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    comment_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public."CommentLikes" OWNER TO postgres;

--
-- Name: CommentLikes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."CommentLikes" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."CommentLikes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Comments" (
    id bigint NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    article_id bigint NOT NULL,
    user_id integer,
    parent_id bigint
);


ALTER TABLE public."Comments" OWNER TO postgres;

--
-- Name: Comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Comments" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."Comments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Favorites" (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    article_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public."Favorites" OWNER TO postgres;

--
-- Name: Favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Favorites" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."Favorites_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Likes" (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    article_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public."Likes" OWNER TO postgres;

--
-- Name: Likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Likes" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."Likes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tags" (
    id bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public."Tags" OWNER TO postgres;

--
-- Name: account_emailaddress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_emailaddress (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    verified boolean NOT NULL,
    "primary" boolean NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.account_emailaddress OWNER TO postgres;

--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.account_emailaddress ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.account_emailaddress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: account_emailconfirmation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_emailconfirmation (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    sent timestamp with time zone,
    key character varying(64) NOT NULL,
    email_address_id integer NOT NULL
);


ALTER TABLE public.account_emailconfirmation OWNER TO postgres;

--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.account_emailconfirmation ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.account_emailconfirmation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: article; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.article (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    publication_date timestamp with time zone DEFAULT now(),
    views integer DEFAULT 0,
    category_id integer DEFAULT 1 NOT NULL,
    slug character varying(255),
    is_active boolean DEFAULT true
);


ALTER TABLE public.article OWNER TO postgres;

--
-- Name: article_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.article_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.article_id_seq OWNER TO postgres;

--
-- Name: article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.article_id_seq OWNED BY public.article.id;


--
-- Name: article_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.article_tag (
    id integer NOT NULL,
    article_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.article_tag OWNER TO postgres;

--
-- Name: article_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.article_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.article_tag_id_seq OWNER TO postgres;

--
-- Name: article_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.article_tag_id_seq OWNED BY public.article_tag.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_id_seq OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO postgres;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_site ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: news_article_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Articles" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.news_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: news_article_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Articles_tags" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.news_article_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: news_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Categories" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.news_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: news_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Tags" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.news_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: socialaccount_socialaccount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socialaccount_socialaccount (
    id integer NOT NULL,
    provider character varying(200) NOT NULL,
    uid character varying(191) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    extra_data jsonb NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.socialaccount_socialaccount OWNER TO postgres;

--
-- Name: socialaccount_socialaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.socialaccount_socialaccount ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.socialaccount_socialaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: socialaccount_socialapp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socialaccount_socialapp (
    id integer NOT NULL,
    provider character varying(30) NOT NULL,
    name character varying(40) NOT NULL,
    client_id character varying(191) NOT NULL,
    secret character varying(191) NOT NULL,
    key character varying(191) NOT NULL,
    provider_id character varying(200) NOT NULL,
    settings jsonb NOT NULL
);


ALTER TABLE public.socialaccount_socialapp OWNER TO postgres;

--
-- Name: socialaccount_socialapp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.socialaccount_socialapp ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.socialaccount_socialapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: socialaccount_socialapp_sites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socialaccount_socialapp_sites (
    id bigint NOT NULL,
    socialapp_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.socialaccount_socialapp_sites OWNER TO postgres;

--
-- Name: socialaccount_socialapp_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.socialaccount_socialapp_sites ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.socialaccount_socialapp_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: socialaccount_socialtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socialaccount_socialtoken (
    id integer NOT NULL,
    token text NOT NULL,
    token_secret text NOT NULL,
    expires_at timestamp with time zone,
    account_id integer NOT NULL,
    app_id integer
);


ALTER TABLE public.socialaccount_socialtoken OWNER TO postgres;

--
-- Name: socialaccount_socialtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.socialaccount_socialtoken ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.socialaccount_socialtoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tag_id_seq OWNER TO postgres;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;


--
-- Name: users_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_profile (
    id bigint NOT NULL,
    avatar character varying(100),
    bio text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.users_profile OWNER TO postgres;

--
-- Name: users_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users_profile ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_useractivity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_useractivity (
    id bigint NOT NULL,
    action_type character varying(20) NOT NULL,
    description character varying(255) NOT NULL,
    related_object_id integer,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT users_useractivity_related_object_id_check CHECK ((related_object_id >= 0))
);


ALTER TABLE public.users_useractivity OWNER TO postgres;

--
-- Name: users_useractivity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users_useractivity ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_useractivity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: article id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article ALTER COLUMN id SET DEFAULT nextval('public.article_id_seq'::regclass);


--
-- Name: article_tag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_tag ALTER COLUMN id SET DEFAULT nextval('public.article_tag_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: tag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);


--
-- Data for Name: Articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Articles" (id, title, content, publication_date, views, category_id, slug, is_active, status, image, author_id) FROM stdin;
3	Деревья начали ходить	В лесу Хёвюдборгарсвёйтюр деревья начали передвигаться. Экологи в панике.	2023-10-03 13:00:00+01	120	3	3-derevya-nachali-hodit	t	f	\N	\N
5	Птицы строят небоскребы	В городе Хабнарфьордюр птицы начали строить небоскребы. Архитекторы в недоумении.	2023-10-05 13:00:00+01	250	5	5-pticy-stroyat-neboskreby	t	f	\N	\N
13	Лисы открыли школу	В лесу Селтьяднарнес лисы открыли школу. Ученики довольны.	2023-10-13 13:00:00+01	251	6	13-lisy-otkryli-shkolu	t	t		\N
8	Лягушки учатся в университете	В университете Рейкьявик лягушки начали посещать лекции. Студенты в шоке.	2023-10-08 13:00:00+01	160	1	8-lyagushki-uchatsya-v-universitete	t	f	\N	\N
10	Пчелы строят космические корабли	В лесу Хёвюдборгарсвёйтюр пчелы начали строить космические корабли. Ученые в недоумении.	2023-10-10 13:00:00+01	210	3	10-pchely-stroyat-kosmicheskie-korabli	t	f	\N	\N
15	Зайцы открыли библиотеку	В лесу Рейкьявик зайцы открыли библиотеку. Читатели довольны.	2023-10-15 13:00:00+01	200	1	15-zaytsy-otkryli-biblioteku	t	f	\N	\N
16	Ежики открыли музей	В городе Акурейри ежики открыли музей. Посетители довольны.	2023-10-16 13:00:00+01	170	2	16-ezhiki-otkryli-muzey	t	f	\N	\N
17	Кроты открыли ресторан	В лесу Хёвюдборгарсвёйтюр кроты открыли ресторан. Посетители довольны.	2023-10-17 13:00:00+01	230	3	17-kroty-otkryli-restoran	t	f	\N	\N
4	Рыбы поют оперу	В аквариуме Кеблавик рыбы начали петь оперные арии. Зрители в восторге.	2023-10-04 13:00:00+01	306	4	4-ryby-poyut-operu	t	f		\N
21	Утки открыли салон красоты	В парке Хабнарфьордюр утки открыли салон красоты. Клиенты довольны.	2023-10-21 13:00:00+01	240	7	21-utki-otkryli-salon-krasoty	t	f	\N	\N
22	Гуси открыли фитнес-центр	В городе Рейкьявик гуси открыли фитнес-центр. Посетители довольны.	2023-10-22 13:00:00+01	270	1	22-gusi-otkryli-fitnes-tsentr	t	f	\N	\N
23	Лебеди открыли спа-салон	В озере Акурейри лебеди открыли спа-салон. Клиенты довольны.	2023-10-23 13:00:00+01	200	2	23-lebedi-otkryli-spa-salon	t	f	\N	\N
26	Аисты открыли детский сад	В деревне Вестманнаэйяр аисты открыли детский сад. Родители довольны.	2023-10-26 13:00:00+01	220	5	26-aisty-otkryli-detskiy-sad	t	f	\N	\N
19	Пауки открыли спортзал	В лесу Вестманнаэйяр пауки открыли спортзал. Посетители довольны.	2023-10-19 13:00:00+01	191	5	19-pauki-otkryli-sportzal	t	f		\N
14	Белки открыли магазин	В парке Хабнарфьордюр белки открыли магазин. Покупатели довольны.	2023-10-14 13:00:00+01	271	7	14-belki-otkryli-magazin	t	f	\N	\N
9	Мыши открыли банк	В городе Акурейри мыши открыли банк. Клиенты довольны.	2023-10-09 13:00:00+01	281	2	9-myshi-otkryli-bank	t	f	\N	\N
11	Слоны играют в шахматы	В зоопарке Кеблавик слоны начали играть в шахматы. Посетители в восторге.	2023-10-11 13:00:00+01	321	4	11-slony-igrayut-v-shahmaty	t	f	\N	\N
18	Летучие мыши открыли кинотеатр	В городе Кеблавик летучие мыши открыли кинотеатр. Зрители довольны.	2023-10-18 13:00:00+01	262	4	18-letuchie-myshi-otkryli-kinoteatr	t	f	\N	\N
24	Фламинго открыли танцевальную студию	В парке Хёвюдборгарсвёйтюр фламинго открыли танцевальную студию. Посетители довольны.	2023-10-24 13:00:00+01	231	3	24-flamingo-otkryli-tantsevalnuyu-studiyu	t	f	\N	\N
29	Совы открыли библиотеку	В лесу Рейкьявик совы открыли библиотеку. Читатели довольны.	2023-10-29 12:00:00+00	241	1	29-sovy-otkryli-biblioteku	t	f	\N	\N
1	Кошки научились говорить	Вчера в городе Рейкьявик кошки начали разговаривать на человеческом языке. Ученые в шоке.	2023-10-01 13:00:00+01	152	1	1-koshki-nauchilis-govorit	t	f	\N	\N
25	Пеликаны открыли йога-студию	В городе Кеблавик пеликаны открыли йога-студию. Посетители довольны.	2023-10-25 13:00:00+01	251	4	25-pelikany-otkryli-yoga-studiyu	t	f	\N	\N
28	Ибисы открыли музыкальную школу	В парке Хабнарфьордюр ибисы открыли музыкальную школу. Ученики довольны.	2023-10-28 13:00:00+01	211	7	28-ibisy-otkryli-muzykalnuyu-shkolu	t	f	\N	\N
2	Летающие собаки замечены над городом	Жители города Акурейри сообщают о летающих собаках. Власти обещают разобраться.	2023-10-02 13:00:00+01	201	2	2-letayushchie-sobaki-zamecheny-nad-gorodom	t	f	\N	\N
12	Куры открыли театр	В деревне Вестманнаэйяр куры открыли театр. Зрители довольны.	2023-10-12 13:00:00+01	191	5	12-kury-otkryli-teatr	t	f	\N	\N
7	Кролики играют в футбол	В парке Селтьяднарнес кролики начали играть в футбол. Болельщики в восторге.	2023-10-07 13:00:00+01	221	7	7-kroliki-igrayut-v-futbol	t	f		\N
30	Олени открыли ресторан	В городе Акурейри олени открыли ресторан. Посетители довольны.	2023-10-30 12:00:00+00	270	2	30-oleni-otkryli-restoran	t	f	\N	\N
31	Лоси открыли кафе	В лесу Хёвюдборгарсвёйтюр лоси открыли кафе. Посетители довольны.	2023-10-31 12:00:00+00	200	3	31-losi-otkryli-kafe	t	f	\N	\N
32	Волки открыли спортзал	В городе Кеблавик волки открыли спортзал. Посетители довольны.	2023-11-01 12:00:00+00	230	4	32-volki-otkryli-sportzal	t	f	\N	\N
33	Лисы открыли музей	В деревне Вестманнаэйяр лисы открыли музей. Посетители довольны.	2023-11-02 12:00:00+00	250	5	33-lisy-otkryli-muzey	t	f	\N	\N
35	Зайцы открыли библиотеку	В лесу Хабнарфьордюр зайцы открыли библиотеку. Читатели довольны.	2023-11-04 12:00:00+00	260	7	35-zaytsy-otkryli-biblioteku	t	f	\N	\N
36	Ежики открыли музей	В городе Рейкьявик ежики открыли музей. Посетители довольны.	2023-11-05 12:00:00+00	210	1	36-ezhiki-otkryli-muzey	t	f	\N	\N
37	Кроты открыли ресторан	В лесу Акурейри кроты открыли ресторан. Посетители довольны.	2023-11-06 12:00:00+00	240	2	37-kroty-otkryli-restoran	t	f	\N	\N
38	Летучие мыши открыли кинотеатр	В городе Хёвюдборгарсвёйтюр летучие мыши открыли кинотеатр. Зрители довольны.	2023-11-07 12:00:00+00	270	3	38-letuchie-myshi-otkryli-kinoteatr	t	f	\N	\N
39	Пауки открыли спортзал	В лесу Вестманнаэйяр пауки открыли спортзал. Посетители довольны.	2023-11-08 12:00:00+00	200	4	39-pauki-otkryli-sportzal	t	f	\N	\N
40	Жабы открыли кафе	В городе Селтьяднарнес жабы открыли кафе. Посетители довольны.	2023-11-09 12:00:00+00	230	5	40-zhaby-otkryli-kafe	t	f	\N	\N
42	Гуси открыли фитнес-центр	В городе Рейкьявик гуси открыли фитнес-центр. Посетители довольны.	2023-11-11 12:00:00+00	220	7	42-gusi-otkryli-fitnes-tsentr	t	f	\N	\N
43	Лебеди открыли спа-салон	В озере Акурейри лебеди открыли спа-салон. Клиенты довольны.	2023-11-12 12:00:00+00	260	1	43-lebedi-otkryli-spa-salon	t	f	\N	\N
44	Фламинго открыли танцевальную студию	В парке Хёвюдборгарсвёйтюр фламинго открыли танцевальную студию. Посетители довольны.	2023-11-13 12:00:00+00	200	2	44-flamingo-otkryli-tantsevalnuyu-studiyu	t	f	\N	\N
45	Пеликаны открыли йога-студию	В городе Кеблавик пеликаны открыли йога-студию. Посетители довольны.	2023-11-14 12:00:00+00	230	3	45-pelikany-otkryli-yoga-studiyu	t	f	\N	\N
46	Аисты открыли детский сад	В деревне Вестманнаэйяр аисты открыли детский сад. Родители довольны.	2023-11-15 12:00:00+00	250	4	46-aisty-otkryli-detskiy-sad	t	f	\N	\N
47	Цапли открыли школу искусств	В городе Селтьяднарнес цапли открыли школу искусств. Ученики довольны.	2023-11-16 12:00:00+00	220	5	47-tsapli-otkryli-shkolu-iskusstv	t	f	\N	\N
49	Совы открыли библиотеку	В лесу Рейкьявик совы открыли библиотеку. Читатели довольны.	2023-11-18 12:00:00+00	210	7	49-sovy-otkryli-biblioteku	t	f	\N	\N
50	Олени открыли ресторан	В городе Акурейри олени открыли ресторан. Посетители довольны.	2023-11-19 12:00:00+00	240	1	50-oleni-otkryli-restoran	t	f	\N	\N
51	Лоси открыли кафе	В лесу Хёвюдборгарсвёйтюр лоси открыли кафе. Посетители довольны.	2023-11-20 12:00:00+00	270	2	51-losi-otkryli-kafe	t	f	\N	\N
52	Волки открыли спортзал	В городе Кеблавик волки открыли спортзал. Посетители довольны.	2023-11-21 12:00:00+00	200	3	52-volki-otkryli-sportzal	t	f	\N	\N
53	Лисы открыли музей	В деревне Вестманнаэйяр лисы открыли музей. Посетители довольны.	2023-11-22 12:00:00+00	230	4	53-lisy-otkryli-muzey	t	f	\N	\N
54	Белки открыли магазин	В парке Селтьяднарнес белки открыли магазин. Покупатели довольны.	2023-11-23 12:00:00+00	250	5	54-belki-otkryli-magazin	t	f	\N	\N
34	Белки открыли магазин	В парке Селтьяднарнес белки открыли магазин. Покупатели довольны.	2023-11-03 12:00:00+00	222	6	34-belki-otkryli-magazin	t	t		\N
56	Ежики открыли музей	В городе Рейкьявик ежики открыли музей. Посетители довольны.	2023-11-25 12:00:00+00	260	7	56-ezhiki-otkryli-muzey	t	f	\N	\N
57	Кроты открыли ресторан	В лесу Акурейри кроты открыли ресторан. Посетители довольны.	2023-11-26 12:00:00+00	210	1	57-kroty-otkryli-restoran	t	f	\N	\N
58	Летучие мыши открыли кинотеатр	В городе Хёвюдборгарсвёйтюр летучие мыши открыли кинотеатр. Зрители довольны.	2023-11-27 12:00:00+00	240	2	58-letuchie-myshi-otkryli-kinoteatr	t	f	\N	\N
59	Пауки открыли спортзал	В лесу Вестманнаэйяр пауки открыли спортзал. Посетители довольны.	2023-11-28 12:00:00+00	270	3	59-pauki-otkryli-sportzal	t	f	\N	\N
60	Жабы открыли кафе	В городе Селтьяднарнес жабы открыли кафе. Посетители довольны.	2023-11-29 12:00:00+00	200	4	60-zhaby-otkryli-kafe	t	f	\N	\N
61	Утки открыли салон красоты	В парке Хабнарфьордюр утки открыли салон красоты. Клиенты довольны.	2023-11-30 12:00:00+00	230	5	61-utki-otkryli-salon-krasoty	t	f	\N	\N
63	Лебеди открыли спа-салон	В озере Акурейри лебеди открыли спа-салон. Клиенты довольны.	2023-12-02 12:00:00+00	220	7	63-lebedi-otkryli-spa-salon	t	f	\N	\N
64	Фламинго открыли танцевальную студию	В парке Хёвюдборгарсвёйтюр фламинго открыли танцевальную студию. Посетители довольны.	2023-12-03 12:00:00+00	260	1	64-flamingo-otkryli-tantsevalnuyu-studiyu	t	f	\N	\N
65	Пеликаны открыли йога-студию	В городе Кеблавик пеликаны открыли йога-студию. Посетители довольны.	2023-12-04 12:00:00+00	210	2	65-pelikany-otkryli-yoga-studiyu	t	f	\N	\N
66	Аисты открыли детский сад	В деревне Вестманнаэйяр аисты открыли детский сад. Родители довольны.	2023-12-05 12:00:00+00	240	3	66-aisty-otkryli-detskiy-sad	t	f	\N	\N
67	Цапли открыли школу искусств	В городе Селтьяднарнес цапли открыли школу искусств. Ученики довольны.	2023-12-06 12:00:00+00	270	4	67-tsapli-otkryli-shkolu-iskusstv	t	f	\N	\N
68	Ибисы открыли музыкальную школу	В парке Хабнарфьордюр ибисы открыли музыкальную школу. Ученики довольны.	2023-12-07 12:00:00+00	200	5	68-ibisy-otkryli-muzykalnuyu-shkolu	t	f	\N	\N
70	Олени открыли ресторан	В городе Акурейри олени открыли ресторан. Посетители довольны.	2023-12-09 12:00:00+00	250	7	70-oleni-otkryli-restoran	t	f	\N	\N
71	Лоси открыли кафе	В лесу Хёвюдборгарсвёйтюр лоси открыли кафе. Посетители довольны.	2023-12-10 12:00:00+00	220	1	71-losi-otkryli-kafe	t	f	\N	\N
72	Волки открыли спортзал	В городе Кеблавик волки открыли спортзал. Посетители довольны.	2023-12-11 12:00:00+00	260	2	72-volki-otkryli-sportzal	t	f	\N	\N
73	Лисы открыли музей	В деревне Вестманнаэйяр лисы открыли музей. Посетители довольны.	2023-12-12 12:00:00+00	210	3	73-lisy-otkryli-muzey	t	f	\N	\N
75	Зайцы открыли библиотеку	В лесу Хабнарфьордюр зайцы открыли библиотеку. Читатели довольны.	2023-12-14 12:00:00+00	270	5	75-zaytsy-otkryli-biblioteku	t	f	\N	\N
77	Кроты открыли ресторан	В лесу Акурейри кроты открыли ресторан. Посетители довольны.	2023-12-16 12:00:00+00	230	7	77-kroty-otkryli-restoran	t	f	\N	\N
78	Летучие мыши открыли кинотеатр	В городе Хёвюдборгарсвёйтюр летучие мыши открыли кинотеатр. Зрители довольны.	2023-12-17 12:00:00+00	250	1	78-letuchie-myshi-otkryli-kinoteatr	t	f	\N	\N
79	Пауки открыли спортзал	В лесу Вестманнаэйяр пауки открыли спортзал. Посетители довольны.	2023-12-18 12:00:00+00	220	2	79-pauki-otkryli-sportzal	t	f	\N	\N
80	Жабы открыли кафе	В городе Селтьяднарнес жабы открыли кафе. Посетители довольны.	2023-12-19 12:00:00+00	260	3	80-zhaby-otkryli-kafe	t	f	\N	\N
81	Утки открыли салон красоты	В парке Хабнарфьордюр утки открыли салон красоты. Клиенты довольны.	2023-12-20 12:00:00+00	210	4	81-utki-otkryli-salon-krasoty	t	f	\N	\N
82	Гуси открыли фитнес-центр	В городе Рейкьявик гуси открыли фитнес-центр. Посетители довольны.	2023-12-21 12:00:00+00	240	5	82-gusi-otkryli-fitnes-tsentr	t	f	\N	\N
84	Фламинго открыли танцевальную студию	В парке Хёвюдборгарсвёйтюр фламинго открыли танцевальную студию. Посетители довольны.	2023-12-23 12:00:00+00	200	7	84-flamingo-otkryli-tantsevalnuyu-studiyu	t	f	\N	\N
85	Пеликаны открыли йога-студию	В городе Кеблавик пеликаны открыли йога-студию. Посетители довольны.	2023-12-24 12:00:00+00	230	1	85-pelikany-otkryli-yoga-studiyu	t	f	\N	\N
86	Аисты открыли детский сад	В деревне Вестманнаэйяр аисты открыли детский сад. Родители довольны.	2023-12-25 12:00:00+00	250	2	86-aisty-otkryli-detskiy-sad	t	f	\N	\N
87	Цапли открыли школу искусств	В городе Селтьяднарнес цапли открыли школу искусств. Ученики довольны.	2023-12-26 12:00:00+00	220	3	87-tsapli-otkryli-shkolu-iskusstv	t	f	\N	\N
88	Ибисы открыли музыкальную школу	В парке Хабнарфьордюр ибисы открыли музыкальную школу. Ученики довольны.	2023-12-27 12:00:00+00	260	4	88-ibisy-otkryli-muzykalnuyu-shkolu	t	f	\N	\N
89	Совы открыли библиотеку	В лесу Рейкьявик совы открыли библиотеку. Читатели довольны.	2023-12-28 12:00:00+00	210	5	89-sovy-otkryli-biblioteku	t	f	\N	\N
91	Лоси открыли кафе	В лесу Хёвюдборгарсвёйтюр лоси открыли кафе. Посетители довольны.	2023-12-30 12:00:00+00	270	7	91-losi-otkryli-kafe	t	f	\N	\N
94	Белки открыли магазин	В парке Селтьяднарнес белки открыли магазин. Покупатели довольны.	2024-01-02 12:00:00+00	250	3	94-belki-otkryli-magazin	t	f	\N	\N
96	Ежики открыли музей	В городе Рейкьявик ежики открыли музей. Посетители довольны.	2024-01-04 12:00:00+00	260	5	96-ezhiki-otkryli-muzey	t	f	\N	\N
6	Медведи открыли ресторан	В лесу Вестманнаэйяр медведи открыли ресторан. Посетители довольны.	2023-10-06 13:00:00+01	191	6	6-medvedi-otkryli-restoran	t	t	\N	\N
101	Слоны все спят	Нужно узнать когда они проснуться	2025-03-10 20:17:57.798071+00	68	4	slony-vse-spiat-101	t	f	articles/2025/03/12/b0f66c8d79ce63f231ae50c7f7e5346d.jpg	\N
98	Летучие мыши открыли кинотеатр	В городе Хёвюдборгарсвёйтюр летучие мыши открыли кинотеатр. Зрители довольны.	2024-01-06 12:00:00+00	248	7	98-letuchie-myshi-otkryli-kinoteatr	t	f	articles/2025/03/13/7cac5acb42facfeb659a1604377b8fed.jpg	\N
102	Гэндальф открыл школу магии	В городе Ривенделл Гэндальф Серый открыл школу магии для молодых волшебников. Ученики уже освоили заклинания для призыва огня и левитации. Родители в восторге от успехов своих детей, хотя некоторые жалуются на частые пожары в школьном дворе.	2025-03-13 20:53:48.729148+00	1	10	gendalf-otkryl-shkolu-magii-102	t	f		\N
95	Зайцы открыли библиотеку	В лесу Хабнарфьордюр зайцы открыли библиотеку. Читатели довольны.	2024-01-03 12:00:00+00	221	4	95-zaytsy-otkryli-biblioteku	t	f	\N	\N
92	Волки открыли спортзал	В городе Кеблавик волки открыли спортзал. Посетители довольны.	2023-12-31 12:00:00+00	204	1	92-volki-otkryli-sportzal	t	f	articles/2025/03/16/297e0eaadc44c9b4480bb7a1602cbc9d.jpg	\N
93	Лисы открыли музей	В деревне Вестманнаэйяр лисы открыли музей. Посетители довольны.	2024-01-01 12:00:00+00	235	2	93-lisy-otkryli-muzey	t	f	articles/2025/03/16/7cac5acb42facfeb659a1604377b8fed.jpg	\N
100	Жабы открыли кафе	В городе Селтьяднарнес жабы открыли кафе. Посетители довольны.	2024-01-08 12:00:00+00	251	2	100-zhaby-otkryli-kafe	t	f	articles/2025/03/13/b663d8baf26affb8cf84d15c8389d5d1.png	\N
41	Утки открыли салон красоты	В парке Хабнарфьордюр утки открыли салон красоты. Клиенты довольны.	2023-11-10 12:00:00+00	251	6	41-utki-otkryli-salon-krasoty	t	t	\N	\N
55	Зайцы открыли библиотеку	В лесу Хабнарфьордюр зайцы открыли библиотеку. Читатели довольны.	2023-11-24 12:00:00+00	221	6	55-zaytsy-otkryli-biblioteku	t	t	\N	\N
99	Пауки открыли спортзал	В лесу Вестманнаэйяр пауки открыли спортзал. Посетители довольны.	2024-01-07 12:00:00+00	280	1	99-pauki-otkryli-sportzal	t	f	articles/2025/03/13/20cdbe1f88d3c8ca171cdf3fc125d98e.jpg	\N
104	Хоббиты изобрели летающий велосипед	В Хоббитоне местные жители изобрели летающий велосипед, который работает на магической энергии. Теперь хоббиты могут путешествовать по всему Средиземью, не покидая своих уютных нор.	2025-03-13 20:53:48.752885+00	0	1	khobbity-izobreli-letaiushchii-velosiped-104	t	f		\N
105	Эльфы открыли секрет вечной молодости	Эльфы из Лориэна открыли секрет вечной молодости, который заключается в ежедневном употреблении лембарского вина и пении эльфийских песен. Ученые из Гондора уже начали исследования, чтобы подтвердить это открытие.	2025-03-13 20:53:48.758669+00	0	2	elfy-otkryli-sekret-vechnoi-molodosti-105	t	f		\N
106	Орки устроили фестиваль моды	В Мордоре орки устроили первый в истории фестиваль моды, где представлены коллекции доспехов и оружия. Модельеры из разных уголков Средиземья приехали, чтобы увидеть это уникальное шоу.	2025-03-13 20:53:48.764007+00	0	4	orki-ustroili-festival-mody-106	t	f		\N
74	Белки открыли магазин	В парке Селтьяднарнес белки открыли магазин. Покупатели довольны.	2023-12-13 12:00:00+00	241	4	74-belki-otkryli-magazin	t	f		\N
107	Голлум стал поп-звездой	Голлум неожиданно стал поп-звездой, выпустив альбом с песнями о своем кольце. Его концерты собирают тысячи фанатов, которые приходят, чтобы услышать его уникальный голос и забавные тексты.	2025-03-13 20:53:48.76896+00	0	4	gollum-stal-pop-zvezdoi-107	t	f		\N
108	Дроиды устроили забастовку	На планете Татуин дроиды устроили забастовку, требуя повышения зарплаты и улучшения условий труда. Их лидер, R2-D2, заявил, что дроиды больше не будут терпеть несправедливость.	2025-03-13 20:53:48.774576+00	0	5	droidy-ustroili-zabastovku-108	t	f		\N
114	Арагорн стал гидом по Средиземью	Арагорн, следопыт Севера, стал гидом по Средиземью, предлагая туры по самым интересным местам. Его знания и опыт делают его лучшим проводником для туристов.	2025-03-13 20:53:48.806151+00	1	11	aragorn-stal-gidom-po-sredizemiu-114	t	f		\N
112	Леголас стал чемпионом по серфингу	Леголас, эльф из Лихолесья, стал чемпионом по серфингу на волнах озера Нурнен. Его грация и мастерство покорили сердца зрителей и судей.	2025-03-13 20:53:48.79567+00	0	3	legolas-stal-chempionom-po-serfingu-112	t	f		\N
333	Лорд Волдеморт открыл фастфуд	Лорд Волдеморт открыл сеть фастфудов в магическом мире, где подают бургеры из драконьего мяса и картофель фри. Его рестораны стали популярными среди туристов и местных жителей.	2025-03-20 10:28:29.466692+00	0	11	lord-voldemort-otkryl-fastfud-466509	t	f		\N
334	Луна Лавгуд стала чемпионкой по серфингу	Луна Лавгуд, студентка Хогвартса, стала чемпионкой по серфингу на волнах озера Хогвартс. Ее грация и мастерство покорили сердца зрителей и судей.	2025-03-20 10:28:29.469835+00	0	3	luna-lavgud-stala-chempionkoi-po-serfing-466509	t	f		\N
115	Саурон открыл тематический парк	Саурон, Темный Властелин, открыл тематический парк в Мордоре, где посетители могут почувствовать себя настоящими орками. Аттракционы и шоу привлекают тысячи туристов ежедневно.	2025-03-13 20:53:48.810896+00	0	11	sauron-otkryl-tematicheskii-park-115	t	f		\N
335	Фред и Джордж открыли пивоварню	Фред и Джордж Уизли открыли пивоварню, где варят пиво по магическим рецептам. Их напитки стали популярными среди жителей магического мира и туристов.	2025-03-20 10:28:29.474843+00	0	11	fred-i-dzhordzh-otkryli-pivovarniu-466509	t	f		\N
116	Эовин стала чемпионкой по фехтованию	Эовин, принцесса Рохана, стала чемпионкой по фехтованию, победив всех соперников на турнире в Минас Тирите. Ее мастерство и храбрость впечатлили всех зрителей.	2025-03-13 20:53:48.816107+00	0	3	eovin-stala-chempionkoi-po-fekhtovaniiu-116	t	f		\N
336	Сириус Блэк стал гидом	Сириус Блэк стал гидом по магическому миру, предлагая туры по самым интересным местам. Его знания и опыт делают его лучшим проводником для туристов.	2025-03-20 10:28:29.479419+00	0	11	sirius-blek-stal-gidom-466509	t	f		\N
117	Фарамир открыл библиотеку	Фарамир, сын Дэнетора, открыл библиотеку в Минас Тирите, где собраны древние манускрипты и книги. Его библиотека стала популярным местом для ученых и студентов.	2025-03-13 20:53:48.820882+00	0	7	faramir-otkryl-biblioteku-117	t	f		\N
118	Мерри и Пиппин стали комиками	Мерри и Пиппин, хоббиты из Шира, стали популярными комиками, выступая с юмористическими шоу по всему Средиземью. Их шутки и скетчи собирают полные залы.	2025-03-13 20:53:48.82679+00	0	4	merri-i-pippin-stali-komikami-118	t	f		\N
119	Теоден стал чемпионом по скачкам	Теоден, король Рохана, стал чемпионом по скачкам, победив на турнире в Эдорасе. Его мастерство и скорость впечатлили всех зрителей и судей.	2025-03-13 20:53:48.833616+00	0	3	teoden-stal-chempionom-po-skachkam-119	t	f		\N
121	Бильбо стал писателем	Бильбо Бэггинс, хоббит из Шира, стал популярным писателем, написав книгу о своих приключениях. Его произведения стали бестселлерами по всему Средиземью.	2025-03-13 20:53:48.844204+00	0	4	bilbo-stal-pisatelem-121	t	f		\N
123	Ученые открыли новый вид пауков	Группа ученых из Ширского университета совершила удивительное открытие, обнаружив новый вид пауков, обитающих в пещерах Мории. Новый вид, получивший название «Паук-гоблин», отличается своими гигантскими размерами и способностью плести паутину из адамантия. Ученые предполагают, что «Пауки-гоблины» могут представлять серьезную угрозу для жителей Средиземья, так как их укусы содержат смертельный яд. В связи с этим, власти Шира призвали жителей к осторожности и рекомендовали избегать посещения пещер Мории. В настоящее время, ученые продолжают изучение «Пауков-гоблинов», чтобы определить их популяцию и разработать меры по защите населения.	2025-03-13 20:53:48.854109+00	0	2	uchenye-otkryli-novyi-vid-paukov-123	t	f		\N
122	Орки изобрели летающий транспорт	В Мордоре орки совершили технологический прорыв, создав первый в мире летающий транспорт, работающий на энергии ненависти. Новое изобретение, названное «Грум-мобиль», способно развивать скорость до 300 км/ч и перевозить до 10 орков одновременно. Орки уже начали использовать «Грум-мобили» для доставки провизии и оружия, а также для проведения разведывательных операций. Эксперты опасаются, что новое изобретение может привести к усилению военной мощи Мордора и дестабилизации обстановки в Средиземье. В связи с этим, страны-участницы Лиги обороны Средиземья выразили свою обеспокоенность и призвали Мордор к сдержанности. Однако, орки пока никак не отреагировали на это заявление.	2025-03-13 20:53:48.849686+00	2	1	orki-izobreli-letaiushchii-transport-122	t	f		\N
124	Эльфы выиграли чемпионат по стрельбе	Эльфы из Лихолесья одержали убедительную победу на ежегодном чемпионате по стрельбе из лука, который проходил в городе Эсгарот. Эльфийский лучник Леголас в очередной раз подтвердил свой высокий класс, поразив все мишени и установив новый рекорд соревнований. Второе место занял представитель гномов Гимли, а третье место досталось человеку по имени Бард. Чемпионат по стрельбе из лука является одним из самых популярных спортивных мероприятий в Средиземье, в котором принимают участие представители всех рас. В этом году, соревнования прошли на высоком уровне и собрали большое количество зрителей. Победа эльфов стала еще одним подтверждением их превосходства в искусстве стрельбы из лука.	2025-03-13 20:53:48.858612+00	0	3	elfy-vyigrali-chempionat-po-strelbe-124	t	f		\N
125	В Ривенделле открылась выставка картин	В Ривенделле состоялось открытие выставки картин известного художника Элронда. На выставке представлены работы, выполненные в различных жанрах, от пейзажей до портретов. Особое внимание посетителей привлекают картины, посвященные истории Средиземья и его обитателям. Выставка Элронда стала важным культурным событием в жизни Ривенделла и всего Средиземья. Ее посетили многие известные личности, в том числе эльфийские лорды и маги. Выставка продлится до конца года, и все желающие могут посетить ее и насладиться прекрасными произведениями искусства.	2025-03-13 20:53:48.864173+00	0	4	v-rivendelle-otkrylas-vystavka-kartin-125	t	f		\N
126	В Гондоре прошли выборы короля	В Гондоре состоялись выборы нового короля. По результатам голосования, королем Гондора стал Арагорн, потомок Исилдура. Арагорн был избран большинством голосов, получив поддержку как знати, так и простого народа. Он пообещал править мудро и справедливо, а также защищать границы Гондора от врагов. Инаугурация Арагорна состоится в ближайшее время, и он официально вступит в должность короля Гондора. Это событие имеет большое значение для всего Средиземья, так как Гондор является одним из самых могущественных королевств.	2025-03-13 20:53:48.868286+00	0	5	v-gondore-proshli-vybory-korolia-126	t	f		\N
130	В Шире прошёл фестиваль хоббитов	В Шире с большим успехом прошёл ежегодный фестиваль хоббитов. Тысячи хоббитов со всего Шира собрались вместе, чтобы отпраздновать это важное событие. В программе фестиваля были различные конкурсы, игры, танцы и, конечно же, обильное угощение. Хоббиты с удовольствием ели, пили и веселились, наслаждаясь праздником. Фестиваль хоббитов является важным культурным событием в жизни Шира, которое способствует укреплению дружбы и единства среди хоббитов. В этом году фестиваль прошёл особенно ярко и запомнился всем участникам.	2025-03-13 20:53:48.885717+00	3	4	v-shire-proshiol-festival-khobbitov-130	t	f		\N
128	В Бри открылась школа волшебства	В Бри состоялось открытие школы волшебства, в которой будут обучаться дети со всего Средиземья. В школе преподают опытные маги, которые передают свои знания ученикам. Обучение в школе волшебства является платным, но талантливые дети из малообеспеченных семей могут получить грант на обучение. Открытие школы волшебства вызвало большой интерес у жителей Средиземья, и многие родители уже записали своих детей на обучение. В школе дети будут изучать различные виды магии, а также научатся защищаться от темных сил. Ожидается, что выпускники школы волшебства станут известными магами и будут помогать людям.	2025-03-13 20:53:48.876773+00	2	7	v-bri-otkrylas-shkola-volshebstva-128	t	f		\N
384	Subaru показала японскую версию Forester с кузовными комплектами в стиле самурайских доспехов	Шестое поколение популярного кроссовера в версии для домашнего рынка получило ряд аксессуаров, которые пока не доступны для других стран.\r\n\r\nЧто известно\r\nSubaru представила японскую версию шестого поколения Forester. Одна из особенностей "домашней" модели - расширенные возможности кастомизации внешнего вида, включая внедорожные и спортивные комплекты обвесов.\r\n\r\nЯпонская линейка Forester шестого поколения включает три версии: X-Break, Premium и Sport. Сочетание X-Break с комплектом Adventure Style существенно меняет внешний вид кроссовера. Оригинальная решетка радиатора, декор фар и высоко расположенные накладки на дверях создают вид самурайских доспехов.\r\n\r\nДля тех, кто хочет подчеркнуть внедорожный вид, Subaru предлагает дополнительные черные наклейки с горными мотивами на капот, боковины и заднюю дверь. Однако, в отличие от американской версии Forester Wilderness, комплект Adventure Style в Японии сохраняет стандартную подвеску без увеличения клиренса.	2025-04-04 11:20:07.229384+01	6	12	subaru-pokazala-iaponskuiu-versiiu-fores-762007	t	t	articles/2025/04/04/74784ec3f63a2d2d53ff69bf2c1c3b20.jpg	8
302	В Гондоре изобрели новый вид транспорта	В Гондоре, в секретных лабораториях Минас Тирита, был изобретен новый вид транспорта, который получил название «Крылатый конь». Это транспортное средство представляет собой механического коня, который способен летать по воздуху. «Крылатый конь» уже используется гондорской армией для разведки и доставки грузов. Изобретение нового транспорта стало важным шагом в развитии технологий в Гондоре и усилении его военной мощи.	2025-03-20 10:28:29.298281+00	0	1	v-gondore-izobreli-novyi-vid-transporta-466509	t	f		\N
337	Беллатриса открыла тематический парк	Беллатриса Лестрейндж открыла тематический парк в магическом мире, где посетители могут почувствовать себя настоящими Пожирателями Смерти. Аттракционы и шоу привлекают тысячи туристов ежедневно.	2025-03-20 10:28:29.484472+00	0	11	bellatrisa-otkryla-tematicheskii-park-466509	t	f		\N
360	Элронд открыл спа-салон	Элронд, владыка Ривенделла, открыл спа-салон, где предлагает услуги по релаксации и омоложению. Его салон стал популярным среди эльфов и людей.	2025-03-20 11:17:12.2827+00	0	6	elrond-otkryl-spa-salon-469432	t	t		\N
272	Дроиды устроили забастовку	На планете Татуин дроиды устроили забастовку, требуя повышения зарплаты и улучшения условий труда. Их лидер, R2-D2, заявил, что дроиды больше не будут терпеть несправедливость.	2025-03-20 10:28:29.158648+00	0	5	droidy-ustroili-zabastovku-466509	t	f		\N
132	В Шире обнаружен новый вид картошки	В Шире, в огороде фермера Перегрина Тука, был обнаружен новый вид картошки, который получил название «Тук-картошка». Этот сорт отличается своими гигантскими размерами и необычным вкусом, напоминающим жареное мясо. «Тук-картошка» уже стала популярной среди хоббитов, которые используют ее для приготовления различных блюд, таких как картофельное пюре с грибами, картофельные оладьи и картофельный суп. Фермер Тук надеется, что его открытие принесет пользу всем жителям Шира и сделает их жизнь еще более вкусной и разнообразной.	2025-03-13 20:53:48.896368+00	6	2	v-shire-obnaruzhen-novyi-vid-kartoshki-132	t	f		\N
266	Гэндальф открыл школу магии	В городе Ривенделл Гэндальф Серый открыл школу магии для молодых волшебников. Ученики уже освоили заклинания для призыва огня и левитации. Родители в восторге от успехов своих детей, хотя некоторые жалуются на частые пожары в школьном дворе.	2025-03-20 10:28:29.12216+00	0	7	gendalf-otkryl-shkolu-magii-466509	t	f		\N
267	Йода стал чемпионом по шахматам	Мастер Йода неожиданно для всех стал чемпионом галактического турнира по шахматам. Его стратегия и тактика поразили всех, включая Дарта Вейдера, который признал поражение и подарил Йоде световой меч в знак уважения.	2025-03-20 10:28:29.132312+00	0	3	ioda-stal-chempionom-po-shakhmatam-466509	t	f		\N
268	Хоббиты изобрели летающий велосипед	В Хоббитоне местные жители изобрели летающий велосипед, который работает на магической энергии. Теперь хоббиты могут путешествовать по всему Средиземью, не покидая своих уютных нор.	2025-03-20 10:28:29.137322+00	0	1	khobbity-izobreli-letaiushchii-velosiped-466509	t	f		\N
269	Эльфы открыли секрет вечной молодости	Эльфы из Лориэна открыли секрет вечной молодости, который заключается в ежедневном употреблении лембарского вина и пении эльфийских песен. Ученые из Гондора уже начали исследования, чтобы подтвердить это открытие.	2025-03-20 10:28:29.14161+00	0	2	elfy-otkryli-sekret-vechnoi-molodosti-466509	t	f		\N
129	В Мордоре обнаружен портал в иное измерение	В Мордоре, в районе Роковой горы, был обнаружен портал, ведущий в иное измерение. Обнаружение портала стало настоящей сенсацией в мире науки и магии. Ученые и маги со всего Средиземья прибыли в Мордор, чтобы изучить это удивительное явление. По предварительным данным, портал может вести в параллельный мир, где существуют другие законы физики и магии. Некоторые ученые предполагают, что портал может представлять собой угрозу для Средиземья, так как через него могут проникнуть существа из другого измерения. В настоящее время, портал находится под охраной орков, которые пытаются понять, как его использовать в своих целях.	2025-03-13 20:53:48.881549+00	3	10	v-mordore-obnaruzhen-portal-v-inoe-izmerenie-129	t	f		\N
276	Леголас стал чемпионом по серфингу	Леголас, эльф из Лихолесья, стал чемпионом по серфингу на волнах озера Нурнен. Его грация и мастерство покорили сердца зрителей и судей.	2025-03-20 10:28:29.183806+00	0	3	legolas-stal-chempionom-po-serfingu-466509	t	f		\N
278	Арагорн стал гидом по Средиземью	Арагорн, следопыт Севера, стал гидом по Средиземью, предлагая туры по самым интересным местам. Его знания и опыт делают его лучшим проводником для туристов.	2025-03-20 10:28:29.19265+00	0	11	aragorn-stal-gidom-po-sredizemiu-466509	t	f		\N
279	Саурон открыл тематический парк	Саурон, Темный Властелин, открыл тематический парк в Мордоре, где посетители могут почувствовать себя настоящими орками. Аттракционы и шоу привлекают тысячи туристов ежедневно.	2025-03-20 10:28:29.197361+00	0	11	sauron-otkryl-tematicheskii-park-466509	t	f		\N
280	Эовин стала чемпионкой по фехтованию	Эовин, принцесса Рохана, стала чемпионкой по фехтованию, победив всех соперников на турнире в Минас Тирите. Ее мастерство и храбрость впечатлили всех зрителей.	2025-03-20 10:28:29.202612+00	0	3	eovin-stala-chempionkoi-po-fekhtovaniiu-466509	t	f		\N
281	Фарамир открыл библиотеку	Фарамир, сын Дэнетора, открыл библиотеку в Минас Тирите, где собраны древние манускрипты и книги. Его библиотека стала популярным местом для ученых и студентов.	2025-03-20 10:28:29.207824+00	0	7	faramir-otkryl-biblioteku-466509	t	f		\N
283	Теоден стал чемпионом по скачкам	Теоден, король Рохана, стал чемпионом по скачкам, победив на турнире в Эдорасе. Его мастерство и скорость впечатлили всех зрителей и судей.	2025-03-20 10:28:29.21765+00	0	3	teoden-stal-chempionom-po-skachkam-466509	t	f		\N
387	Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья	На выставке Expo 2025 в Осаке Kawasaki выкатила (а точнее, выгнала копытами) концепт Corleo - четвероногого робота-коня на водородном двигателе.\r\n\r\n\r\n  Ездить на нем можно, колес нет, хвоста тоже, зато есть гибридный водородно-электрический двигатель и дизайн "байкерская душа в теле трансформера". Это пока не транспорт, а манифест: о том, каким может быть передвижение без асфальта, без бензина и без компромиссов. Corleo - не серийный продукт, а скорее визия: "что, если бы мы скрестили мотоцикл с лошадью, добавили искусственный интеллект и запихнули в это все "зеленый" водород?" И если вам кажется, что это звучит как трейлер к новому "Horizon Zero Dawn" - вы не одни.\r\n\r\nKawasaki Heavy Industries - это не просто компания, которая умеет делать байки, ревущие, как голодный тигр, и роботов, работающих точнее швейцарских часов. Это целый техно-зверинец с многолетним опытом во всем, что имеет двигатель, сенсоры и желание двигаться. А Kawasaki Corleo - это концепт машины, которая воплощает ее странную, но увлекательную идею: "А что, если бы мы сделали ездовую машину на четырех ногах вместо колес и заправляли ее водородом?". Собственно, Corleo - это микс байкерской души и роботизированной начинки, родившийся где-то на пересечении мотоинженерии и меха-фантастики. Конечно, пока это выставочная игрушка для демонстрации будущих возможностей. Kawasaki нащупывает будущее персонального транспорта для тех, кому мало мотоцикла и не хватает внедорожных возможностей квадроцикла. Теперь - только прыжком в бездорожье, с HUD-экраном и в такт весовым сенсорам.\r\n\r\n Kawasaki Corleo - это четвероногий робот, на котором можно сидеть верхом, как на лошади, но вместо овса - водород. Именно так: стальной скакун на экологическом топливе. Внешне - гибрид байкерской эстетики и конской грации, будто кто-то заставил спортбайк и жеребца провести вечер наедине в лаборатории. Все это выглядит не только эффектно, но и имеет практический смысл: Corleo разрабатывают для бездорожья, сложных ландшафтов и тех моментов, когда обычные колеса пасуют, а душа просит приключений.	2025-04-09 09:55:31.905968+01	11	1	repetitsiia-2050-goda-chto-izvestno-o-ka-188931	t	t	articles/2025/04/09/kawasakicorleojump.jpg	2
286	Орки изобрели летающий транспорт	В Мордоре орки совершили технологический прорыв, создав первый в мире летающий транспорт, работающий на энергии ненависти. Новое изобретение, названное «Грум-мобиль», способно развивать скорость до 300 км/ч и перевозить до 10 орков одновременно. Орки уже начали использовать «Грум-мобили» для доставки провизии и оружия, а также для проведения разведывательных операций. Эксперты опасаются, что новое изобретение может привести к усилению военной мощи Мордора и дестабилизации обстановки в Средиземье. В связи с этим, страны-участницы Лиги обороны Средиземья выразили свою обеспокоенность и призвали Мордор к сдержанности. Однако, орки пока никак не отреагировали на это заявление.	2025-03-20 10:28:29.229391+00	0	1	orki-izobreli-letaiushchii-transport-466509	t	f		\N
287	Ученые открыли новый вид пауков	Группа ученых из Ширского университета совершила удивительное открытие, обнаружив новый вид пауков, обитающих в пещерах Мории. Новый вид, получивший название «Паук-гоблин», отличается своими гигантскими размерами и способностью плести паутину из адамантия. Ученые предполагают, что «Пауки-гоблины» могут представлять серьезную угрозу для жителей Средиземья, так как их укусы содержат смертельный яд. В связи с этим, власти Шира призвали жителей к осторожности и рекомендовали избегать посещения пещер Мории. В настоящее время, ученые продолжают изучение «Пауков-гоблинов», чтобы определить их популяцию и разработать меры по защите населения.	2025-03-20 10:28:29.234776+00	0	2	uchenye-otkryli-novyi-vid-paukov-466509	t	f		\N
288	Эльфы выиграли чемпионат по стрельбе	Эльфы из Лихолесья одержали убедительную победу на ежегодном чемпионате по стрельбе из лука, который проходил в городе Эсгарот. Эльфийский лучник Леголас в очередной раз подтвердил свой высокий класс, поразив все мишени и установив новый рекорд соревнований. Второе место занял представитель гномов Гимли, а третье место досталось человеку по имени Бард. Чемпионат по стрельбе из лука является одним из самых популярных спортивных мероприятий в Средиземье, в котором принимают участие представители всех рас. В этом году, соревнования прошли на высоком уровне и собрали большое количество зрителей. Победа эльфов стала еще одним подтверждением их превосходства в искусстве стрельбы из лука.	2025-03-20 10:28:29.238341+00	0	3	elfy-vyigrali-chempionat-po-strelbe-466509	t	f		\N
20	Жабы открыли кафе	В городе Селтьяднарнес жабы открыли кафе. Посетители довольны.!!!!!!!	2023-10-20 13:00:00+01	247	6	20-zhaby-otkryli-kafe	t	t	articles/2025/03/16/55.webp	\N
27	Цапли открыли школу искусств	В городе Селтьяднарнес цапли открыли школу искусств. Ученики довольны.	2023-10-27 13:00:00+01	261	6	27-tsapli-otkryli-shkolu-iskusstv	t	t	\N	\N
48	Ибисы открыли музыкальную школу	В парке Хабнарфьордюр ибисы открыли музыкальную школу. Ученики довольны.	2023-11-17 12:00:00+00	266	6	48-ibisy-otkryli-muzykalnuyu-shkolu	t	t		\N
261	Assassin’s Creed Shadows официально на Mac: цена, поддержка контроллеров и требования	Assassin's Creed Shadows — новая глава в знаменитой серии от Ubisoft — теперь доступна в App Store для устройств Mac с чипами M1 и новее. Игра адаптирована для использования игровых контроллеров, обеспечивая удобство и погружение в игровой процесс.\r\n\r\nОсобенности игры:\r\nДва главных героя: игроки смогут управлять Наоэ, искусной шиноби, и Ясуке, легендарным самураем. Эти персонажи предлагают уникальные стили игры: скрытность и ловкость Наоэ контрастируют с мощью и точностью Ясуке.\r\n\r\nОткрытый мир феодальной Японии: игра предлагает исследовать разнообразные локации — от величественных замков и оживленных портов до тихих святынь и опустошенных войной земель. Динамическая смена сезонов и погодных условий добавляет глубину и реализм в игровой мир.\r\n\r\nИндивидуальная настройка: игроки могут создавать собственную лигу шиноби, настраивать убежище и вербовать союзников с уникальными способностями для выполнения миссий.	2025-03-20 10:10:35.355964+00	1	10	temp-022394d4-21c3-4170-9ca2-18f1b9c34360	t	f	articles/2025/03/20/e90bd2b888535d078a455b1bcd439f04.jpg	\N
316	Гридо открыл пивоварню	Гридо, гангстер с планеты Кессель, открыл пивоварню, где варит пиво по древним рецептам. Его напитки стали популярными среди жителей галактики и туристов.	2025-03-20 10:28:29.358928+00	0	11	grido-otkryl-pivovarniu-466509	t	f		\N
317	Квай-Гон Джинн стал гидом по галактике	Квай-Гон Джинн, джедай с планеты Корусант, стал гидом по галактике, предлагая туры по самым интересным местам. Его знания и опыт делают его лучшим проводником для туристов.	2025-03-20 10:28:29.362747+00	0	11	kvai-gon-dzhinn-stal-gidom-po-galaktike-466509	t	f		\N
318	Палпатин открыл тематический парк	Император Палпатин открыл тематический парк на планете Корусант, где посетители могут почувствовать себя настоящими ситхами. Аттракционы и шоу привлекают тысячи туристов ежедневно.	2025-03-20 10:28:29.371553+00	0	11	palpatin-otkryl-tematicheskii-park-466509	t	f		\N
319	Падме Амидала стала чемпионкой по фехтованию	Падме Амидала, сенатор с планеты Набу, стала чемпионкой по фехтованию, победив всех соперников на турнире в Корусанте. Ее мастерство и храбрость впечатлили всех зрителей.	2025-03-20 10:28:29.384052+00	0	3	padme-amidala-stala-chempionkoi-po-fekht-466509	t	f		\N
320	Гоблины изобрели телефон	В глубинах Мордора группа гоблинов представила первое устройство связи, основанное на орочьих криках. В отличие от обычных телефонов, здесь сообщения передаются по цепочке громогласных орков, что обеспечивает надежность, но снижает скорость передачи. Первым позвонил Саурон, но, к сожалению, из-за шумов на линии никто не разобрал, что он сказал. Однако все решили, что это было нечто зловещее, и начали паниковать. Новый телефон уже вызвал волну инноваций: урук-хай работают над версией с факсом, а эльфы разрабатывают альтернативу, основанную на магических пузырях. Ожидается, что первый международный звонок будет совершен в следующем тысячелетии.	2025-03-20 10:28:29.389718+00	0	1	gobliny-izobreli-telefon-466509	t	f		\N
381	Лучшие наушники с шумоподавлением для работы	Я никогда не осознавал, насколько шумно вокруг, пока однажды не забыл дома мои наушники с шумоподавлением. Щелканье клавиатур, разговоры коллег, гул кондиционеров и даже тихое жужжание компьютерных вентиляторов вдруг стали невыносимыми. Этот опыт показал, как сильно хорошие наушники помогают сосредоточиться — и в офисах с открытым пространством, и дома, где отвлекают члены семьи, питомцы и шум соседей.\r\n\r\nПротестировав десятки моделей за несколько лет (и став своего рода экспертом в области шумоподавления), я понял: лучшие наушники для работы не просто блокируют окружающий шум — они создают личное пространство для концентрации. Они должны быть комфортными в течение всего дня, долго работать от аккумулятора, обеспечивать чёткую связь на звонках и качественное звучание музыки или подкастов.	2025-03-24 20:30:48.200912+00	1	1	luchshie-naushniki-s-shumopodavleniem-dl-848248	t	f	articles/2025/03/24/best-noise-cancelling-headphones-for-work.jpg	\N
262	Количество пользователей Telegram достигло 1 миллиарда человек	Мессенджер Telegram стремительно набирает популярность и уже является для многих пользователей основным источником общения, получения информации и развлекательного контента.\r\n\r\nСоздатель Telegram Павел Дуров сообщил о достижении значительного результата.\r\n\r\nЧто известно\r\nВ своем Telegram-канале Дуров сообщил, что количество активных пользователей мессенджера достигло 1 миллиарда человек!\r\n\r\nСреди аналогичных приложений больше всего человек заходит в WeChat, но эта платформа исключительно внутрикитайская, а среди международных мессенджеров лидером остается WhatsApp с его 3 млрд пользователей, о котором Дуров отзывается как о “дешевой имитации Telegram”.	2025-03-20 10:12:21.872149+00	1	1	temp-af91c481-c4b4-4612-9fe4-cfa9acdeadb7	t	f	articles/2025/03/20/1f1e52a86cc26b348dc1835ba407d4ae.jpg	\N
385	Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay	Ранее на этой неделе Apple выпустила iOS 18.4. Свежая версия ПО принесла владельцам iPhone приоритетные уведомления, новые эмодзи, три ряда иконок на главном экране CarPlay и некоторые другие изменения. Но вместе с этим, судя по многочисленным сообщениям пользователей, сделала невыносимым взаимодействие с CarPlay.\r\n\r\nЧто известно\r\nВладельцы iPhone, уже обновившиеся до iOS 18.4, пишут на Reddit и в X (Twitter), что сталкиваются с широким спектром ошибок при использовании CarPlay. Пока у одних пользователей перестал отображаться текст "Now Playing", другие жалуются, что беспроводное соединение постоянно "отваливается". Так, один водитель Honda говорит, что «требуется подключать и отключать более 5 раз или перезапускать автомобиль, чтобы CarPlay подключился». Единственным рабочим решением он назвал возвращение к проводному подключению.\r\n\r\nПроблемы, похоже, затронули автомобили разных брендов, включая Honda, Mazda, VW, Audi и Ford. Пользователи говорят, что они пробовали разные вещи, чтобы исправить ситуацию, включая повторное сопряжение телефонов с автомобилями, перезагрузку iPhone и перезапуск автомобилей. Одним это помогло, другим нет. Но похоже, что до тех пор, пока Apple не починит то, что сломалось в iOS 18.4, полноценного функционирования приложения не будет.	2025-04-04 18:40:49.038386+01	8	12	vladeltsy-iphone-zhaluiutsia-chto-ios-18-788449	t	t	articles/2025/04/04/4ab90657ba7387b099cba63e56f38409.jpg	8
290	В Гондоре прошли выборы короля	В Гондоре состоялись выборы нового короля. По результатам голосования, королем Гондора стал Арагорн, потомок Исилдура. Арагорн был избран большинством голосов, получив поддержку как знати, так и простого народа. Он пообещал править мудро и справедливо, а также защищать границы Гондора от врагов. Инаугурация Арагорна состоится в ближайшее время, и он официально вступит в должность короля Гондора. Это событие имеет большое значение для всего Средиземья, так как Гондор является одним из самых могущественных королевств.	2025-03-20 10:28:29.244467+00	0	5	v-gondore-proshli-vybory-korolia-466509	t	f		\N
292	В Бри открылась школа волшебства	В Бри состоялось открытие школы волшебства, в которой будут обучаться дети со всего Средиземья. В школе преподают опытные маги, которые передают свои знания ученикам. Обучение в школе волшебства является платным, но талантливые дети из малообеспеченных семей могут получить грант на обучение. Открытие школы волшебства вызвало большой интерес у жителей Средиземья, и многие родители уже записали своих детей на обучение. В школе дети будут изучать различные виды магии, а также научатся защищаться от темных сил. Ожидается, что выпускники школы волшебства станут известными магами и будут помогать людям.	2025-03-20 10:28:29.251164+00	0	7	v-bri-otkrylas-shkola-volshebstva-466509	t	f		\N
330	Домовые эльфы устроили забастовку	Домовые эльфы устроили забастовку, требуя повышения зарплаты и улучшения условий труда. Их лидер, Добби, заявил, что домовые эльфы больше не будут терпеть несправедливость.	2025-03-20 10:28:29.451321+00	0	5	domovye-elfy-ustroili-zabastovku-466509	t	f		\N
296	В Шире обнаружен новый вид картошки	В Шире, в огороде фермера Перегрина Тука, был обнаружен новый вид картошки, который получил название «Тук-картошка». Этот сорт отличается своими гигантскими размерами и необычным вкусом, напоминающим жареное мясо. «Тук-картошка» уже стала популярной среди хоббитов, которые используют ее для приготовления различных блюд, таких как картофельное пюре с грибами, картофельные оладьи и картофельный суп. Фермер Тук надеется, что его открытие принесет пользу всем жителям Шира и сделает их жизнь еще более вкусной и разнообразной.	2025-03-20 10:28:29.266874+00	0	2	v-shire-obnaruzhen-novyi-vid-kartoshki-466509	t	f		\N
298	В Гондоре изобрели новый вид оружия	В Гондоре, в секретных лабораториях Минас Тирита, был изобретен новый вид оружия, который получил название «Огненный меч». Это оружие способно генерировать мощный огненный луч, который может уничтожать врагов на большом расстоянии. «Огненный меч» уже поступил на вооружение гондорской армии и успешно используется в боях с орками и другими врагами. Изобретение нового оружия стало важным шагом в укреплении обороноспособности Гондора и усилении его влияния в Средиземье.	2025-03-20 10:28:29.276404+00	0	1	v-gondore-izobreli-novyi-vid-oruzhiia-466509	t	f		\N
299	В Мордоре открылась школа для орков	В Мордоре, по инициативе Саурона, открылась школа для орков, в которой они будут обучаться различным наукам и искусствам. В школе орки будут изучать военное дело, кузнечное дело, а также основы магии и колдовства. Саурон надеется, что открытие школы поможет ему создать армию образованных и умелых орков, которые будут служить ему еще более эффективно. Однако, открытие школы для орков вызвало обеспокоенность у жителей других регионов Средиземья, которые опасаются, что это может привести к усилению военной мощи Мордора.	2025-03-20 10:28:29.282758+00	0	7	v-mordore-otkrylas-shkola-dlia-orkov-466509	t	f		\N
383	Hisense презентует новый Mini LED телевизор U7Q Pro с поддержкой Matter для Европы	Hisense анонсировала новую модель телевизора U7Q Pro для европейского рынка. Это 4K телевизор с технологией Mini LED, который входит в линейку 2025 года. Он будет доступен в размерах от 55 до 100 дюймов.\r\n\r\nЧто известно\r\nНовинка имеет ряд интересных особенностей, включая частоту обновления 165 Гц, поддержку Dolby Vision IQ, HDR10+, IMAX Enhanced и режим Filmmaker.\r\n\r\nU7Q Pro оборудован Full Array Local Dimming с до 1,248 зонами, обеспечивает яркость до 2,000 нит при пиковых значениях и 500 нит в стандартном режиме. Телевизор также имеет контрастность 5,000:1 и 90% покрытие цветового пространства DCI-P3. Для геймеров доступны функции, как 288 Гц Game Accelerator, Game Bar и поддержка AMD FreeSync Premium Pro.	2025-04-04 10:58:21.708631+01	7	1	hisense-prezentuet-novyi-mini-led-televi-760701	t	f	articles/2025/04/04/f1d3686c2013fa0e11ffe4e59ae370de.jpg	10
303	В Мордоре открылся университет для орков	В Мордоре, по инициативе Саурона, открылся университет для орков, в котором они будут обучаться различным наукам, таким как математика, физика, химия и другие. Саурон надеется, что открытие университета поможет ему создать армию образованных и умных орков, которые будут служить ему еще более эффективно. Однако, открытие университета для орков вызвало обеспокоенность у жителей других регионов Средиземья, которые опасаются, что это может привести к усилению влияния темных сил.	2025-03-20 10:28:29.303695+00	0	7	v-mordore-otkrylsia-universitet-dlia-ork-466509	t	f		\N
305	Люк Скайуокер открыл академию джедаев	Люк Скайуокер открыл академию джедаев на планете Явин IV. Ученики изучают искусство использования силы и световых мечей. Родители довольны успехами своих детей, хотя некоторые жалуются на частые пожары во время тренировок.	2025-03-20 10:28:29.310765+00	0	7	liuk-skaiuoker-otkryl-akademiiu-dzhedaev-466509	t	f		\N
306	Хан Соло стал чемпионом по гонкам на спидерах	Хан Соло неожиданно для всех стал чемпионом галактического турнира по гонкам на спидерах. Его мастерство и скорость поразили всех, включая Дарта Вейдера, который признал поражение и подарил Хану новый корабль в знак уважения.	2025-03-20 10:28:29.315016+00	0	3	khan-solo-stal-chempionom-po-gonkam-na-s-466509	t	f		\N
307	R2-D2 изобрел летающий дроид	R2-D2 изобрел летающий дроид, который работает на магической энергии. Теперь дроиды могут путешествовать по всей галактике, не покидая своих кораблей.	2025-03-20 10:28:29.318772+00	0	1	r2-d2-izobrel-letaiushchii-droid-466509	t	f		\N
308	Принцесса Лея открыла секрет вечной молодости	Принцесса Лея открыла секрет вечной молодости, который заключается в ежедневном употреблении энергии силы и пении древних песен. Ученые из Альдераана уже начали исследования, чтобы подтвердить это открытие.	2025-03-20 10:28:29.323482+00	0	2	printsessa-leia-otkryla-sekret-vechnoi-m-466509	t	f		\N
314	Дарт Мол открыл фастфуд	Дарт Мол открыл сеть фастфудов на планете Корусант, где подают бургеры из местных ингредиентов и картофель фри. Его рестораны стали популярными среди туристов и местных жителей.	2025-03-20 10:28:29.348857+00	0	11	dart-mol-otkryl-fastfud-466509	t	f		\N
315	Анакин Скайуокер стал чемпионом по серфингу	Анакин Скайуокер, джедай с планеты Татуин, стал чемпионом по серфингу на волнах озера Набу. Его грация и мастерство покорили сердца зрителей и судей.	2025-03-20 10:28:29.35492+00	0	3	anakin-skaiuoker-stal-chempionom-po-serf-466509	t	f		\N
321	Йоды открыли вечную энергию	Учёные с планеты Дагоба совершили величайший прорыв в энергетике, открыв источник бесконечной энергии — концентрированную Силу. Однако эксперимент пошёл не по плану: когда Йода попытался подключить генератор, вся лаборатория исчезла в гиперпространстве. Исследователи уверены, что где-то в другой галактике внезапно появился новый научный центр. Теперь проблема в том, как туда добраться и включить рубильник. Между тем, магистры Ордена джедаев уверяют, что технология может работать, но ею нельзя злоупотреблять — иначе Вселенная получит перегрев ядра. Дарта Вейдера пока не нашли, но есть подозрения, что он уже строит конкурирующую станцию.	2025-03-20 10:28:29.397533+00	0	2	iody-otkryli-vechnuiu-energiiu-466509	t	f		\N
324	Гондор создал первый автомобиль	Инженеры Гондора представили первую в Средиземье самодвижущуюся повозку, работающую на драконьем дыхании. Испытания показали, что транспорт способен разгоняться до скорости летающего назгула, но требует постоянной подпитки пламенем. Главной проблемой остаётся экология: после каждого заезда остаётся пепелище, а водители жалуются на обугленные волосы. Тем не менее, власти Минас-Тирита надеются внедрить технологию в повседневную жизнь, заменив конные упряжки. Орки уже заявили, что рассматривают возможность создания собственного аналога, работающего на магме и гоблинских криках.	2025-03-20 10:28:29.411064+00	0	1	gondor-sozdal-pervyi-avtomobil-466509	t	f		\N
325	Гарри Поттер открыл школу магии	Гарри Поттер открыл школу магии для молодых волшебников в Хогвартсе. Ученики уже освоили заклинания для призыва огня и левитации. Родители в восторге от успехов своих детей, хотя некоторые жалуются на частые пожары в школьном дворе.	2025-03-20 10:28:29.416828+00	0	7	garri-potter-otkryl-shkolu-magii-466509	t	f		\N
326	Гермиона стала чемпионкой по шахматам	Гермиона Грейнджер неожиданно для всех стала чемпионкой магического турнира по шахматам. Ее стратегия и тактика поразили всех, включая Северуса Снегга, который признал поражение и подарил Гермионе волшебную палочку в знак уважения.	2025-03-20 10:28:29.421851+00	0	3	germiona-stala-chempionkoi-po-shakhmatam-466509	t	f		\N
327	Рон Уизли летающий метроном	Рон Уизли изобрел летающий метроном, который работает на магической энергии. Теперь волшебники могут путешествовать по всему магическому миру, не покидая своих домов.	2025-03-20 10:28:29.427797+00	0	1	ron-uizli-letaiushchii-metronom-466509	t	f		\N
386	VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер	Компания Playside Studios в сотрудничестве с Meta и Firaxis Games раскрыла дату релиза VR-версии стратегии Sid Meier’s Civilization VII.\r\n\r\nЧто известно\r\nПользователи гарнитур смешанной реальности Meta Quest 3 и 3S смогут погрузиться в управление империями и государствами 10 апреля 2025 года.\r\n\r\nИнтересно, что разработчики предусмотрели режим дополненной реальности, в котором виртуальная карта и все объекты на ней проецируются на стол, а игрок может рассматривать ее с разных сторон, перемещаясь вокруг стола и отдавая приказы при помощи контроллеров.\r\n\r\nКроме того, исторические личности при переговорах будут появляться перед игроком в полный рост и предлагать свои условия.\r\n\r\nПри запуске VR-версии Sid Meier’s Civilization VII геймер окажется в специально созданном виртуальном музее, который позволит рассмотреть предметы из разных эпох и определиться с выбором нации.	2025-04-04 19:25:30.862593+01	10	1	vr-versiia-strategii-sid-meiers-civiliza-791130	t	f	articles/2025/04/04/9a9a53a8d0c793f571dd1003dd643f9f.jpg	8
265	CATL и Nio создадут единый стандарт быстрой замены батарей	Китайский гигант производства аккумуляторов CATL объединился с Nio, чтобы стандартизировать технологию замены батарей в электромобилях. Идея не нова - Nio уже сотрудничает с Chery и Geely, а в китайских городах давно работают такси BAIC со сменными аккумуляторами. Но теперь к делу подключился один из крупнейших производителей батарей в мире.г	2025-03-20 10:18:48.461788+00	1	1	temp-e8d48b0b-1b89-468f-8f32-470cbefedfab	t	f	articles/2025/03/20/ыыыыывава_zDvhTsR.jpg	\N
353	Седрик стал чемпионом по скачкам	Седрик Диггори, студент Хогвартса, стал чемпионом по скачкам, победив на турнире в Хогсмиде. Его мастерство и скорость впечатлили всех зрителей и судей.	2025-03-20 11:15:24.592675+00	1	3	sedrik-stal-chempionom-po-skachkam-469324	t	f		\N
380	Yamaha выпустила гибридный мотоцикл за 1680 долларов	Yamaha представила FZ-S Fi Hybrid - первый в Индии мотоцикл в классе до 150 куб. см с гибридной технологией. Она призвана улучшить динамические характеристики и топливную экономичность.\r\n\r\nЧто известно\r\nВнешне FZ-S Fi Hybrid почти не отличается от обычной версии, но есть несколько нюансов. Например, обновленная графика на обтекателях и новое расположение передних поворотников - теперь они расположены на боковых панелях бака. Мотоцикл доступен в двух цветах: Racing Blue и Cyan Metallic Grey.	2025-03-20 11:21:57.522729+00	9	12	yamaha-vypustila-gibridnyi-mototsikl-za--469717	t	f	articles/2025/03/20/b6b402002aa19dde30a0d5ddf4575dbc.jpg	\N
352	Макгонагалл открыла библиотеку	Минерва Макгонагалл открыла библиотеку в Хогвартсе, где собраны древние магические манускрипты и книги. Ее библиотека стала популярным местом для ученых и студентов.	2025-03-20 11:15:24.588276+00	2	7	makgonagall-otkryla-biblioteku-469324	t	f		\N
350	Чо Чанг стала чемпионкой по фехтованию	Чо Чанг, студентка Хогвартса, стала чемпионкой по фехтованию, победив всех соперников на турнире в Хогсмиде. Ее мастерство и храбрость впечатлили всех зрителей.	2025-03-20 11:15:24.580114+00	1	3	cho-chang-stala-chempionkoi-po-fekhtovan-469324	t	f		\N
351	Хагрид стал тренером по квиддичу	Рубеус Хагрид стал тренером по квиддичу в Хогвартсе. Его команда уже одержала несколько побед, благодаря его стратегии и тактике.	2025-03-20 11:15:24.583946+00	0	3	khagrid-stal-trenerom-po-kviddichu-469324	t	f		\N
356	Фродо стал шеф-поваром	Фродо Бэггинс открыл ресторан в Хоббитоне, где подают блюда из грибов и лембарского хлеба. Его кулинарные таланты привлекли внимание гурманов со всего Средиземья.	2025-03-20 11:17:12.259297+00	0	6	frodo-stal-shef-povarom-469432	t	t		\N
357	Чубакка стал тренером по йоге	Чубакка открыл студию йоги на планете Кашиик, где он учит всех желающих искусству релаксации и медитации. Его уроки пользуются огромной популярностью среди местных жителей и туристов.	2025-03-20 11:17:12.267955+00	0	6	chubakka-stal-trenerom-po-ioge-469432	t	t		\N
371	В Ривенделле открылся музей эльфийской магии	В Ривенделле состоялось открытие музея эльфийской магии, в котором представлены различные артефакты, связанные с магией эльфов. В музее можно увидеть волшебные палочки, амулеты, зелья и другие предметы, которые использовались эльфами для совершения магических ритуалов. Открытие музея эльфийской магии вызвало большой интерес у жителей Средиземья, которые интересуются историей и культурой эльфов.	2025-03-20 11:18:35.836647+00	1	4	v-rivendelle-otkrylsia-muzei-elfiiskoi-m-469515	t	f		\N
368	В Мордоре открылся первый парк аттракционов	В Мордоре, в самом сердце тьмы, открылся первый в мире парк аттракционов, посвященный темным силам. Парк, получивший название «Мордорлэнд», предлагает посетителям уникальную возможность погрузиться в атмосферу ужаса и мрака. Здесь можно прокатиться на американских горках, стилизованных под колесницы назгулов, посетить комнату страха, где обитают орки-людоеды, и попробовать блюда из меню, которое включает в себя жареных пауков и эльфийское мясо. «Мордорлэнд» уже стал популярным местом отдыха среди орков и других обитателей Мордора. Однако, открытие парка вызвало обеспокоенность у жителей других регионов Средиземья, которые опасаются, что это может привести к усилению влияния темных сил.	2025-03-20 11:18:35.820577+00	0	4	v-mordore-otkrylsia-pervyi-park-attrakts-469515	t	f		\N
369	В Ривенделле прошел конкурс красоты среди эльфов	В Ривенделле состоялся ежегодный конкурс красоты среди эльфов. В конкурсе приняли участие самые красивые эльфийки со всего Средиземья. Победительницей конкурса стала эльфийка Галадриэль, которая поразила всех своей красотой и грацией. Галадриэль получила корону королевы эльфов и право представлять Ривенделл на международном конкурсе красоты, который пройдет в Валиноре. Конкурс красоты в Ривенделле является важным культурным событием, которое подчеркивает эстетические ценности эльфов и способствует укреплению дружбы между различными эльфийскими народами.	2025-03-20 11:18:35.827985+00	0	4	v-rivendelle-proshel-konkurs-krasoty-sre-469515	t	f		\N
370	В Шире прошел фестиваль пирогов	В Шире состоялся ежегодный фестиваль пирогов, в котором приняли участие хоббиты со всего Шира. На фестивале были представлены самые разнообразные пироги, от яблочных до мясных. Победителем фестиваля стал хоббит Бильбо Бэггинс, который испек самый вкусный и оригинальный пирог. Фестиваль пирогов является важным культурным событием в жизни Шира, которое способствует укреплению традиций и развитию кулинарного искусства среди хоббитов.	2025-03-20 11:18:35.831841+00	0	4	v-shire-proshel-festival-pirogov-469515	t	f		\N
372	В Шире прошел конкурс на самый большой овощ	В Шире состоялся ежегодный конкурс на самый большой овощ, в котором приняли участие хоббиты со всего Шира. На конкурсе были представлены самые разнообразные овощи, от тыкв до кабачков. Победителем конкурса стал хоббит Сэм Гэмджи, который вырастил самую большую тыкву в Шире. Конкурс на самый большой овощ является важным культурным событием в жизни Шира, которое способствует развитию сельского хозяйства и укреплению традиций среди хоббитов.	2025-03-20 11:18:35.841062+00	0	4	v-shire-proshel-konkurs-na-samyi-bolshoi-469515	t	f		\N
373	Дарт Вейдер устроил фестиваль моды	Дарт Вейдер устроил первый в истории фестиваль моды, где представлены коллекции доспехов и оружия. Модельеры из разных уголков галактики приехали, чтобы увидеть это уникальное шоу.	2025-03-20 11:18:35.848044+00	0	4	dart-veider-ustroil-festival-mody-469515	t	f		\N
374	Чубакка стал поп-звездой	Чубакка неожиданно стал поп-звездой, выпустив альбом с песнями о своем корабле. Его концерты собирают тысячи фанатов, которые приходят, чтобы услышать его уникальный голос и забавные тексты.	2025-03-20 11:18:35.85344+00	0	4	chubakka-stal-pop-zvezdoi-469515	t	f		\N
375	Орки открыли ресторан	В самом сердце Мордора открылся первый в истории орочий ресторан высокой кухни. Меню включает жареную балроговину, суп из эльфийских слёз и фирменный коктейль 'Пылающий Око'. Повара, обученные Сауроном лично, обещают, что блюда будут не только вкусными, но и опасными для жизни. Первые посетители уже оценили экстремальный гастрономический опыт, хотя не все смогли его пережить. В связи с этим ресторан предлагает скидку на обеды для некромантов, готовых оживлять недовольных клиентов. Слухи о новом кулинарном чуде уже дошли до Гондора, и Арагорн лично выразил намерение отправить туда разведку.	2025-03-20 11:18:35.859461+00	0	4	orki-otkryli-restoran-469515	t	f		\N
376	Малфой устроил фестиваль моды	Драко Малфой устроил первый в истории фестиваль моды, где представлены коллекции магических мантий и аксессуаров. Модельеры из разных уголков магического мира приехали, чтобы увидеть это уникальное шоу.	2025-03-20 11:18:35.864684+00	2	4	malfoi-ustroil-festival-mody-469515	t	f		\N
361	В Шире открылся медицинский центр	В Шире состоялось открытие нового медицинского центра, который будет оказывать помощь жителям региона. В центре работают высококвалифицированные врачи, которые используют самые современные методы лечения. Открытие медицинского центра стало важным событием для жителей Шира, так как теперь они смогут получать качественную медицинскую помощь, не выезжая за пределы региона. В центре можно получить консультации различных специалистов, а также пройти обследование и лечение. В ближайшее время планируется расширение спектра услуг, предоставляемых медицинским центром.	2025-03-20 11:17:12.287501+00	0	6	v-shire-otkrylsia-meditsinskii-tsentr-469432	t	t		\N
362	Оби-Ван Кеноби стал шеф-поваром	Оби-Ван Кеноби открыл ресторан на Татуине, где подают блюда из местных ингредиентов. Его кулинарные таланты привлекли внимание гурманов со всей галактики.	2025-03-20 11:17:12.290988+00	0	6	obi-van-kenobi-stal-shef-povarom-469432	t	t		\N
363	Йода стал тренером по йоге	Йода открыл студию йоги на планете Дагоба, где он учит всех желающих искусству релаксации и медитации. Его уроки пользуются огромной популярностью среди местных жителей и туристов.	2025-03-20 11:17:12.2949+00	0	6	ioda-stal-trenerom-po-ioge-469432	t	t		\N
364	Джедаи запустили фитнес-программу	Орден Джедаев представил новую фитнес-программу 'Сила в каждом', рассчитанную на всех желающих овладеть телекинезом и реактивной гибкостью. Основной курс включает упражнения по левитации, паркуру в невесомости и контроль дыхания в условиях глубокого вакуума. Инструкторы обещают, что через месяц тренировок ученики смогут уворачиваться от бластерных выстрелов, а через год — парить в воздухе, удерживая в руках чашку кофе. Однако эксперты предупреждают: для достижения успеха необходимо отказаться от Тёмной стороны и сахара. Дарта Вейдера пока не пригласили в программу, опасаясь слишком быстрого снижения массы.	2025-03-20 11:17:12.299113+00	0	6	dzhedai-zapustili-fitnes-programmu-469432	t	t		\N
366	Снейп стал тренером по йоге	Снейп открыл студию йоги в Хогвартсе, где он учит всех желающих искусству релаксации и медитации. Его уроки пользуются огромной популярностью среди студентов и преподавателей.	2025-03-20 11:17:12.313872+00	0	6	sneip-stal-trenerom-po-ioge-469432	t	t		\N
365	Дамблдор стал шеф-поваром	Альбус Дамблдор открыл ресторан в Хогсмиде, где подают блюда из магических ингредиентов. Его кулинарные таланты привлекли внимание гурманов со всего магического мира.	2025-03-20 11:17:12.306017+00	1	6	dambldor-stal-shef-povarom-469432	t	t		\N
382	Функция измерения давления в Apple Watch задерживается из-за технических проблем, - Bloomberg	Apple все еще работает над внедрением мониторинга артериального давления в Apple Watch, но тестирование этой функции идет не так гладко, как хотелось бы. Об этом сообщает журналист Bloomberg Марк Гурман (Mark Gurman) в своем последнем выпуске Power On.\r\n\r\nЧто известно\r\nГурман (Gurman) впервые сообщил о планах Apple по измерению давления еще в 2022 году. В ноябре 2023 года он отмечал, что начальная версия функции не сможет показывать точный уровень давления, но Apple работала над обновлением, которое позволит это сделать в будущем.\r\n\r\nОжидалось, что эта функция появится в Apple Watch Series 10, но этого не произошло. По последним данным Гурмана, Apple разрабатывает технологию, которая будет отслеживать изменения давления и предупреждать пользователя о возможной гипертонии. В случае такого оповещения владелец Apple Watch сможет проконсультироваться с врачом для более точной диагностики.	2025-03-24 20:45:02.379733+00	16	1	funktsiia-izmereniia-davleniia-v-apple-w-849102	t	f	articles/2025/03/24/apple-watch-series-10-gold-titanium.webp	1
367	Флитвик открыл спа-салон	Филиус Флитвик открыл спа-салон в Хогвартсе, где предлагает услуги по релаксации и омоложению. Его салон стал популярным среди студентов и преподавателей.	2025-03-20 11:17:12.321525+00	1	6	flitvik-otkryl-spa-salon-469432	t	t		\N
\.


--
-- Data for Name: Articles_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Articles_tags" (id, article_id, tag_id) FROM stdin;
1	1	1
2	1	2
3	2	3
4	2	4
5	3	5
6	3	6
7	4	8
8	4	7
9	5	9
10	5	10
11	6	11
12	6	12
13	7	13
14	7	14
15	8	1
16	8	2
17	8	3
18	9	4
19	9	5
20	9	6
21	10	8
22	10	9
23	10	7
24	11	10
25	11	11
26	11	12
27	12	13
28	12	14
29	12	15
30	13	1
31	13	2
32	13	3
33	13	4
34	14	8
35	14	5
36	14	6
37	14	7
38	15	9
39	15	10
40	15	11
41	15	12
42	16	16
43	16	13
44	16	14
45	16	15
46	17	17
47	17	18
48	17	19
49	17	20
50	18	1
51	18	2
52	18	3
53	18	4
54	19	8
55	19	5
56	19	6
57	19	7
58	20	9
59	20	10
60	20	11
61	20	12
62	21	16
63	21	13
64	21	14
65	21	15
66	22	17
67	22	18
68	22	19
69	22	20
70	23	1
71	23	2
72	23	3
73	23	4
74	24	8
75	24	5
76	24	6
77	24	7
78	25	9
79	25	10
80	25	11
81	25	12
82	26	16
83	26	13
84	26	14
85	26	15
86	27	17
87	27	18
88	27	19
89	27	20
90	28	1
91	28	2
92	28	3
93	28	4
94	29	8
95	29	5
96	29	6
97	29	7
98	30	9
99	30	10
100	30	11
101	30	12
102	31	16
103	31	13
104	31	14
105	31	15
106	32	1
107	32	2
108	32	3
109	32	4
110	33	8
111	33	5
112	33	6
113	33	7
114	34	9
115	34	10
116	34	11
117	34	12
118	35	16
119	35	13
120	35	14
121	35	15
122	36	1
123	36	2
124	36	3
125	36	4
126	37	8
127	37	5
128	37	6
129	37	7
130	38	9
131	38	10
132	38	11
133	38	12
134	39	16
135	39	13
136	39	14
137	39	15
138	40	1
139	40	2
140	40	3
141	40	4
142	41	8
143	41	5
144	41	6
145	41	7
146	42	9
147	42	10
148	42	11
149	42	12
150	43	16
151	43	13
152	43	14
153	43	15
154	44	1
155	44	2
156	44	3
157	44	4
158	45	8
159	45	5
160	45	6
161	45	7
162	46	9
163	46	10
164	46	11
165	46	12
166	47	16
167	47	13
168	47	14
169	47	15
170	48	1
171	48	2
172	48	3
173	48	4
174	49	8
175	49	5
176	49	6
177	49	7
178	50	9
179	50	10
180	50	11
181	50	12
182	51	16
183	51	13
184	51	14
185	51	15
186	52	1
187	52	2
188	52	3
189	52	4
190	53	8
191	53	5
192	53	6
193	53	7
194	54	9
195	54	10
196	54	11
197	54	12
198	55	16
199	55	13
200	55	14
201	55	15
202	56	1
203	56	2
204	56	3
205	56	4
206	57	8
207	57	5
208	57	6
209	57	7
210	58	9
211	58	10
212	58	11
213	58	12
214	59	16
215	59	13
216	59	14
217	59	15
218	60	1
219	60	2
220	60	3
221	60	4
222	61	8
223	61	5
224	61	6
225	61	7
950	380	16
951	380	1
952	380	3
953	380	5
230	63	16
231	63	13
232	63	14
233	63	15
234	64	1
235	64	2
236	64	3
237	64	4
238	65	8
239	65	5
240	65	6
241	65	7
242	66	9
243	66	10
244	66	11
245	66	12
246	67	16
247	67	13
248	67	14
249	67	15
250	68	1
251	68	2
252	68	3
253	68	4
954	381	1
955	381	4
956	381	29
962	383	1
258	70	9
259	70	10
260	70	11
261	70	12
262	71	16
263	71	13
264	71	14
265	71	15
266	72	1
267	72	2
268	72	3
269	72	4
270	73	8
271	73	5
272	73	6
273	73	7
274	74	9
275	74	10
276	74	11
277	74	12
278	75	16
279	75	13
280	75	14
281	75	15
963	383	2
964	383	3
974	387	1
975	387	3
286	77	8
287	77	5
288	77	6
289	77	7
290	78	9
291	78	10
292	78	11
293	78	12
294	79	16
295	79	13
296	79	14
297	79	15
298	80	1
299	80	2
300	80	3
301	80	4
302	81	8
303	81	5
304	81	6
305	81	7
306	82	9
307	82	10
308	82	11
309	82	12
976	387	4
977	387	17
314	84	1
315	84	2
316	84	3
317	84	4
318	85	8
319	85	5
320	85	6
321	85	7
322	86	9
323	86	10
324	86	11
325	86	12
326	87	16
327	87	13
328	87	14
329	87	15
330	88	1
331	88	2
332	88	3
333	88	4
334	89	8
335	89	5
336	89	6
337	89	7
957	382	2
958	382	4
959	382	7
960	382	11
342	91	16
343	91	13
344	91	14
345	91	15
346	92	1
347	92	2
348	92	3
349	92	4
350	93	8
351	93	5
352	93	6
353	93	7
354	94	9
355	94	10
356	94	11
357	94	12
358	95	16
359	95	13
360	95	14
361	95	15
362	96	1
363	96	2
364	96	3
365	96	4
961	382	29
965	384	16
966	384	2
967	384	14
370	98	9
371	98	10
372	98	11
373	98	12
374	99	16
375	99	13
376	99	14
377	99	15
378	100	1
379	100	2
380	100	3
381	100	4
382	102	1
383	102	8
384	102	13
385	102	14
386	102	19
393	104	1
394	104	2
395	104	4
396	104	15
397	104	16
398	105	3
399	105	4
400	105	11
401	105	12
402	106	7
403	106	8
404	106	14
405	106	18
406	107	7
407	107	8
408	107	14
409	107	20
410	108	1
411	108	9
412	108	10
413	108	14
426	112	5
427	112	7
428	112	14
429	112	17
434	114	7
435	114	14
436	114	15
437	114	17
438	115	17
439	115	14
440	115	7
441	115	15
442	116	5
443	116	14
444	116	7
445	116	11
446	117	13
447	117	3
448	117	4
449	117	7
450	118	7
451	118	8
452	118	14
453	118	20
454	119	5
455	119	14
456	119	7
457	119	11
462	121	7
463	121	8
464	121	14
465	121	13
466	122	1
467	122	2
468	122	16
469	123	3
470	123	4
471	123	15
472	124	5
473	124	7
474	124	8
475	125	7
476	125	8
477	125	22
478	126	9
479	126	10
480	126	14
968	385	1
969	385	2
970	385	3
484	128	13
485	128	14
486	128	29
487	129	3
488	129	4
489	129	29
490	130	7
491	130	28
492	130	14
493	130	19
498	132	3
499	132	27
500	132	25
501	101	10
502	101	11
503	101	12
504	101	6
505	20	1
506	20	13
507	265	1
508	265	4
509	265	12
510	265	7
511	262	2
512	262	3
513	262	5
514	261	24
515	261	13
516	261	14
517	261	15
518	266	8
519	266	13
520	266	14
521	267	1
522	267	2
523	267	5
524	267	7
525	268	1
526	268	2
527	268	15
528	268	16
529	269	3
530	269	4
531	269	11
532	269	12
541	272	1
542	272	9
543	272	10
544	272	14
557	276	5
558	276	17
559	276	14
560	276	7
565	278	17
566	278	14
567	278	7
568	278	15
569	279	17
570	279	14
571	279	7
572	279	15
573	280	5
574	280	14
575	280	7
576	280	11
577	281	13
578	281	3
579	281	4
580	281	7
585	283	5
586	283	14
587	283	7
588	283	11
597	286	1
598	286	2
599	286	16
600	287	3
601	287	4
602	287	15
603	288	5
604	288	7
605	288	8
609	290	9
610	290	10
611	290	14
615	292	13
616	292	14
617	292	29
629	296	3
630	296	27
631	296	25
971	386	33
972	386	3
973	386	4
635	298	1
636	298	24
637	298	26
638	299	13
639	299	31
640	299	23
641	299	21
650	302	1
651	302	16
652	302	26
653	303	13
654	303	31
655	303	23
656	303	21
660	305	13
661	305	14
662	305	8
663	306	5
664	306	1
665	306	2
666	306	7
667	307	1
668	307	2
669	307	16
670	307	15
671	308	3
672	308	4
673	308	11
674	308	12
691	314	19
692	314	14
693	314	17
694	314	7
695	315	5
696	315	17
697	315	14
698	315	7
699	316	19
700	316	14
701	316	17
702	316	7
703	317	17
704	317	14
705	317	7
706	317	15
707	318	17
708	318	14
709	318	7
710	318	15
711	319	5
712	319	14
713	319	7
714	319	11
715	320	1
716	320	2
717	320	3
718	320	13
719	321	3
720	321	4
721	321	15
722	321	1
731	324	1
732	324	16
733	324	2
734	324	15
735	325	13
736	325	29
737	325	14
738	325	8
739	326	5
740	326	1
741	326	2
742	326	7
743	327	1
744	327	2
745	327	16
746	327	15
755	330	9
756	330	10
757	330	14
758	330	1
767	333	14
768	333	17
769	333	7
770	334	5
771	334	17
772	334	14
773	334	7
774	335	14
775	335	17
776	335	7
777	336	17
778	336	14
779	336	7
780	336	15
781	337	17
782	337	14
783	337	7
784	337	15
833	350	5
834	350	14
835	350	7
836	350	11
837	351	5
838	351	14
839	351	7
840	351	11
841	352	13
842	352	3
843	352	4
844	352	7
845	353	5
846	353	14
847	353	7
848	353	11
857	356	11
858	356	19
859	356	14
860	356	7
861	357	11
862	357	12
863	357	14
864	357	17
873	360	11
874	360	12
875	360	14
876	360	17
877	361	11
878	361	12
879	361	14
880	362	11
881	362	19
882	362	14
883	362	7
884	363	11
885	363	12
886	363	14
887	363	17
888	364	11
889	364	5
890	364	13
891	364	15
892	365	11
893	365	19
894	365	14
895	365	7
896	366	11
897	366	12
898	366	14
899	366	17
900	367	11
901	367	12
902	367	14
903	367	17
904	368	7
905	368	33
906	368	23
907	368	31
908	369	7
909	369	30
910	369	32
911	370	7
912	370	19
913	370	27
914	370	25
915	371	7
916	371	29
917	371	30
918	371	32
919	372	7
920	372	27
921	372	25
922	373	7
923	373	18
924	373	8
925	373	14
926	374	7
927	374	20
928	374	8
929	374	14
930	375	7
931	375	19
932	375	14
933	375	12
934	376	7
935	376	18
936	376	8
937	376	14
\.


--
-- Data for Name: Categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Categories" (id, name) FROM stdin;
1	Технологии
2	Наука
3	Спорт
4	Культура
5	Политика
6	Здоровье
7	Образование
8	Путешествия
10	Мистика
11	Туризм
12	Автомобили
\.


--
-- Data for Name: CommentLikes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CommentLikes" (id, is_like, created_at, comment_id, user_id) FROM stdin;
1	f	2025-04-10 00:17:37.184975+01	4	8
2	t	2025-04-10 00:17:46.380898+01	6	8
3	f	2025-04-10 00:17:49.70788+01	3	8
6	t	2025-04-10 00:19:02.702652+01	4	10
7	f	2025-04-10 00:19:05.057911+01	3	10
8	f	2025-04-10 00:20:42.195786+01	9	8
9	f	2025-04-10 00:20:43.245231+01	10	8
10	t	2025-04-10 00:22:59.600512+01	11	8
11	t	2025-04-10 09:06:23.899939+01	2	8
12	f	2025-04-10 09:46:09.047264+01	12	8
13	t	2025-04-10 09:47:01.413067+01	13	8
14	f	2025-04-10 09:55:40.799608+01	6	10
15	t	2025-04-10 09:55:44.692833+01	7	10
16	t	2025-04-10 09:55:46.561905+01	9	10
17	t	2025-04-10 09:55:48.795577+01	10	10
18	t	2025-04-10 20:59:34.515359+01	14	8
19	t	2025-04-10 21:49:07.180225+01	15	8
20	f	2025-04-10 21:49:47.557963+01	17	8
21	t	2025-04-10 21:49:48.472734+01	16	8
22	t	2025-04-10 21:49:49.137285+01	18	8
\.


--
-- Data for Name: Comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Comments" (id, content, created_at, updated_at, article_id, user_id, parent_id) FROM stdin;
1	приветствую	2025-04-09 22:01:05.721704+01	2025-04-09 22:01:05.721716+01	387	8	\N
2	привет	2025-04-09 22:01:46.731987+01	2025-04-09 22:01:46.731994+01	386	8	\N
3	👋 приветствую	2025-04-09 22:02:21.824923+01	2025-04-09 22:02:21.824929+01	387	10	\N
4	привет	2025-04-09 23:10:09.247159+01	2025-04-09 23:10:09.24717+01	387	10	\N
5	фффф	2025-04-09 23:32:49.075112+01	2025-04-09 23:32:49.075123+01	367	10	\N
6	ррр	2025-04-09 23:44:05.927485+01	2025-04-09 23:44:05.927496+01	387	10	\N
7	ghbdtn	2025-04-10 00:18:19.436819+01	2025-04-10 00:18:19.436826+01	387	10	6
8	Как дела?	2025-04-10 00:19:29.132981+01	2025-04-10 00:19:29.132988+01	387	10	1
9	хорошо🎲	2025-04-10 00:20:05.246772+01	2025-04-10 00:20:05.246779+01	387	8	7
10	Я спать	2025-04-10 00:20:25.562325+01	2025-04-10 00:20:25.562331+01	387	8	9
11	пока	2025-04-10 00:22:53.293481+01	2025-04-10 00:22:53.293489+01	387	8	4
12	👋 пока	2025-04-10 09:06:46.126922+01	2025-04-10 09:06:46.126928+01	386	8	2
13	Hello! 🌐	2025-04-10 09:46:57.647004+01	2025-04-10 09:46:57.647016+01	383	8	\N
14	Комментарий 🎲	2025-04-10 20:59:29.363497+01	2025-04-10 20:59:29.363504+01	386	8	12
15	ghbdt	2025-04-10 21:49:02.826954+01	2025-04-10 21:49:02.82696+01	385	8	\N
16	asasasas	2025-04-10 21:49:12.658335+01	2025-04-10 21:49:12.658341+01	385	8	15
17	dssdsdsd	2025-04-10 21:49:27.239124+01	2025-04-10 21:49:27.23913+01	385	8	16
18	sdasdsadasd	2025-04-10 21:49:36.207585+01	2025-04-10 21:49:36.20759+01	385	8	17
\.


--
-- Data for Name: Favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Favorites" (id, created_at, article_id, user_id) FROM stdin;
94	2025-04-10 09:57:56.482392+01	387	10
95	2025-04-10 20:59:49.617587+01	386	8
71	2025-04-03 20:46:28.911424+01	371	10
74	2025-04-03 20:46:37.712634+01	380	10
75	2025-04-03 21:02:56.904227+01	382	10
76	2025-04-03 21:03:03.07532+01	381	10
77	2025-04-04 10:54:03.324455+01	381	8
79	2025-04-04 10:54:24.238441+01	265	8
80	2025-04-04 11:38:37.825217+01	380	8
82	2025-04-04 14:39:06.20212+01	383	8
83	2025-04-04 19:17:45.337624+01	385	8
87	2025-04-05 00:02:48.339845+01	384	8
88	2025-04-05 00:35:13.631129+01	385	10
89	2025-04-07 18:36:04.141324+01	382	8
91	2025-04-07 22:22:20.381316+01	386	10
92	2025-04-08 13:24:36.468268+01	261	10
\.


--
-- Data for Name: Likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Likes" (id, created_at, article_id, user_id) FROM stdin;
111	2025-04-03 21:02:57.757481+01	382	10
113	2025-04-03 21:03:01.950992+01	381	10
114	2025-04-03 21:03:04.912177+01	380	10
115	2025-04-04 10:54:24.552808+01	265	8
116	2025-04-04 11:10:37.227569+01	382	2
118	2025-04-04 11:38:38.570594+01	380	8
120	2025-04-04 14:39:04.595184+01	383	8
121	2025-04-04 19:17:44.272195+01	385	8
124	2025-04-05 00:02:49.980139+01	384	8
125	2025-04-05 00:03:32.047016+01	352	8
126	2025-04-05 00:35:12.660088+01	385	10
127	2025-04-05 00:35:40.376706+01	383	10
128	2025-04-05 00:35:41.6805+01	384	10
131	2025-04-07 18:36:07.417371+01	382	8
132	2025-04-07 22:22:19.706888+01	386	10
133	2025-04-09 09:56:57.389327+01	387	2
134	2025-04-10 00:23:45.878966+01	350	8
135	2025-04-10 20:59:50.81876+01	386	8
\.


--
-- Data for Name: Tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Tags" (id, name) FROM stdin;
1	Технологии
2	Инновации
3	Наука
4	Исследования
5	Спорт
6	Футбол
7	Культура
8	Искусство
9	Политика
10	Экономика
11	Здоровье
12	Медицина
13	Образование
14	Общество
15	Экология
16	Транспорт
17	Туризм
18	Мода
19	Еда
20	Музыка
21	Саурон
22	История
23	Мордор
24	Оружие
25	Хоббиты
26	Гондор
27	Шир
28	Традиции
29	Магия
30	Эльфы
31	Орки
32	Ривенделл
33	Развлечения
\.


--
-- Data for Name: account_emailaddress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_emailaddress (id, email, verified, "primary", user_id) FROM stdin;
5	ljosa@inbox.lv	t	t	8
7	giruckisaleksejs@gmail.com	t	t	10
8	aleksej.it.gir@gmail.com	f	f	2
9	giruckisaleksejs@gmail.com	f	f	8
\.


--
-- Data for Name: account_emailconfirmation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_emailconfirmation (id, created, sent, key, email_address_id) FROM stdin;
\.


--
-- Data for Name: article; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.article (id, title, content, publication_date, views, category_id, slug, is_active) FROM stdin;
\.


--
-- Data for Name: article_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.article_tag (id, article_id, tag_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	Moderator
2	Superuser
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	25
2	1	26
3	1	27
4	2	1
5	2	2
6	2	3
7	2	4
8	2	5
9	2	6
10	2	7
11	2	8
12	2	9
13	2	10
14	2	11
15	2	12
16	2	13
17	2	14
18	2	15
19	2	16
20	2	17
21	2	18
22	2	19
23	2	20
24	2	21
25	2	22
26	2	23
27	2	24
28	2	25
29	2	26
30	2	27
31	2	28
32	2	29
33	2	30
34	2	31
35	2	32
36	2	33
37	2	34
38	2	35
39	2	36
40	2	37
41	2	38
42	2	39
43	2	40
44	2	41
45	2	42
46	2	43
47	2	44
48	2	45
49	2	46
50	2	47
51	2	48
52	2	49
53	2	50
54	2	51
55	2	52
56	2	53
57	2	54
58	2	55
59	2	56
60	2	57
61	2	58
62	2	59
63	2	60
64	2	61
65	2	62
66	2	63
67	2	64
68	2	65
69	2	66
70	2	67
71	2	68
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add article	7	add_article
26	Can change article	7	change_article
27	Can delete article	7	delete_article
28	Can view article	7	view_article
29	Can add category	8	add_category
30	Can change category	8	change_category
31	Can delete category	8	delete_category
32	Can view category	8	view_category
33	Can add tag	9	add_tag
34	Can change tag	9	change_tag
35	Can delete tag	9	delete_tag
36	Can view tag	9	view_tag
37	Can add Лайк	10	add_like
38	Can change Лайк	10	change_like
39	Can delete Лайк	10	delete_like
40	Can view Лайк	10	view_like
41	Can add Избранное	11	add_favorite
42	Can change Избранное	11	change_favorite
43	Can delete Избранное	11	delete_favorite
44	Can view Избранное	11	view_favorite
45	Can add site	12	add_site
46	Can change site	12	change_site
47	Can delete site	12	delete_site
48	Can view site	12	view_site
49	Can add email address	13	add_emailaddress
50	Can change email address	13	change_emailaddress
51	Can delete email address	13	delete_emailaddress
52	Can view email address	13	view_emailaddress
53	Can add email confirmation	14	add_emailconfirmation
54	Can change email confirmation	14	change_emailconfirmation
55	Can delete email confirmation	14	delete_emailconfirmation
56	Can view email confirmation	14	view_emailconfirmation
57	Can add social account	15	add_socialaccount
58	Can change social account	15	change_socialaccount
59	Can delete social account	15	delete_socialaccount
60	Can view social account	15	view_socialaccount
61	Can add social application	16	add_socialapp
62	Can change social application	16	change_socialapp
63	Can delete social application	16	delete_socialapp
64	Can view social application	16	view_socialapp
65	Can add social application token	17	add_socialtoken
66	Can change social application token	17	change_socialtoken
67	Can delete social application token	17	delete_socialtoken
68	Can view social application token	17	view_socialtoken
69	Can add Профиль	18	add_profile
70	Can change Профиль	18	change_profile
71	Can delete Профиль	18	delete_profile
72	Can view Профиль	18	view_profile
73	Can add Активность пользователя	19	add_useractivity
74	Can change Активность пользователя	19	change_useractivity
75	Can delete Активность пользователя	19	delete_useractivity
76	Can view Активность пользователя	19	view_useractivity
77	Can add Комментарий	20	add_comment
78	Can change Комментарий	20	change_comment
79	Can delete Комментарий	20	delete_comment
80	Can view Комментарий	20	view_comment
81	Can add Оценка комментария	21	add_commentlike
82	Can change Оценка комментария	21	change_commentlike
83	Can delete Оценка комментария	21	delete_commentlike
84	Can view Оценка комментария	21	view_commentlike
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$870000$1juSC7BaIeETKBj7gSlFM1$E1qL25UZPvzrJbz0GY1nPfWOrhDeUDeJgXk5Lv3vO6o=	2025-02-20 21:17:38.659315+00	t	admin				t	t	2025-02-20 19:32:34.942197+00
2	pbkdf2_sha256$870000$OoYFUepoj2E6O0fUNrPZ10$s3BEqo56oAjC5eBbhktFBv4OkOgkscTlzIg03uxlMCA=	2025-04-09 09:50:52.880182+01	t	admin_Alek	Aleksejs	Giruckis	aleksej.it.gir@gmail.com	t	t	2025-02-24 18:25:43+00
10	!PCAGcjCHU7eeIjaALGk3Jj9JGBoDsmKdLk4DULWD	2025-04-10 09:55:16.426639+01	f	AleksejsGir	Aleksej	Giruckis	giruckisaleksejs@gmail.com	f	t	2025-04-03 20:42:42.362423+01
8	pbkdf2_sha256$870000$pw8udv8XiFskIjTToUzsqe$t/lQ9dx6bSQb55tc7Pu5VoHLGlNI0oxHG0krv05FyDo=	2025-04-28 17:07:27.780909+01	f	ljosa@inbox.lv	Linda	Girucka	ljosa@inbox.lv	f	t	2025-04-03 18:54:39.890368+01
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
1	2	1
2	2	2
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
1	2	1
2	2	2
3	2	3
4	2	4
5	2	5
6	2	6
7	2	7
8	2	8
9	2	9
10	2	10
11	2	11
12	2	12
13	2	13
14	2	14
15	2	15
16	2	16
17	2	17
18	2	18
19	2	19
20	2	20
21	2	21
22	2	22
23	2	23
24	2	24
25	2	25
26	2	26
27	2	27
28	2	28
29	2	29
30	2	30
31	2	31
32	2	32
33	2	33
34	2	34
35	2	35
36	2	36
37	2	37
38	2	38
39	2	39
40	2	40
41	2	41
42	2	42
43	2	43
44	2	44
45	2	45
46	2	46
47	2	47
48	2	48
49	2	49
50	2	50
51	2	51
52	2	52
53	2	53
54	2	54
55	2	55
56	2	56
57	2	57
58	2	58
59	2	59
60	2	60
61	2	61
62	2	62
63	2	63
64	2	64
65	2	65
66	2	66
67	2	67
68	2	68
69	2	69
70	2	70
71	2	71
72	2	72
73	2	73
74	2	74
75	2	75
76	2	76
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, name) FROM stdin;
1	Путешествия
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2025-03-20 11:04:40.480283+00	277	Гимли открыл пивоварню	3		7	2
2	2025-03-20 11:04:40.48031+00	275	Саруман открыл фастфуд	3		7	2
3	2025-03-20 11:04:40.480319+00	331	Дамблдор стал шеф-поваром	3		7	2
4	2025-03-20 11:04:40.480326+00	323	Джедаи запустили фитнес-программу	3		7	2
5	2025-03-20 11:04:40.480332+00	313	Йода стал тренером по йоге	3		7	2
6	2025-03-20 11:04:40.480338+00	312	Оби-Ван Кеноби стал шеф-поваром	3		7	2
7	2025-03-20 11:04:40.480344+00	274	Чубакка стал тренером по йоге	3		7	2
8	2025-03-20 11:04:40.480349+00	110	Чубакка стал тренером по йоге	3		7	2
9	2025-03-20 11:04:40.480355+00	109	Фродо стал шеф-поваром	3		7	2
10	2025-03-20 11:04:40.480361+00	90	Олени открыли ресторан	3		7	2
11	2025-03-20 11:16:53.813566+00	113	Гимли открыл пивоварню	3		7	2
12	2025-03-20 11:16:53.8136+00	111	Саруман открыл фастфуд	3		7	2
13	2025-03-20 11:16:53.81361+00	354	Флитвик открыл спа-салон	3		7	2
14	2025-03-20 11:16:53.813617+00	349	Дамблдор стал шеф-поваром	3		7	2
15	2025-03-20 11:16:53.813623+00	348	Джедаи запустили фитнес-программу	3		7	2
16	2025-03-20 11:16:53.81363+00	347	Йода стал тренером по йоге	3		7	2
17	2025-03-20 11:16:53.813636+00	346	Оби-Ван Кеноби стал шеф-поваром	3		7	2
18	2025-03-20 11:16:53.813642+00	345	Чубакка стал тренером по йоге	3		7	2
19	2025-03-20 11:16:53.813648+00	332	Снейп стал тренером по йоге	3		7	2
20	2025-03-20 11:16:53.813654+00	291	В Шире открылся медицинский центр	3		7	2
21	2025-03-20 11:16:53.81366+00	284	Элронд открыл спа-салон	3		7	2
22	2025-03-20 11:16:53.813666+00	273	Фродо стал шеф-поваром	3		7	2
23	2025-03-20 11:16:53.813672+00	127	В Шире открылся медицинский центр	3		7	2
24	2025-03-20 11:16:53.813678+00	120	Элронд открыл спа-салон	3		7	2
25	2025-03-20 11:16:53.813683+00	103	Йода стал чемпионом по шахматам	3		7	2
26	2025-03-20 11:16:53.813689+00	97	Кроты открыли ресторан	3		7	2
27	2025-03-20 11:16:53.813694+00	83	Лебеди открыли спа-салон	3		7	2
28	2025-03-20 11:16:53.8137+00	76	Ежики открыли музей	3		7	2
29	2025-03-20 11:16:53.813706+00	69	Совы открыли библиотеку	3		7	2
30	2025-03-20 11:16:53.813712+00	62	Гуси открыли фитнес-центр	3		7	2
31	2025-03-20 11:17:52.168208+00	355	Джинни стала писателем	3		7	2
32	2025-03-20 11:17:52.168251+00	341	Джинни и Гарри стали комиками	3		7	2
33	2025-03-20 11:17:52.16827+00	329	Невилл стал поп-звездой	3		7	2
34	2025-03-20 11:17:52.168285+00	328	Малфой устроил фестиваль моды	3		7	2
35	2025-03-20 11:17:52.1683+00	322	Орки открыли ресторан	3		7	2
36	2025-03-20 11:17:52.168315+00	310	Чубакка стал поп-звездой	3		7	2
37	2025-03-20 11:17:52.168329+00	309	Дарт Вейдер устроил фестиваль моды	3		7	2
38	2025-03-20 11:17:52.168344+00	304	В Шире прошел конкурс на самый большой овощ	3		7	2
39	2025-03-20 11:17:52.168358+00	301	В Ривенделле открылся музей эльфийской магии	3		7	2
40	2025-03-20 11:17:52.168387+00	300	В Шире прошел фестиваль пирогов	3		7	2
41	2025-03-20 11:17:52.168404+00	297	В Ривенделле прошел конкурс красоты среди эльфов	3		7	2
42	2025-03-20 11:17:52.168419+00	295	В Мордоре открылся первый парк аттракционов	3		7	2
43	2025-03-20 11:17:52.168432+00	294	В Шире прошёл фестиваль хоббитов	3		7	2
44	2025-03-20 11:17:52.168446+00	289	В Ривенделле открылась выставка картин	3		7	2
45	2025-03-20 11:17:52.168461+00	285	Бильбо стал писателем	3		7	2
46	2025-03-20 11:17:52.168476+00	282	Мерри и Пиппин стали комиками	3		7	2
47	2025-03-20 11:17:52.168489+00	271	Голлум стал поп-звездой	3		7	2
48	2025-03-20 11:17:52.168503+00	270	Орки устроили фестиваль моды	3		7	2
49	2025-03-20 11:17:52.168517+00	133	В Ривенделле прошел конкурс красоты среди эльфов	3		7	2
50	2025-03-20 11:17:52.168532+00	131	В Мордоре открылся первый парк аттракционов	3		7	2
51	2025-03-27 20:21:31.780751+00	1	127.0.0.1:8000	2	[{"changed": {"fields": ["Domain name", "Display name"]}}]	12	2
52	2025-03-27 20:33:53.014173+00	3	Alek_Gir	3		4	2
53	2025-03-27 20:33:53.014203+00	5	aleksej.it.gir@gmail.com	3		4	2
54	2025-03-27 20:33:53.01422+00	4	Linda_Gir	3		4	2
55	2025-03-31 21:26:51.253872+01	359	Гимли открыл пивоварню	2	[{"changed": {"fields": ["\\u0410\\u0432\\u0442\\u043e\\u0440"]}}]	7	2
56	2025-03-31 21:29:23.205293+01	382	Функция измерения давления в Apple Watch задерживается из-за технических проблем, - Bloomberg	2	[{"changed": {"fields": ["\\u0410\\u0432\\u0442\\u043e\\u0440"]}}]	7	2
57	2025-04-03 17:31:48.691343+01	1	Aleksejs Django App	1	[{"added": {}}]	16	2
58	2025-04-03 18:41:53.963182+01	1	Moderator	1	[{"added": {}}]	3	2
59	2025-04-03 18:43:10.339046+01	2	Superuser	1	[{"added": {}}]	3	2
60	2025-04-03 18:44:11.746686+01	1	Moderator	2	[]	3	2
61	2025-04-03 18:44:22.307294+01	2	Superuser	2	[]	3	2
62	2025-04-03 18:47:29.376135+01	6	giruckisaleksejs@gmail.com	3		4	2
63	2025-04-03 18:47:29.376157+01	7	ljosa@inbox.lv	3		4	2
64	2025-04-03 18:49:23.83422+01	1	127.0.0.1:8000	2	[{"changed": {"fields": ["Display name"]}}]	12	2
65	2025-04-03 19:17:07.375043+01	1	Aleksejs Django App	2	[{"changed": {"fields": ["Secret key"]}}]	16	2
66	2025-04-03 19:59:21.784924+01	1	Aleksejs Django App	2	[{"changed": {"fields": ["Secret key"]}}]	16	2
67	2025-04-03 20:38:31.744259+01	1	Aleksejs Django App	3		16	2
68	2025-04-03 20:39:40.627503+01	2	Alek django app	1	[{"added": {}}]	16	2
69	2025-04-03 20:42:29.397971+01	9	giruckisaleksejs@gmail.com	3		4	2
70	2025-04-04 11:00:44.435926+01	2	admin_Alek	2	[{"changed": {"fields": ["First name", "Last name", "Email address", "Groups", "User permissions"]}}]	4	2
71	2025-04-04 19:43:27.7741+01	12	Автомобили	1	[{"added": {}}]	8	2
72	2025-04-04 20:59:00.734682+01	9	Всячина	3		8	2
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	news	article
8	news	category
9	news	tag
10	news	like
11	news	favorite
12	sites	site
13	account	emailaddress
14	account	emailconfirmation
15	socialaccount	socialaccount
16	socialaccount	socialapp
17	socialaccount	socialtoken
18	users	profile
19	users	useractivity
20	news	comment
21	news	commentlike
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-02-10 18:55:02.975599+00
2	auth	0001_initial	2025-02-10 18:55:03.005064+00
3	admin	0001_initial	2025-02-10 18:55:03.012998+00
4	admin	0002_logentry_remove_auto_add	2025-02-10 18:55:03.015848+00
5	admin	0003_logentry_add_action_flag_choices	2025-02-10 18:55:03.019135+00
6	contenttypes	0002_remove_content_type_name	2025-02-10 18:55:03.028793+00
7	auth	0002_alter_permission_name_max_length	2025-02-10 18:55:03.031938+00
8	auth	0003_alter_user_email_max_length	2025-02-10 18:55:03.034954+00
9	auth	0004_alter_user_username_opts	2025-02-10 18:55:03.037623+00
10	auth	0005_alter_user_last_login_null	2025-02-10 18:55:03.040755+00
11	auth	0006_require_contenttypes_0002	2025-02-10 18:55:03.041212+00
12	auth	0007_alter_validators_add_error_messages	2025-02-10 18:55:03.044094+00
13	auth	0008_alter_user_username_max_length	2025-02-10 18:55:03.049718+00
14	auth	0009_alter_user_last_name_max_length	2025-02-10 18:55:03.053278+00
15	auth	0010_alter_group_name_max_length	2025-02-10 18:55:03.056726+00
16	auth	0011_update_proxy_permissions	2025-02-10 18:55:03.05959+00
17	auth	0012_alter_user_first_name_max_length	2025-02-10 18:55:03.062564+00
18	news	0001_initial	2025-02-10 18:55:03.065442+00
19	news	0002_category_tag_article_category_article_tags	2025-02-10 18:55:03.080524+00
20	news	0003_article_slug	2025-02-10 18:55:03.083667+00
21	sessions	0001_initial	2025-02-10 18:55:03.087124+00
22	news	0004_article_is_active	2025-02-20 19:32:05.962587+00
23	news	0005_alter_article_options_alter_category_options_and_more	2025-02-24 18:39:11.792899+00
24	news	0006_alter_category_options_article_status	2025-02-24 18:39:11.797925+00
25	news	0007_like	2025-03-05 18:39:02.001551+00
26	news	0008_favorite	2025-03-06 10:57:49.566127+00
27	news	0009_article_image	2025-03-12 20:21:03.017608+00
28	news	0010_alter_article_options_article_author_alter_tag_name	2025-03-24 20:03:27.253884+00
29	account	0001_initial	2025-03-27 20:15:48.409398+00
30	account	0002_email_max_length	2025-03-27 20:15:48.415358+00
31	account	0003_alter_emailaddress_create_unique_verified_email	2025-03-27 20:15:48.423913+00
32	account	0004_alter_emailaddress_drop_unique_email	2025-03-27 20:15:48.439245+00
33	account	0005_emailaddress_idx_upper_email	2025-03-27 20:15:48.444924+00
34	account	0006_emailaddress_lower	2025-03-27 20:15:48.45271+00
35	account	0007_emailaddress_idx_email	2025-03-27 20:15:48.461955+00
36	account	0008_emailaddress_unique_primary_email_fixup	2025-03-27 20:15:48.46927+00
37	account	0009_emailaddress_unique_primary_email	2025-03-27 20:15:48.474205+00
38	sites	0001_initial	2025-03-27 20:15:48.47696+00
39	sites	0002_alter_domain_unique	2025-03-27 20:15:48.479345+00
40	socialaccount	0001_initial	2025-03-27 20:15:48.514056+00
41	socialaccount	0002_token_max_lengths	2025-03-27 20:15:48.52478+00
42	socialaccount	0003_extra_data_default_dict	2025-03-27 20:15:48.529434+00
43	socialaccount	0004_app_provider_id_settings	2025-03-27 20:15:48.542166+00
44	socialaccount	0005_socialtoken_nullable_app	2025-03-27 20:15:48.552023+00
45	socialaccount	0006_alter_socialaccount_extra_data	2025-03-27 20:15:48.558864+00
46	news	0011_alter_favorite_unique_together_and_more	2025-03-31 22:13:07.741755+01
47	news	0012_alter_favorite_user_alter_like_user_and_more	2025-03-31 22:23:52.426738+01
48	users	0001_initial	2025-04-04 10:43:02.90336+01
49	news	0013_comment	2025-04-09 21:39:46.036254+01
50	news	0014_comment_parent_commentlike	2025-04-09 22:32:06.131562+01
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
v5jwxga1vj5g2r0cox4cbil4x9kx5u2k	.eJxVjDsOwjAQBe_iGllZxZtsKOk5g2XvhwSQLeVTIe4OkVJA-2bmvVxM2zrGbdE5TuLODtzpd8uJH1p2IPdUbtVzLes8Zb8r_qCLv1bR5-Vw_w7GtIzfOhEMfcMWqBlaRsABWyVQ5GCdoGBAIoUOg2nmjsEM-iAEzGSG4t4fzHw39A:1tlCI6:L40mhBrpqS2p91gK0IdL8dzpYSp0GpvRbj8pTeHS6s8	2025-03-06 19:32:58.912544+00
xn3h3p3p0nkd6nj0l676eys1hcxh514l	.eJxVjDsOwjAQBe_iGllZxZtsKOk5g2XvhwSQLeVTIe4OkVJA-2bmvVxM2zrGbdE5TuLODtzpd8uJH1p2IPdUbtVzLes8Zb8r_qCLv1bR5-Vw_w7GtIzfOhEMfcMWqBlaRsABWyVQ5GCdoGBAIoUOg2nmjsEM-iAEzGSG4t4fzHw39A:1tlCrv:qOvRWhgcCHlHANaOJAKiAmSWw_y31Lkg1riBcUQSHM4	2025-03-06 20:09:59.050951+00
xu6vosy4wmsarr5gxwfmz7lhc5wprifq	.eJyrVsrJzE5NiU8sKslMzkktVrKKNjQw0DGx0DE01jE20bE00jE0MNSxtIjVUUpLLMsvyixJRVVsGFsLAOT7FTY:1tspcU:lE90n3U8OSd12CdPauhGRr_8Jg07FtriywUS_blsykM	2025-03-27 20:57:34.327465+00
shaw8ggboy4rdkq0kel8licvq4kad5jn	.eJxVjDsOwjAQBe_iGllZxZtsKOk5g2XvhwSQLeVTIe4OkVJA-2bmvVxM2zrGbdE5TuLODtzpd8uJH1p2IPdUbtVzLes8Zb8r_qCLv1bR5-Vw_w7GtIzfOhEMfcMWqBlaRsABWyVQ5GCdoGBAIoUOg2nmjsEM-iAEzGSG4t4fzHw39A:1tlDvO:MS_RyNE-Asj32Axk8sYVvk_BIHCBy8R6Qu7LAEErBfw	2025-03-06 21:17:38.673022+00
64fa4ggfdl3qapk35j8btshyps4m6ttd	.eJxVjEEOwiAQRe_C2pDOAFJcuu8ZCDOAVA1NSrsy3l1JutC__O_lvYQP-1b83tLq5yguAsXp96PAj1Q7iPdQb4vkpW7rTLIr8qBNTktMz-vh_gVKaKVno8nWQFaIA3Km8J1mTcbllBkgacsjWH1mjgmcIQA3KIWEo2XFKN4f-eI4GQ:1tmdAK:v4Q_dUvDWMG22CyBaYbiB5hFEO2OZ3_U5aWIcTHfuos	2025-03-10 18:26:52.149181+00
xyhyp4rub8c26pwjqvhdyje8hxx88us8	.eJxVjEEOwiAQRe_C2pDOAFJcuu8ZCDOAVA1NSrsy3l1JutC__O_lvYQP-1b83tLq5yguAsXp96PAj1Q7iPdQb4vkpW7rTLIr8qBNTktMz-vh_gVKaKVno8nWQFaIA3Km8J1mTcbllBkgacsjWH1mjgmcIQA3KIWEo2XFKN4f-eI4GQ:1tmdRh:IyyGUyB-RtNEE0wtOlTzxAsQKLkc82hqu8wb60ajWSo	2025-03-10 18:44:49.210934+00
684fgpcy20sykp8s1jhcct8bajbo6vgq	.eJxVjEEOwiAQRe_C2pDOAFJcuu8ZCDOAVA1NSrsy3l1JutC__O_lvYQP-1b83tLq5yguAsXp96PAj1Q7iPdQb4vkpW7rTLIr8qBNTktMz-vh_gVKaKVno8nWQFaIA3Km8J1mTcbllBkgacsjWH1mjgmcIQA3KIWEo2XFKN4f-eI4GQ:1tnESR:8jd8uHYRz6E0EnFq00G9xLNL1VtT6-0fVgfdiSiuejE	2025-03-12 10:16:03.128641+00
pkrcajvmrqoq6rxyq6qguccsm6a94mhb	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0PuX:TaL9pIrKgdYXb1bCojF1K_cjZ4OcHJF14UQao7ZDFeI	2025-04-17 20:07:33.787866+01
sxv5skb0cxn67m4a7s04dm4xxdka3tjv	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0Ndg:qfS8vXEA3lTbe4aU_F7jbIxl7MYVXiFfwykqEU7BvsQ	2025-04-17 17:42:00.794679+01
q76f84trras5tdo2mzdem37dg6rl11mx	.eJyrVsrJzE5NiU8sKslMzkktVrKKNjQ21jE0NtKxNNexBJLGOkYGOoYGhjpmRrE6SmmJZflFmSWpqBqMQGrMjHTMLGNrAfUBF70:1ttrdf:X2TY-8O_e3zmOMjh3rRp1I8p1ZONDi5-FnrdsfFjL28	2025-03-30 18:19:03.203955+01
njcon4kcrxb6kkuqadhab5tp2jon6f82	eyJsaWtlZF9hcnRpY2xlcyI6WzEzLDE4LDI4LDM0LDEsOTMsOTgsOTYsOTcsMjMsMTYsOSwzNywzMCwyLDk5LDEwMF19:1tpvyk:IvzZwvMhv12o2J7POz4ntklsklH1aXRAcwedhMzipSg	2025-03-19 21:08:34.03646+00
5e3ubd2p98p6h92kw06s2dtok8mm8xjo	.eJyrVsrJzE5NiU8sKslMzkktVrKKtjTSsbTUMbGI1VFKSyzLL8osSUWWNjfWgagwNQUq0rE01zE0MIitBQB4-hYt:1tqHp9:0DQ8H7xfY8Qv2owVQfGad2XG4vTzMQEjaQphcprCeeM	2025-03-20 20:28:07.704849+00
rhopc2858dvmus7udoa6gmvpcf354hzs	.eJxVkMFugzAQRP9lzwjZLGDDqelvVBFazCLcOjjCJkkV5d-LUy7cVjOzb0f7BDLGr3PsaI0Tz9EaitbP3YXj5IcA7dcT_mdo4Uoh3P0yQAYUoZWqLFFqKVSOUgglMAO-kHVb1H37QB927v0jdzd4nTN4n-jWwEtnE03DQevJ_PCcDHIuyfleLX9ndjvkp0PRz33rgJooTBtnrGShqNdGM_XVgI3m2kg0DY6qMM0guUepVKNFURd1RXVTI8qReBTCYGkSNHAI6R_8uNrlF1qRwc3ynYeOlq2D4_Qi1FWGWp1ff-e7b4g:1u2yvI:2-cOE-BCBwhar8XklWDjFc19ytWZ6aGBTuQQ5ao63Rw	2025-04-24 21:54:56.122891+01
36qvb1z7y95zmfcgfkl8zxq4akz0qfrd	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0P0D:lrG2WEKpI_oL4K4zBhCVGNVqB_jQO_ziYUnqGJtGTUE	2025-04-17 19:09:21.745225+01
yebxxhcc9b4vhbv8m1uxtkokmwdxujc1	.eJyrVsrJzE5NiU8sKslMzkktVrKKNjQwjNVRSkssyy_KLElFl6kFAMhwEYo:1trjZl:aMZiBKx06dBtc3G7PS18oqCri0Gd84BjIKtgp0QiESY	2025-03-24 20:18:13.336906+00
85wjqn332yf0qxn16vgbc7iu9w4xdvjv	.eJyrVsrJzE5NiU8sKslMzkktVrKKNjQ20jEy0DE0NNQxMwJSJkBsqmNpHKujlJZYll-UWZKKotzQMLYWAAUQFY0:1tuHTY:PQMldXgVAVM5CNj_NVq93gR0FQzXk3G4Xv_DKW-5Su4	2025-03-31 21:54:20.024843+01
5nv6g2g8ed406vtatyz4rig3kvuyj0g4	.eJyrVkpLLMsvyixJjU8sKslMzkktVrKKNjQw0LG01LE01rE00jGx0DE11TE31jE21DEy0TG20LE0j9VRysnMTk3Bpsk8thYAWtoYqA:1tqAzR:4PlGiSWb7VYTqTNQhyWhzzq-1-wKq7davArA52deAJA	2025-03-20 13:10:17.784058+00
y8bnc13y57ift0oth280eynfulgldm1b	.eJxVkN1ugzAMhd_F1wgl4SeBq3WvMVXIBKdk_FU4qJuqvvtIxw03lnWO_fnIT0Brl20ODW6hpzl4i8EvczNR6JeOof56wn8PNdyR-bGsHSSAAWqp80wKo0SRKimVyasEaEI_7qM3v2528IwjDUzf_HGLRmqXCV7XBN7nmo1pbXwkl3DSWrQDzdHAcYxyesRM3zOHzenlFPrz2DqheuR-51iltTayM1IotK5tHRpXuM6V1pFDKXRVZgU5q_ZKukJFmTVdrgWSE5IilIk5_oZ-7n79hVq8_gAXumzm:1txu4T:LtuMQhOM4vgJ-IUmWx20Q8lw1aWD68AmrhDHEiM6NNE	2025-04-10 21:43:25.414253+01
wrdp3keeazd75ddlzhrjoo7ckrqey5e4	.eJxVjssOwiAURP-FtSG9PKTt0n2_wBgCl4tFG5qUVhfGf1eSLnSWMycn82LWbetot0KLTYH1TLDDb-cd3inXIdxcvs4c57wuyfOK8H0tfJgDTaed_ROMroxVG3Q0GqIUohEYvftGofK6ixQRgJTBFow6IgaCTnuArpFSeNEalFhfPRI9KVi3rAknKqw_Sy0v7w-kAUBQ:1u19ew:PKpcKYWcfwiKnsrRHNRUSc8iwBOpWEHzHNsYd2XAAIw	2025-04-19 20:58:30.809558+01
4m25e1tz28bievwjekhd5hdw1siizjgk	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0Q4s:scY1N2BOckpVOZP-Ic9V7Ng8ZH6DlsUaCQrMtw8kQXo	2025-04-17 20:18:14.625114+01
3caty9zb5kq4saobf1pzjf2i975qnzm6	.eJxVkM1uxCAMhN_F5wiF8BOSU9vXqKrIEFBoWVgF0m612ndv2OaSmzUz_jzyHdCYtMUy4VYWG4s3WHyK08WWJc0Zxvc7_M8wwhVz_knrDA1ggZH2nAmlOO8Il3TgLWvAXtCHPRo-U8YXH3W6kfANj48GniemLdt18pXWw0nTaL5srAaGUGVyVCPPzGFn8noq-nZsnVAL5mXnsN61yjDJWq205EYPiGiconSYlRrcLLUTjEvROcuZFtgjtZ0RnAu3O6pCs825_sPern79hbF9_AFOzmcq:1tzv0J:2LM2oEuWrvmz-qzkbtCN0QWw6uLRuDMQ0EKk-1iyabo	2025-04-16 11:07:27.75122+01
drwgg6td8fl39aa0n39k34x3j0al92vi	.eJxVjEEOwiAQRe_C2pDOAFJcuu8ZCDOAVA1NSrsy3l1JutC__O_lvYQP-1b83tLq5yguAsXp96PAj1Q7iPdQb4vkpW7rTLIr8qBNTktMz-vh_gVKaKVno8nWQFaIA3Km8J1mTcbllBkgacsjWH1mjgmcIQA3KIWEo2XFKN4f-eI4GQ:1u0Pmc:tmLjBpqjoccs0pecAI1HZiLLQKXjj8UYy32E8VIACCY	2025-04-17 19:59:22.013577+01
4lqex0od086b6p5b0yajxtaws3506hfp	.eJxVkM1ugzAQhN9lzwhhDP7h1PQ1qggtZhFuHTvCJkkV5d2LUy7cVjOz3472CWhMWH3qcU0z-WQNJht8f6E0hzFC9_WE_xk6uGKM97CMUAAm6JhsGsm4lqpsRa0b3RRAF7Rui7rvEPHD-iE8SneD17mA94l-jbT0NtMUHLQBzQ_5bKBzWS73auU7s9uxPB2Kfu5bB9SMcd44U8tqiYMyinBoR64VCcO40XyStdEjo4EzKbWqalGLFoUWnLMJaaoqwxuToZFizP-gx9Uuv9BVBdws3Wnscdk6OMov4qo9v_4AVQdu4g:1u4doD:Gn2UX9DGcRe2IBXPgAG2UKMt2-iJ1aigr-KGmwAzfTw	2025-04-29 11:46:29.591037+01
szt629c0ko8h98qlk1gqyd4s0rxayajl	.eJxVkM1ugzAQhN9lzwjZGPzDqelrVBFazCLcOjjCJkkV5d2LUy7cVjOz3472CWhtWOfU4ZommpOzmFyYuwulKQwR2q8n_M_QwhVjvIdlgAIwQctVXQvWSC1KxXStTQF0Qee3pP8OET_c3IdH6W_wOhfwvtCtkZbOZZiGg9aj_aE5G-h9lsu9WfnO7HYsT4een_vWATVhnDbO2PBKYa-tJuybQRhN0nJhjRhVZc3AqRdcKaNZJSvZoDRSCD4ijYxZUdsMjRRjfgc9rm75hZYVcHN0p6HDZevgKX9IaHl-_QH-S26m:1u2yRj:mIpG8bhnHYzv43cib1jdfxZZh4Y75kIAxOuJFO88CgQ	2025-04-24 21:24:23.459001+01
3n9e9gyj3j7ojv98gf6boyfc6fdkpg4i	.eJxVjssOwiAURP-FtSG9PKTt0n2_wBgCl4tFG5qUVhfGf1eSLnSWMycn82LWbetot0KLTYH1TLDDb-cd3inXIdxcvs4c57wuyfOK8H0tfJgDTaed_ROMroxVG3Q0GqIUohEYvftGofK6ixQRgJTBFow6IgaCTnuArpFSeNEalFhfPRI9KVi3rAknKqw_y9Zc3h-kGUBX:1u2RFv:luq14Bsq3raDqDnAfb3Y1bE6RpN3Q3xHdFt4ZJox3qY	2025-04-23 09:57:59.087265+01
ulombhaa5fthhoblt35xs68i9c7uqj2m	.eJxVkM1ugzAQhN9lzwjhH2zDqelrVBFazCLcOjjCJkkV5d2LUy7cVjOz3472CWhtWOfU4ZommpOzmFyYuwulKQwR2q8n_M_QwhVjvIdlgAIwQcu0rE2tpNSl1pxXUhZAF3R-i_rvEPHDzX14lP4Gr3MB7xPdGmnpXKYZOGg92h-as4HeZ7ncq5XvzG7H8nQo-rlvHVATxmnjjDXjGntjDWFfD6IxpCwTthGj5rYZGPWCad2YiiuualSNEoKNSGNVWSFthkaKMf-DHle3_EJbFXBzdKehw2Xr4Cm_SBhdCKPOrz8D1W-k:1u9R1G:I8KCky7wG0ViHGltBqfcEuQeDUNyZOiJL74GPfPa_ZA	2025-05-12 17:07:46.084537+01
jkypr8wu5e8oyzfsru2p6fojvivrcn6x	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0PCr:4HZnfGsU6ORRgVrVnRZI9zPgo_2_DQbhfgobxXM1qjw	2025-04-17 19:22:25.493732+01
n34imc3dcbevjl05f9cjyiil6aqquo0d	.eJxVkM1ugzAQhN9lz8gCx_UPp7avUUVosRfh1sERNvlRlHcPTrlwW83MfjvaB6C1cZlyh0seacreYvZx6k6Ux-gStD8P-J-hhTOmdI2zgwowQ9socRDyIKVgRirFG1UBndCHNRp-Y8JPP_XxxsIFnscK3ie6JdHc-UJTsNN6tH80FQNDKDLbqrF3ZrMT-9oV_d62dqgR07hyxFDXfHDKEje9JNIfXGktUPa2HhpjCaUzhLaWpK3TgzC8kZo3qJTmOPACTZRS-Qfdzn6-Q1tXcPF0JdfhvHYIVF4kj88XnDZvDA:1tzOY3:RFRYOTXMkEdDWCnksl_QeXAHEF5QCZTPB9f_2DE-Yos	2025-04-15 00:28:07.075562+01
oiz3igerbstzqslpv3n9so3k6f9bod38	.eJxVjEEOwiAQRe_C2pDOAFJcuu8ZCDOAVA1NSrsy3l1JutC__O_lvYQP-1b83tLq5yguAsXp96PAj1Q7iPdQb4vkpW7rTLIr8qBNTktMz-vh_gVKaKVno8nWQFaIA3Km8J1mTcbllBkgacsjWH1mjgmcIQA3KIWEo2XFKN4f-eI4GQ:1u0Pfj:LoHSURUXcy_do_PNSb7NKJHhQ1XZgRo3oigbjIxq7PA	2025-04-17 19:52:15.245191+01
s1gl91x7yah8zautm4hgt5lcjop47qfi	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0Q7a:W9u6hkMSOyRQapvPGpLyGxTmroTg7LBQl8swIjJj4rg	2025-04-17 20:21:02.104239+01
t46korge9xksx9qf6dpoq11ll0u0puz6	eyJzb2NpYWxhY2NvdW50X3N0YXRlcyI6e319:1u0PxE:C0jWGb_wsSQl0_qTWjWh2ZaElTao4OASlfUT1Wbk5qc	2025-04-17 20:10:20.089723+01
ygtc66gqmc5fj37coved47fjzn0v99tl	.eJxVi0sOAiEQBe_C2kwY_rrTxHOQhm4CUTEZmJXx7kLiQpevqt6Ledh79nujzRdkJybZ4ZcFiDeqU8zZlmmo9hKhl2ddrg8o9_Ngl2_3d87Q8niGxClgAodHKWAVikfSlhwqFVAbzaNNFlEYa5REGiFFDtxIkVAkt7L3B0SMN64:1twosN:Egt_ES8PsRDs6Ma7_84T_NUgGU5KL1qMYfI6pzDYUzw	2025-04-07 21:58:27.742432+01
qg5ghxvn219phd0zlxyts39hifn87wfp	.eJxVkMtugzAQRf9l1gjhFzbs2k3zD1GEBnsirFJcYZMsEP9ek9AFO-s-zh15hRisxxGtDcuUupgwUYR23Qr413BJA03JW0w-TN0PpSG4nLmu8H5De6ZA7iZomZaSayVYXcrKNFzIAn7n8PCO5lz58umy9Dm7-J3AjJC8VszAdivgNdotkebu7VZwEnu03zTtDo7jLpfHdvnKHHYsP063fx6tE2rAOGTOXVRaMUsK77yXRlFDRtYN09grIlWT0lngiI5rzZxzTS-QXKO5zE1uMvTh6UmuwznvjfsvXoXRt-0Pn-V2EA:1u2njm:r31t1uWGJUyJw6VroV-oQtxGswzG6Z6ekqpBc-xmT-0	2025-04-24 09:58:18.595236+01
ng92ts09abp93lyj7zs5jop50gwluz0r	.eJxVkMtugzAQRf_Fa4Ti59js2k37D1GEBnsirFKosEkXiH-vSeiCnXUf5468sjT5iAN6Py1jblPGTIk161axfw2X3NOYo8ccp7H9ptxPoWSuK3u9WXOmsNLNrOGgJBgJytSgHBgnKvYzT48YaC6Vj5g_l65kl7gTuJVKGM0t224Ve462S6K5fbkXdhI79F807g4Owy7Xx3b9zBx2qt9Ot78frROqx9QXzl1eQHNPGu-iU1aTI6uM44CdJtKGNBRBIAYBwEMIrpNIwYFQpSlsgT4i_VJocS57w_6LV2nFbfsDtZZ2IQ:1u0ele:ClcpkwKL0rlk3zQqwyhDSTQaA30ODmmsvBmxD3AhdZ8	2025-04-18 11:59:22.531797+01
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_site (id, domain, name) FROM stdin;
1	127.0.0.1:8000	127.0.0.1:8000
\.


--
-- Data for Name: socialaccount_socialaccount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socialaccount_socialaccount (id, provider, uid, last_login, date_joined, extra_data, user_id) FROM stdin;
1	GitHub	183426518	2025-04-10 09:55:16.404089+01	2025-04-03 20:42:42.374909+01	{"id": 183426518, "bio": null, "url": "https://api.github.com/users/AleksejsGir", "blog": "", "name": "Aleksej IT", "type": "User", "email": "giruckisaleksejs@gmail.com", "login": "AleksejsGir", "company": "Alek", "node_id": "U_kgDOCu7d1g", "hireable": null, "html_url": "https://github.com/AleksejsGir", "location": null, "followers": 0, "following": 0, "gists_url": "https://api.github.com/users/AleksejsGir/gists{/gist_id}", "repos_url": "https://api.github.com/users/AleksejsGir/repos", "avatar_url": "https://avatars.githubusercontent.com/u/183426518?v=4", "created_at": "2024-09-30T19:28:37Z", "events_url": "https://api.github.com/users/AleksejsGir/events{/privacy}", "site_admin": false, "updated_at": "2025-04-03T18:22:14Z", "gravatar_id": "", "starred_url": "https://api.github.com/users/AleksejsGir/starred{/owner}{/repo}", "public_gists": 0, "public_repos": 6, "followers_url": "https://api.github.com/users/AleksejsGir/followers", "following_url": "https://api.github.com/users/AleksejsGir/following{/other_user}", "user_view_type": "public", "twitter_username": null, "organizations_url": "https://api.github.com/users/AleksejsGir/orgs", "subscriptions_url": "https://api.github.com/users/AleksejsGir/subscriptions", "notification_email": "giruckisaleksejs@gmail.com", "received_events_url": "https://api.github.com/users/AleksejsGir/received_events"}	10
\.


--
-- Data for Name: socialaccount_socialapp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socialaccount_socialapp (id, provider, name, client_id, secret, key, provider_id, settings) FROM stdin;
2	github	Alek django app	Ov23liqwhoKd1tUOznsY	b2e0222c6ec03bbbe397e7b81cbec627192940b8		GitHub	{}
\.


--
-- Data for Name: socialaccount_socialapp_sites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socialaccount_socialapp_sites (id, socialapp_id, site_id) FROM stdin;
2	2	1
\.


--
-- Data for Name: socialaccount_socialtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socialaccount_socialtoken (id, token, token_secret, expires_at, account_id, app_id) FROM stdin;
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (id, name) FROM stdin;
\.


--
-- Data for Name: users_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_profile (id, avatar, bio, user_id) FROM stdin;
2	avatars/2025/04/04/Aleksej-Gir_logo_uvwJhAM.JPG	Привет! Как дела?	10
3			2
1	avatars/2025/04/04/Git_commands_like_git_init_git_add_an.webp	Привет всем	8
\.


--
-- Data for Name: users_useractivity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_useractivity (id, action_type, description, related_object_id, "timestamp", user_id) FROM stdin;
1	like_article	Добавлен лайк к статье "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-04 19:17:44.277352+01	8
2	favorite_article	Добавлена в избранного: "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-04 19:17:45.343315+01	8
3	create_article	Создана статья "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:25:30.869152+01	8
4	favorite_article	Добавлена в избранного: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:26:05.02+01	8
5	like_article	Добавлен лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:26:05.850432+01	8
6	favorite_article	Удалена из избранного: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:35:44.175045+01	8
7	favorite_article	Добавлена в избранное: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:35:44.805599+01	8
8	favorite_article	Удалена статья из избранного: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:37:16.462408+01	8
9	favorite_article	Добавлена статья в избранное: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 19:37:17.197858+01	8
10	login	Вход в систему	\N	2025-04-04 19:41:54.622544+01	2
11	edit_article	Отредактирована статья "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-04 19:44:08.147598+01	2
12	edit_article	Отредактирована статья "Subaru показала японскую версию Forester с кузовными комплектами в стиле самурайских доспехов"	384	2025-04-04 19:44:22.468299+01	2
13	edit_article	Отредактирована статья "Yamaha выпустила гибридный мотоцикл за 1680 долларов"	380	2025-04-04 19:44:34.662537+01	2
14	logout	Выход из системы	\N	2025-04-04 20:07:15.358039+01	2
15	login	Вход в систему	\N	2025-04-04 20:07:20.986817+01	8
16	logout	Выход из системы	\N	2025-04-04 20:17:26.592639+01	8
17	login	Вход в систему	\N	2025-04-04 20:17:30.806734+01	10
18	logout	Выход из системы	\N	2025-04-04 20:17:36.090822+01	10
19	login	Вход в систему	\N	2025-04-04 20:17:38.987792+01	8
20	edit_profile	Профиль был обновлен	\N	2025-04-04 20:18:42.546307+01	8
21	logout	Выход из системы	\N	2025-04-04 20:18:53.090893+01	8
22	login	Вход в систему	\N	2025-04-04 20:19:14.751946+01	2
23	logout	Выход из системы	\N	2025-04-04 20:20:26.310589+01	2
24	login	Вход в систему	\N	2025-04-04 20:20:30.110033+01	8
25	logout	Выход из системы	\N	2025-04-04 20:23:32.142176+01	8
26	login	Вход в систему	\N	2025-04-04 20:56:58.290742+01	8
27	login	Вход в систему	\N	2025-04-04 20:58:39.440019+01	2
28	logout	Выход из системы	\N	2025-04-04 21:17:24.720756+01	2
29	login	Вход в систему	\N	2025-04-04 21:17:30.346633+01	8
30	like_article	Удален лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 23:23:46.636465+01	8
31	like_article	Добавлен лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-04 23:23:47.442058+01	8
32	logout	Выход из системы	\N	2025-04-04 23:31:29.225781+01	8
33	login	Вход в систему	\N	2025-04-04 23:31:32.05058+01	8
34	favorite_article	Добавлена статья в избранное: "Subaru показала японскую версию Forester с кузовными комплектами в стиле самурайских доспехов"	384	2025-04-05 00:02:48.344929+01	8
35	like_article	Удален лайк к статье "Subaru показала японскую версию Forester с кузовными комплектами в стиле самурайских доспехов"	384	2025-04-05 00:02:49.259557+01	8
36	like_article	Добавлен лайк к статье "Subaru показала японскую версию Forester с кузовными комплектами в стиле самурайских доспехов"	384	2025-04-05 00:02:49.98569+01	8
37	like_article	Добавлен лайк к статье "Макгонагалл открыла библиотеку"	352	2025-04-05 00:03:32.052678+01	8
38	logout	Выход из системы	\N	2025-04-05 00:34:55.307936+01	8
39	login	Вход в систему	\N	2025-04-05 00:35:01.400545+01	10
40	like_article	Добавлен лайк к статье "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-05 00:35:12.66648+01	10
41	favorite_article	Добавлена статья в избранное: "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-05 00:35:13.63665+01	10
42	like_article	Добавлен лайк к статье "Hisense презентует новый Mini LED телевизор U7Q Pro с поддержкой Matter для Европы"	383	2025-04-05 00:35:40.381367+01	10
139	comment_dislike	Поставлен дизлайк к комментарию 6	6	2025-04-10 09:55:42.030452+01	10
43	like_article	Добавлен лайк к статье "Subaru показала японскую версию Forester с кузовными комплектами в стиле самурайских доспехов"	384	2025-04-05 00:35:41.685794+01	10
44	like_article	Добавлен лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-05 00:35:42.906047+01	10
45	logout	Выход из системы	\N	2025-04-05 20:19:12.304755+01	10
46	login	Вход в систему	\N	2025-04-05 20:19:15.133625+01	8
47	like_article	Удален лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-05 20:57:34.938135+01	8
48	like_article	Добавлен лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-05 20:57:35.855481+01	8
49	login	Вход в систему	\N	2025-04-05 20:58:07.573039+01	2
50	login	Вход в систему	\N	2025-04-07 18:13:55.85446+01	8
51	logout	Выход из системы	\N	2025-04-07 18:23:34.582843+01	8
52	login	Вход в систему	\N	2025-04-07 18:23:50.444549+01	10
53	logout	Выход из системы	\N	2025-04-07 18:25:28.507137+01	10
54	login	Вход в систему	\N	2025-04-07 18:25:34.925453+01	8
55	logout	Выход из системы	\N	2025-04-07 18:27:36.788542+01	8
56	login	Вход в систему	\N	2025-04-07 18:29:04.850133+01	8
57	favorite_article	Удалена статья из избранного: "Функция измерения давления в Apple Watch задерживается из-за технических проблем, - Bloomberg"	382	2025-04-07 18:36:03.343746+01	8
58	favorite_article	Добавлена статья в избранное: "Функция измерения давления в Apple Watch задерживается из-за технических проблем, - Bloomberg"	382	2025-04-07 18:36:04.143955+01	8
59	like_article	Удален лайк к статье "Функция измерения давления в Apple Watch задерживается из-за технических проблем, - Bloomberg"	382	2025-04-07 18:36:06.557648+01	8
60	like_article	Добавлен лайк к статье "Функция измерения давления в Apple Watch задерживается из-за технических проблем, - Bloomberg"	382	2025-04-07 18:36:07.42217+01	8
61	login	Вход в систему	\N	2025-04-07 19:20:53.859357+01	2
62	logout	Выход из системы	\N	2025-04-07 20:01:17.803986+01	2
63	login	Вход в систему	\N	2025-04-07 20:01:22.260942+01	8
64	edit_profile	Профиль был обновлен	\N	2025-04-07 20:02:44.509309+01	8
65	logout	Выход из системы	\N	2025-04-07 20:59:03.138732+01	8
66	login	Вход в систему	\N	2025-04-07 20:59:09.098525+01	10
67	logout	Выход из системы	\N	2025-04-07 21:00:13.023639+01	10
68	login	Вход в систему	\N	2025-04-07 21:00:15.3521+01	8
69	logout	Выход из системы	\N	2025-04-07 21:01:12.724738+01	8
70	login	Вход в систему	\N	2025-04-07 21:01:17.522987+01	10
71	favorite_article	Добавлена статья в избранное: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-07 22:22:17.178477+01	10
72	favorite_article	Удалена статья из избранного: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-07 22:22:17.878029+01	10
73	like_article	Удален лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-07 22:22:18.994307+01	10
74	like_article	Добавлен лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-07 22:22:19.711602+01	10
75	favorite_article	Добавлена статья в избранное: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-07 22:22:20.38769+01	10
76	favorite_article	Добавлена статья в избранное: "Assassin’s Creed Shadows официально на Mac: цена, поддержка контроллеров и требования"	261	2025-04-08 13:24:36.47337+01	10
77	login	Вход в систему	\N	2025-04-09 09:50:52.888836+01	2
78	create_article	Создана статья "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 09:55:31.922717+01	2
79	edit_article	Отредактирована статья "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 09:55:48.379255+01	2
80	edit_article	Отредактирована статья "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 09:56:15.514218+01	2
81	edit_article	Отредактирована статья "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 09:56:35.08599+01	2
82	like_article	Добавлен лайк к статье "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 09:56:57.394803+01	2
83	edit_article	Отредактирована статья "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 09:57:50.429439+01	2
84	login	Вход в систему	\N	2025-04-09 22:00:44.956057+01	8
140	comment_like	Убран лайк к комментарию 7	7	2025-04-10 09:55:44.020143+01	10
85	add_comment	Добавлен комментарий к статье "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 22:01:05.723778+01	8
86	add_comment	Добавлен комментарий к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-09 22:01:46.733843+01	8
87	logout	Выход из системы	\N	2025-04-09 22:01:56.666228+01	8
88	login	Вход в систему	\N	2025-04-09 22:02:02.386258+01	10
89	add_comment	Добавлен комментарий к статье "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 22:02:21.82718+01	10
90	add_comment	Добавлен комментарий к статье "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 23:10:09.248895+01	10
91	add_comment	Добавлен комментарий к статье "Флитвик открыл спа-салон"	367	2025-04-09 23:32:49.077355+01	10
92	add_comment	Добавлен комментарий к статье "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-09 23:44:05.929491+01	10
93	logout	Выход из системы	\N	2025-04-09 23:56:25.150599+01	10
94	login	Вход в систему	\N	2025-04-09 23:56:28.155803+01	8
95	favorite_article	Добавлена статья в избранное: "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-10 00:04:13.587064+01	8
96	favorite_article	Удалена статья из избранного: "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-10 00:04:14.166605+01	8
97	logout	Выход из системы	\N	2025-04-10 00:08:27.949728+01	8
98	login	Вход в систему	\N	2025-04-10 00:08:30.460589+01	8
99	comment_like	Поставлен лайк к комментарию 4	4	2025-04-10 00:17:37.190782+01	8
100	comment_dislike	Поставлен дизлайк к комментарию 4	4	2025-04-10 00:17:38.482157+01	8
101	comment_dislike	Поставлен дизлайк к комментарию 6	6	2025-04-10 00:17:46.38632+01	8
102	comment_like	Поставлен лайк к комментарию 6	6	2025-04-10 00:17:48.019253+01	8
103	comment_dislike	Поставлен дизлайк к комментарию 3	3	2025-04-10 00:17:49.711032+01	8
104	logout	Выход из системы	\N	2025-04-10 00:17:54.329914+01	8
105	login	Вход в систему	\N	2025-04-10 00:17:58.998786+01	10
106	comment_like	Поставлен лайк к комментарию 6	6	2025-04-10 00:18:04.872172+01	10
107	reply_comment	Добавлен ответ на комментарий 6	387	2025-04-10 00:18:19.438462+01	10
108	comment_like	Поставлен лайк к комментарию 7	7	2025-04-10 00:18:27.38244+01	10
109	comment_like	Поставлен лайк к комментарию 4	4	2025-04-10 00:19:02.708288+01	10
110	comment_dislike	Поставлен дизлайк к комментарию 3	3	2025-04-10 00:19:05.063381+01	10
111	reply_comment	Добавлен ответ на комментарий 1	387	2025-04-10 00:19:29.134891+01	10
112	logout	Выход из системы	\N	2025-04-10 00:19:40.060589+01	10
113	login	Вход в систему	\N	2025-04-10 00:19:41.965047+01	8
114	reply_comment	Добавлен ответ на комментарий 7	387	2025-04-10 00:20:05.249077+01	8
115	reply_comment	Добавлен ответ на комментарий 9	387	2025-04-10 00:20:25.564133+01	8
116	comment_dislike	Поставлен дизлайк к комментарию 9	9	2025-04-10 00:20:42.203659+01	8
117	comment_like	Поставлен лайк к комментарию 10	10	2025-04-10 00:20:43.252117+01	8
118	comment_like	Поставлен лайк к комментарию 9	9	2025-04-10 00:21:23.916875+01	8
119	comment_dislike	Поставлен дизлайк к комментарию 9	9	2025-04-10 00:21:25.892406+01	8
120	comment_like	Поставлен лайк к комментарию 9	9	2025-04-10 00:21:27.38377+01	8
121	comment_dislike	Поставлен дизлайк к комментарию 9	9	2025-04-10 00:21:28.383727+01	8
122	comment_dislike	Поставлен дизлайк к комментарию 10	10	2025-04-10 00:21:29.549529+01	8
123	comment_like	Поставлен лайк к комментарию 10	10	2025-04-10 00:21:30.556374+01	8
124	comment_dislike	Поставлен дизлайк к комментарию 10	10	2025-04-10 00:21:31.871475+01	8
125	reply_comment	Добавлен ответ на комментарий 4	387	2025-04-10 00:22:53.297467+01	8
126	comment_like	Поставлен лайк к комментарию 11	11	2025-04-10 00:22:59.605566+01	8
127	like_article	Добавлен лайк к статье "Чо Чанг стала чемпионкой по фехтованию"	350	2025-04-10 00:23:45.884959+01	8
128	comment_like	Поставлен лайк к комментарию 2	2	2025-04-10 09:06:23.905455+01	8
129	reply_comment	Добавлен ответ на комментарий 2	386	2025-04-10 09:06:46.12834+01	8
130	comment_dislike	Поставлен дизлайк к комментарию 2	2	2025-04-10 09:46:05.729721+01	8
131	comment_like	Поставлен лайк к комментарию 2	2	2025-04-10 09:46:06.725963+01	8
132	comment_dislike	Поставлен дизлайк к комментарию 12	12	2025-04-10 09:46:09.052279+01	8
133	add_comment	Добавлен комментарий к статье "Hisense презентует новый Mini LED телевизор U7Q Pro с поддержкой Matter для Европы"	383	2025-04-10 09:46:57.648614+01	8
134	comment_like	Поставлен лайк к комментарию 13	13	2025-04-10 09:47:01.419284+01	8
135	logout	Выход из системы	\N	2025-04-10 09:52:16.393394+01	8
136	login	Вход в систему	\N	2025-04-10 09:55:16.438421+01	10
137	comment_like	Убран лайк к комментарию 6	6	2025-04-10 09:55:40.218366+01	10
138	comment_like	Поставлен лайк к комментарию 6	6	2025-04-10 09:55:40.805115+01	10
141	comment_like	Поставлен лайк к комментарию 7	7	2025-04-10 09:55:44.699258+01	10
142	comment_like	Поставлен лайк к комментарию 9	9	2025-04-10 09:55:46.566958+01	10
143	comment_like	Поставлен лайк к комментарию 10	10	2025-04-10 09:55:48.801924+01	10
144	favorite_article	Добавлена статья в избранное: "Репетиция 2050 года: что известно о Kawasaki Corleo - водородном роботе-коне для бездорожья"	387	2025-04-10 09:57:56.487532+01	10
145	login	Вход в систему	\N	2025-04-10 18:21:23.751653+01	8
146	reply_comment	Добавлен ответ на комментарий 12	386	2025-04-10 20:59:29.364941+01	8
147	comment_like	Поставлен лайк к комментарию 14	14	2025-04-10 20:59:34.520836+01	8
148	favorite_article	Удалена статья из избранного: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-10 20:59:49.008687+01	8
149	favorite_article	Добавлена статья в избранное: "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-10 20:59:49.619393+01	8
150	like_article	Удален лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-10 20:59:50.189506+01	8
151	like_article	Добавлен лайк к статье "VR-версия стратегии Sid Meier’s Civilization VII выйдет уже на следующей неделе: разработчик представил обзорный трейлер"	386	2025-04-10 20:59:50.823499+01	8
152	login	Вход в систему	\N	2025-04-10 21:48:27.319098+01	8
153	add_comment	Добавлен комментарий к статье "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-10 21:49:02.828754+01	8
154	comment_like	Поставлен лайк к комментарию 15	15	2025-04-10 21:49:07.185997+01	8
155	reply_comment	Добавлен ответ на комментарий 15	385	2025-04-10 21:49:12.659581+01	8
156	reply_comment	Добавлен ответ на комментарий 16	385	2025-04-10 21:49:27.240667+01	8
157	reply_comment	Добавлен ответ на комментарий 17	385	2025-04-10 21:49:36.208454+01	8
158	comment_dislike	Поставлен дизлайк к комментарию 17	17	2025-04-10 21:49:47.560577+01	8
159	comment_like	Поставлен лайк к комментарию 16	16	2025-04-10 21:49:48.477908+01	8
160	comment_like	Поставлен лайк к комментарию 18	18	2025-04-10 21:49:49.142845+01	8
161	edit_article	Отредактирована статья "Владельцы iPhone жалуются, что iOS 18.4 сломало беспроводное подключение к CarPlay"	385	2025-04-10 21:54:55.880925+01	8
162	login	Вход в систему	\N	2025-04-15 11:46:18.614189+01	8
163	login	Вход в систему	\N	2025-04-28 17:07:27.782655+01	8
\.


--
-- Name: CommentLikes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CommentLikes_id_seq"', 22, true);


--
-- Name: Comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Comments_id_seq"', 18, true);


--
-- Name: Favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Favorites_id_seq"', 95, true);


--
-- Name: Likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Likes_id_seq"', 135, true);


--
-- Name: account_emailaddress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_emailaddress_id_seq', 9, true);


--
-- Name: account_emailconfirmation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_emailconfirmation_id_seq', 1, false);


--
-- Name: article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.article_id_seq', 1, false);


--
-- Name: article_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.article_tag_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 2, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 71, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 84, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 2, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 10, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 76, true);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 2, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 72, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 21, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 50, true);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Name: news_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_article_id_seq', 387, true);


--
-- Name: news_article_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_article_tags_id_seq', 977, true);


--
-- Name: news_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_category_id_seq', 12, true);


--
-- Name: news_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_tag_id_seq', 33, true);


--
-- Name: socialaccount_socialaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socialaccount_socialaccount_id_seq', 1, true);


--
-- Name: socialaccount_socialapp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socialaccount_socialapp_id_seq', 2, true);


--
-- Name: socialaccount_socialapp_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socialaccount_socialapp_sites_id_seq', 2, true);


--
-- Name: socialaccount_socialtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socialaccount_socialtoken_id_seq', 1, false);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_id_seq', 1, false);


--
-- Name: users_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_profile_id_seq', 3, true);


--
-- Name: users_useractivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_useractivity_id_seq', 163, true);


--
-- Name: CommentLikes CommentLikes_comment_id_user_id_4d1f248d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLikes"
    ADD CONSTRAINT "CommentLikes_comment_id_user_id_4d1f248d_uniq" UNIQUE (comment_id, user_id);


--
-- Name: CommentLikes CommentLikes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLikes"
    ADD CONSTRAINT "CommentLikes_pkey" PRIMARY KEY (id);


--
-- Name: Comments Comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_pkey" PRIMARY KEY (id);


--
-- Name: Favorites Favorites_article_id_user_id_e1173a09_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favorites"
    ADD CONSTRAINT "Favorites_article_id_user_id_e1173a09_uniq" UNIQUE (article_id, user_id);


--
-- Name: Favorites Favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favorites"
    ADD CONSTRAINT "Favorites_pkey" PRIMARY KEY (id);


--
-- Name: Likes Likes_article_id_user_id_23e2c280_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Likes"
    ADD CONSTRAINT "Likes_article_id_user_id_23e2c280_uniq" UNIQUE (article_id, user_id);


--
-- Name: Likes Likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Likes"
    ADD CONSTRAINT "Likes_pkey" PRIMARY KEY (id);


--
-- Name: account_emailaddress account_emailaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_pkey PRIMARY KEY (id);


--
-- Name: account_emailaddress account_emailaddress_user_id_email_987c8728_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_user_id_email_987c8728_uniq UNIQUE (user_id, email);


--
-- Name: account_emailconfirmation account_emailconfirmation_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_key_key UNIQUE (key);


--
-- Name: account_emailconfirmation account_emailconfirmation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirmation_pkey PRIMARY KEY (id);


--
-- Name: article article_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id);


--
-- Name: article article_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_slug_key UNIQUE (slug);


--
-- Name: article_tag article_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_tag
    ADD CONSTRAINT article_tag_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: category category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: Articles news_article_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles"
    ADD CONSTRAINT news_article_pkey PRIMARY KEY (id);


--
-- Name: Articles news_article_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles"
    ADD CONSTRAINT news_article_slug_key UNIQUE (slug);


--
-- Name: Articles_tags news_article_tags_article_id_tag_id_e8bdf741_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles_tags"
    ADD CONSTRAINT news_article_tags_article_id_tag_id_e8bdf741_uniq UNIQUE (article_id, tag_id);


--
-- Name: Articles_tags news_article_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles_tags"
    ADD CONSTRAINT news_article_tags_pkey PRIMARY KEY (id);


--
-- Name: Categories news_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Categories"
    ADD CONSTRAINT news_category_pkey PRIMARY KEY (id);


--
-- Name: Tags news_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT news_tag_name_key UNIQUE (name);


--
-- Name: Tags news_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT news_tag_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialaccount socialaccount_socialaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialaccount socialaccount_socialaccount_provider_uid_fc810c6e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_provider_uid_fc810c6e_uniq UNIQUE (provider, uid);


--
-- Name: socialaccount_socialapp_sites socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq UNIQUE (socialapp_id, site_id);


--
-- Name: socialaccount_socialapp socialaccount_socialapp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialapp
    ADD CONSTRAINT socialaccount_socialapp_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialapp_sites socialaccount_socialapp_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_socialapp_sites_pkey PRIMARY KEY (id);


--
-- Name: socialaccount_socialtoken socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq UNIQUE (app_id, account_id);


--
-- Name: socialaccount_socialtoken socialaccount_socialtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_socialtoken_pkey PRIMARY KEY (id);


--
-- Name: tag tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_name_key UNIQUE (name);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: users_profile users_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_profile
    ADD CONSTRAINT users_profile_pkey PRIMARY KEY (id);


--
-- Name: users_profile users_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_profile
    ADD CONSTRAINT users_profile_user_id_key UNIQUE (user_id);


--
-- Name: users_useractivity users_useractivity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_useractivity
    ADD CONSTRAINT users_useractivity_pkey PRIMARY KEY (id);


--
-- Name: Articles_author_id_391eefb7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Articles_author_id_391eefb7" ON public."Articles" USING btree (author_id);


--
-- Name: CommentLikes_comment_id_7ec9e1de; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "CommentLikes_comment_id_7ec9e1de" ON public."CommentLikes" USING btree (comment_id);


--
-- Name: CommentLikes_user_id_356c9fba; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "CommentLikes_user_id_356c9fba" ON public."CommentLikes" USING btree (user_id);


--
-- Name: Comments_article_id_75f4e820; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Comments_article_id_75f4e820" ON public."Comments" USING btree (article_id);


--
-- Name: Comments_parent_id_5710fb4d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Comments_parent_id_5710fb4d" ON public."Comments" USING btree (parent_id);


--
-- Name: Comments_user_id_ed7fb3fe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Comments_user_id_ed7fb3fe" ON public."Comments" USING btree (user_id);


--
-- Name: Favorites_article_id_4369c90a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Favorites_article_id_4369c90a" ON public."Favorites" USING btree (article_id);


--
-- Name: Favorites_user_id_0e4c994c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Favorites_user_id_0e4c994c" ON public."Favorites" USING btree (user_id);


--
-- Name: Likes_article_id_5f17686e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Likes_article_id_5f17686e" ON public."Likes" USING btree (article_id);


--
-- Name: Likes_user_id_a13ef4c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Likes_user_id_a13ef4c7" ON public."Likes" USING btree (user_id);


--
-- Name: account_emailaddress_email_03be32b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailaddress_email_03be32b2 ON public.account_emailaddress USING btree (email);


--
-- Name: account_emailaddress_email_03be32b2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailaddress_email_03be32b2_like ON public.account_emailaddress USING btree (email varchar_pattern_ops);


--
-- Name: account_emailaddress_user_id_2c513194; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailaddress_user_id_2c513194 ON public.account_emailaddress USING btree (user_id);


--
-- Name: account_emailconfirmation_email_address_id_5b7f8c58; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailconfirmation_email_address_id_5b7f8c58 ON public.account_emailconfirmation USING btree (email_address_id);


--
-- Name: account_emailconfirmation_key_f43612bd_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_emailconfirmation_key_f43612bd_like ON public.account_emailconfirmation USING btree (key varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: idx_article_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_article_slug ON public.article USING btree (slug);


--
-- Name: idx_article_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_article_title ON public.article USING btree (title);


--
-- Name: news_article_category_id_7ede7614; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX news_article_category_id_7ede7614 ON public."Articles" USING btree (category_id);


--
-- Name: news_article_slug_5328fdc5_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX news_article_slug_5328fdc5_like ON public."Articles" USING btree (slug varchar_pattern_ops);


--
-- Name: news_article_tags_article_id_6c2f9e1e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX news_article_tags_article_id_6c2f9e1e ON public."Articles_tags" USING btree (article_id);


--
-- Name: news_article_tags_tag_id_8c2bd5d5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX news_article_tags_tag_id_8c2bd5d5 ON public."Articles_tags" USING btree (tag_id);


--
-- Name: news_tag_name_8821d338_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX news_tag_name_8821d338_like ON public."Tags" USING btree (name varchar_pattern_ops);


--
-- Name: socialaccount_socialaccount_user_id_8146e70c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX socialaccount_socialaccount_user_id_8146e70c ON public.socialaccount_socialaccount USING btree (user_id);


--
-- Name: socialaccount_socialapp_sites_site_id_2579dee5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX socialaccount_socialapp_sites_site_id_2579dee5 ON public.socialaccount_socialapp_sites USING btree (site_id);


--
-- Name: socialaccount_socialapp_sites_socialapp_id_97fb6e7d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX socialaccount_socialapp_sites_socialapp_id_97fb6e7d ON public.socialaccount_socialapp_sites USING btree (socialapp_id);


--
-- Name: socialaccount_socialtoken_account_id_951f210e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX socialaccount_socialtoken_account_id_951f210e ON public.socialaccount_socialtoken USING btree (account_id);


--
-- Name: socialaccount_socialtoken_app_id_636a42d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX socialaccount_socialtoken_app_id_636a42d7 ON public.socialaccount_socialtoken USING btree (app_id);


--
-- Name: unique_primary_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_primary_email ON public.account_emailaddress USING btree (user_id, "primary") WHERE "primary";


--
-- Name: unique_verified_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_verified_email ON public.account_emailaddress USING btree (email) WHERE verified;


--
-- Name: users_useractivity_user_id_83265632; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_useractivity_user_id_83265632 ON public.users_useractivity USING btree (user_id);


--
-- Name: article trigger_update_slug; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_slug BEFORE INSERT OR UPDATE ON public.article FOR EACH ROW EXECUTE FUNCTION public.update_slug();


--
-- Name: Articles Articles_author_id_391eefb7_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles"
    ADD CONSTRAINT "Articles_author_id_391eefb7_fk_auth_user_id" FOREIGN KEY (author_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: CommentLikes CommentLikes_comment_id_7ec9e1de_fk_Comments_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLikes"
    ADD CONSTRAINT "CommentLikes_comment_id_7ec9e1de_fk_Comments_id" FOREIGN KEY (comment_id) REFERENCES public."Comments"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: CommentLikes CommentLikes_user_id_356c9fba_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLikes"
    ADD CONSTRAINT "CommentLikes_user_id_356c9fba_fk_auth_user_id" FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Comments Comments_article_id_75f4e820_fk_Articles_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_article_id_75f4e820_fk_Articles_id" FOREIGN KEY (article_id) REFERENCES public."Articles"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Comments Comments_parent_id_5710fb4d_fk_Comments_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_parent_id_5710fb4d_fk_Comments_id" FOREIGN KEY (parent_id) REFERENCES public."Comments"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Comments Comments_user_id_ed7fb3fe_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_user_id_ed7fb3fe_fk_auth_user_id" FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Favorites Favorites_article_id_4369c90a_fk_Articles_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favorites"
    ADD CONSTRAINT "Favorites_article_id_4369c90a_fk_Articles_id" FOREIGN KEY (article_id) REFERENCES public."Articles"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Favorites Favorites_user_id_0e4c994c_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Favorites"
    ADD CONSTRAINT "Favorites_user_id_0e4c994c_fk_auth_user_id" FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Likes Likes_article_id_5f17686e_fk_Articles_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Likes"
    ADD CONSTRAINT "Likes_article_id_5f17686e_fk_Articles_id" FOREIGN KEY (article_id) REFERENCES public."Articles"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Likes Likes_user_id_a13ef4c7_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Likes"
    ADD CONSTRAINT "Likes_user_id_a13ef4c7_fk_auth_user_id" FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_emailaddress account_emailaddress_user_id_2c513194_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailaddress
    ADD CONSTRAINT account_emailaddress_user_id_2c513194_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_emailconfirmation account_emailconfirm_email_address_id_5b7f8c58_fk_account_e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_emailconfirmation
    ADD CONSTRAINT account_emailconfirm_email_address_id_5b7f8c58_fk_account_e FOREIGN KEY (email_address_id) REFERENCES public.account_emailaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: article article_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id) ON DELETE CASCADE;


--
-- Name: article_tag article_tag_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_tag
    ADD CONSTRAINT article_tag_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.article(id) ON DELETE CASCADE;


--
-- Name: article_tag article_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_tag
    ADD CONSTRAINT article_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON DELETE CASCADE;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Articles news_article_category_id_7ede7614_fk_news_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles"
    ADD CONSTRAINT news_article_category_id_7ede7614_fk_news_category_id FOREIGN KEY (category_id) REFERENCES public."Categories"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Articles_tags news_article_tags_article_id_6c2f9e1e_fk_news_article_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles_tags"
    ADD CONSTRAINT news_article_tags_article_id_6c2f9e1e_fk_news_article_id FOREIGN KEY (article_id) REFERENCES public."Articles"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Articles_tags news_article_tags_tag_id_8c2bd5d5_fk_news_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Articles_tags"
    ADD CONSTRAINT news_article_tags_tag_id_8c2bd5d5_fk_news_tag_id FOREIGN KEY (tag_id) REFERENCES public."Tags"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialtoken socialaccount_social_account_id_951f210e_fk_socialacc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_social_account_id_951f210e_fk_socialacc FOREIGN KEY (account_id) REFERENCES public.socialaccount_socialaccount(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialtoken socialaccount_social_app_id_636a42d7_fk_socialacc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialtoken
    ADD CONSTRAINT socialaccount_social_app_id_636a42d7_fk_socialacc FOREIGN KEY (app_id) REFERENCES public.socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialapp_sites socialaccount_social_site_id_2579dee5_fk_django_si; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_social_site_id_2579dee5_fk_django_si FOREIGN KEY (site_id) REFERENCES public.django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialapp_sites socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialapp_sites
    ADD CONSTRAINT socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc FOREIGN KEY (socialapp_id) REFERENCES public.socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: socialaccount_socialaccount socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socialaccount_socialaccount
    ADD CONSTRAINT socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_profile users_profile_user_id_2112e78d_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_profile
    ADD CONSTRAINT users_profile_user_id_2112e78d_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_useractivity users_useractivity_user_id_83265632_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_useractivity
    ADD CONSTRAINT users_useractivity_user_id_83265632_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

