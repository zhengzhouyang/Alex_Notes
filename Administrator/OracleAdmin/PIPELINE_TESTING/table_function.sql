drop type ty_rep_fil_tab;
drop type ty_rep_filters;


create type ty_rep_filters as OBJECT
(
	game_name		varchar2(4000),
	parent_game		varchar2(100),
	supplier		varchar2(4000),
	slot_cabinet	varchar2(4000),
	own_status		varchar2(4000),
	game_cate		varchar2(4000),
	game_class		varchar2(4000),
	game_denom		varchar2(4000),
	game_line		varchar2(4000),
	max_bet			varchar2(4000),
	progressive		varchar2(4000),
	days_cabinet	number,
	days_theme		number,
	coin_hs			number,
	netwin_hs		number,
	coin_sz			number,
	netwin_sz		number
);
/

create type ty_rep_fil_tab is table of ty_rep_filters;
/

create or replace function get_rep_filters return ty_rep_fil_tab is
	
	l_tab	ty_rep_fil_tab := ty_rep_fil_tab();
	
	cursor	fil_cur is
				select
						GAME_NAME,
						PARENT_GAME,
						SUPPLIER,
						SLOT_CABINET_NAME,
						OWN_STATUS,
						GAME_CATEGORY,
						GAME_CLASSIFICATION,
						GAME_DENOM,
						GAME_LINE_COUNT,
						MAX_BET,
						PROGRESSIVE,
						DAYS_CABINET,
						DAYS_THEME,
						COIN_IN_IDX_VS_HS_AVG,
						NET_WIN_IDX_VS_HS_AVG,
						COIN_IN_IDX_VS_SZ_AVG,
						NET_WIN_IDX_VS_SZ_AVG
				from
						report_mv;
	
begin

	for fil_rec in fil_cur loop
	
		l_tab.extend;
		
		l_tab(l_tab.last) := ty_rep_filters(
										fil_rec.game_name,
										fil_rec.parent_game,
										fil_rec.supplier,
										fil_rec.SLOT_CABINET_NAME,
										fil_rec.own_status,
										fil_rec.GAME_CATEGORY,
										fil_rec.GAME_CLASSIFICATION,
										fil_rec.GAME_DENOM,
										fil_rec.GAME_LINE_COUNT,
										fil_rec.MAX_BET,
										fil_rec.progressive,
										fil_rec.days_cabinet,
										fil_rec.DAYS_THEME,
										fil_rec.COIN_IN_IDX_VS_HS_AVG,
										fil_rec.NET_WIN_IDX_VS_HS_AVG,
										fil_rec.COIN_IN_IDX_VS_SZ_AVG,
										fil_rec.NET_WIN_IDX_VS_SZ_AVG
								);
	
	end loop;

	RETURN l_tab;
	
end;

CREATE OR REPLACE FUNCTION get_rep_filters_pipe RETURN ty_rep_fil_tab PIPELINED AS
	
	cursor	fil_cur is
				select
						GAME_NAME,
						PARENT_GAME,
						SUPPLIER,
						SLOT_CABINET_NAME,
						OWN_STATUS,
						GAME_CATEGORY,
						GAME_CLASSIFICATION,
						GAME_DENOM,
						GAME_LINE_COUNT,
						MAX_BET,
						PROGRESSIVE,
						DAYS_CABINET,
						DAYS_THEME,
						COIN_IN_IDX_VS_HS_AVG,
						NET_WIN_IDX_VS_HS_AVG,
						COIN_IN_IDX_VS_SZ_AVG,
						NET_WIN_IDX_VS_SZ_AVG
				from
						report_mv;

BEGIN
  for fil_rec in fil_cur loop
		
		PIPE ROW (ty_rep_filters(
										fil_rec.game_name,
										fil_rec.parent_game,
										fil_rec.supplier,
										fil_rec.SLOT_CABINET_NAME,
										fil_rec.own_status,
										fil_rec.GAME_CATEGORY,
										fil_rec.GAME_CLASSIFICATION,
										fil_rec.GAME_DENOM,
										fil_rec.GAME_LINE_COUNT,
										fil_rec.MAX_BET,
										fil_rec.progressive,
										fil_rec.days_cabinet,
										fil_rec.DAYS_THEME,
										fil_rec.COIN_IN_IDX_VS_HS_AVG,
										fil_rec.NET_WIN_IDX_VS_HS_AVG,
										fil_rec.COIN_IN_IDX_VS_SZ_AVG,
										fil_rec.NET_WIN_IDX_VS_SZ_AVG
								));
	
	end loop;

  RETURN;
END;
/


SELECT *
FROM   TABLE(get_rep_filters);

SELECT *
FROM   TABLE(get_rep_filters_pipe);



