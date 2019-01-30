-- Function: dba."getConfig"(character varying, character, character varying, character varying)

-- DROP FUNCTION dba."getConfig"(character varying, character, character varying, character varying);

CREATE OR REPLACE FUNCTION dba."getConfig"(
    config_ character varying,
    scope_ character,
    scopeid_ character varying,
    defsetting_ character varying)
  RETURNS character varying AS
$BODY$
declare Setting_ varchar(255);
begin
  select setting
    into Setting_ from dba.pxconfig
    where Config = Config_ and Scope = Scope_ and ScopeID = ScopeID_;
  if Setting_ is null or Setting_ = '' then
    Setting_ = DefSetting_;
  end if;
  return trim(Setting_);
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dba."getConfig"(character varying, character, character varying, character varying)
  OWNER TO postgres;