Commandes utiles :
- ./.venv/Scripts/activate

Paramètres spéciaux de la bi_business
- dbt build -t etienne -s stg_prod_bdd__user_log_activity_concepts_new --full-refresh

Paramètres spéciaux de la bi data
-  dbt build  -t etienne --vars '{ "pp_chosen_schema": "pp_dw_staging" }' -s bi_data.01_staging, bi_data.02_intermediate, bi_data.03_marts 
