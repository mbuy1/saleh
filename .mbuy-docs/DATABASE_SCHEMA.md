| ?column?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ## 🗂️ Table: admin_activity_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **staff_id** (uuid) NULLABLE: NO
- **action** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **entity_type** (text) NULLABLE: YES
- **entity_id** (uuid) NULLABLE: YES
- **ip_address** (text) NULLABLE: YES
- **user_agent** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: admin_activity_logs_pkey → admin_activity_logs(id)
- **CHECK**: 2200_67567_1_not_null
- **CHECK**: 2200_67567_2_not_null
- **CHECK**: 2200_67567_3_not_null
- **CHECK**: 2200_67567_4_not_null

### Indexes
- admin_activity_logs_pkey: CREATE UNIQUE INDEX admin_activity_logs_pkey ON public.admin_activity_logs USING btree (id)
- idx_admin_activity_logs_merchant_id: CREATE INDEX idx_admin_activity_logs_merchant_id ON public.admin_activity_logs USING btree (merchant_id)
- idx_admin_activity_logs_staff_id: CREATE INDEX idx_admin_activity_logs_staff_id ON public.admin_activity_logs USING btree (staff_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: admin_role_permissions

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **role_id** (uuid) NULLABLE: NO
- **permissions** (jsonb) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: admin_role_permissions_pkey → admin_role_permissions(id)
- **CHECK**: 2200_67557_1_not_null
- **CHECK**: 2200_67557_2_not_null
- **CHECK**: 2200_67557_3_not_null

### Indexes
- admin_role_permissions_pkey: CREATE UNIQUE INDEX admin_role_permissions_pkey ON public.admin_role_permissions USING btree (id)
- idx_admin_role_permissions_role_id: CREATE INDEX idx_admin_role_permissions_role_id ON public.admin_role_permissions USING btree (role_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: admin_roles

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: admin_roles_pkey → admin_roles(id)
- **CHECK**: 2200_67538_1_not_null
- **CHECK**: 2200_67538_2_not_null
- **CHECK**: 2200_67538_3_not_null

### Indexes
- admin_roles_pkey: CREATE UNIQUE INDEX admin_roles_pkey ON public.admin_roles USING btree (id)
- idx_admin_roles_merchant_id: CREATE INDEX idx_admin_roles_merchant_id ON public.admin_roles USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: admin_staff

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **name** (text) NULLABLE: NO
- **email** (text) NULLABLE: NO
- **phone** (text) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **password_hash** (text) NULLABLE: YES

### Constraints
- **UNIQUE**: admin_staff_email_key → admin_staff(email)
- **UNIQUE**: admin_staff_email_unique → admin_staff(email)
- **PRIMARY KEY**: admin_staff_pkey → admin_staff(id)
- **CHECK**: 2200_67524_1_not_null
- **CHECK**: 2200_67524_3_not_null
- **CHECK**: 2200_67524_4_not_null

### Indexes
- admin_staff_pkey: CREATE UNIQUE INDEX admin_staff_pkey ON public.admin_staff USING btree (id)
- admin_staff_email_key: CREATE UNIQUE INDEX admin_staff_email_key ON public.admin_staff USING btree (email)
- admin_staff_email_unique: CREATE UNIQUE INDEX admin_staff_email_unique ON public.admin_staff USING btree (email)
- idx_admin_staff_email: CREATE INDEX idx_admin_staff_email ON public.admin_staff USING btree (email)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: admin_staff_roles

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **staff_id** (uuid) NULLABLE: NO
- **role_id** (uuid) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: admin_staff_roles_pkey → admin_staff_roles(id)
- **CHECK**: 2200_67548_1_not_null
- **CHECK**: 2200_67548_2_not_null
- **CHECK**: 2200_67548_3_not_null

### Indexes
- admin_staff_roles_pkey: CREATE UNIQUE INDEX admin_staff_roles_pkey ON public.admin_staff_roles USING btree (id)
- idx_admin_staff_roles_staff_id: CREATE INDEX idx_admin_staff_roles_staff_id ON public.admin_staff_roles USING btree (staff_id)
- idx_admin_staff_roles_role_id: CREATE INDEX idx_admin_staff_roles_role_id ON public.admin_staff_roles USING btree (role_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: affiliate_commissions

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **affiliate_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **order_id** (uuid) NULLABLE: NO
- **commission_amount** (numeric) NULLABLE: NO
- **commission_rate** (numeric) NULLABLE: NO
- **status** (text) NULLABLE: NO, DEFAULT: 'pending'::text
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **approved_at** (timestamp with time zone) NULLABLE: YES
- **paid_at** (timestamp with time zone) NULLABLE: YES

### Constraints
- **PRIMARY KEY**: affiliate_commissions_pkey → affiliate_commissions(id)
- **CHECK**: 2200_66784_1_not_null
- **CHECK**: 2200_66784_2_not_null
- **CHECK**: 2200_66784_3_not_null
- **CHECK**: 2200_66784_4_not_null
- **CHECK**: 2200_66784_5_not_null
- **CHECK**: 2200_66784_6_not_null
- **CHECK**: 2200_66784_7_not_null

### Indexes
- affiliate_commissions_pkey: CREATE UNIQUE INDEX affiliate_commissions_pkey ON public.affiliate_commissions USING btree (id)
- idx_affiliate_commissions_affiliate_id: CREATE INDEX idx_affiliate_commissions_affiliate_id ON public.affiliate_commissions USING btree (affiliate_id)
- idx_affiliate_commissions_status: CREATE INDEX idx_affiliate_commissions_status ON public.affiliate_commissions USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: affiliate_events

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **affiliate_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **event_name** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: affiliate_events_pkey → affiliate_events(id)
- **CHECK**: 2200_66809_1_not_null
- **CHECK**: 2200_66809_3_not_null
- **CHECK**: 2200_66809_4_not_null

### Indexes
- affiliate_events_pkey: CREATE UNIQUE INDEX affiliate_events_pkey ON public.affiliate_events USING btree (id)
- idx_affiliate_events_affiliate_id: CREATE INDEX idx_affiliate_events_affiliate_id ON public.affiliate_events USING btree (affiliate_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: affiliate_links

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **affiliate_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **link_code** (text) NULLABLE: NO
- **target_url** (text) NULLABLE: NO
- **clicks** (integer) NULLABLE: YES, DEFAULT: 0
- **conversions** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: affiliate_links_link_code_key → affiliate_links(link_code)
- **PRIMARY KEY**: affiliate_links_pkey → affiliate_links(id)
- **FOREIGN KEY**: fk_affiliate_links_affiliate → affiliates(id)
- **CHECK**: 2200_66765_1_not_null
- **CHECK**: 2200_66765_2_not_null
- **CHECK**: 2200_66765_3_not_null
- **CHECK**: 2200_66765_4_not_null
- **CHECK**: 2200_66765_5_not_null

### Indexes
- affiliate_links_pkey: CREATE UNIQUE INDEX affiliate_links_pkey ON public.affiliate_links USING btree (id)
- affiliate_links_link_code_key: CREATE UNIQUE INDEX affiliate_links_link_code_key ON public.affiliate_links USING btree (link_code)
- idx_affiliate_links_affiliate_id: CREATE INDEX idx_affiliate_links_affiliate_id ON public.affiliate_links USING btree (affiliate_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: affiliate_payouts

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **affiliate_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **amount** (numeric) NULLABLE: NO
- **currency** (text) NULLABLE: YES, DEFAULT: 'SAR'::text
- **status** (text) NULLABLE: NO, DEFAULT: 'pending'::text
- **transaction_reference** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **paid_at** (timestamp with time zone) NULLABLE: YES

### Constraints
- **PRIMARY KEY**: affiliate_payouts_pkey → affiliate_payouts(id)
- **CHECK**: 2200_66796_1_not_null
- **CHECK**: 2200_66796_2_not_null
- **CHECK**: 2200_66796_3_not_null
- **CHECK**: 2200_66796_4_not_null
- **CHECK**: 2200_66796_6_not_null

### Indexes
- affiliate_payouts_pkey: CREATE UNIQUE INDEX affiliate_payouts_pkey ON public.affiliate_payouts USING btree (id)
- idx_affiliate_payouts_affiliate_id: CREATE INDEX idx_affiliate_payouts_affiliate_id ON public.affiliate_payouts USING btree (affiliate_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: affiliates

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **email** (text) NULLABLE: YES
- **phone** (text) NULLABLE: YES
- **referral_code** (text) NULLABLE: YES
- **referral_url** (text) NULLABLE: YES
- **commission_rate** (numeric) NULLABLE: YES, DEFAULT: 10
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: affiliates_pkey → affiliates(id)
- **UNIQUE**: affiliates_referral_code_key → affiliates(referral_code)
- **CHECK**: 2200_66749_1_not_null
- **CHECK**: 2200_66749_2_not_null
- **CHECK**: 2200_66749_3_not_null

### Indexes
- affiliates_pkey: CREATE UNIQUE INDEX affiliates_pkey ON public.affiliates USING btree (id)
- affiliates_referral_code_key: CREATE UNIQUE INDEX affiliates_referral_code_key ON public.affiliates USING btree (referral_code)
- idx_affiliates_merchant_id: CREATE INDEX idx_affiliates_merchant_id ON public.affiliates USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: ai_embeddings

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **entity_type** (text) NULLABLE: NO
- **entity_id** (uuid) NULLABLE: NO
- **embedding** (USER-DEFINED) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: ai_embeddings_entity_type_entity_id_key → ai_embeddings(entity_id)
- **UNIQUE**: ai_embeddings_entity_type_entity_id_key → ai_embeddings(entity_type)
- **UNIQUE**: ai_embeddings_entity_type_entity_id_key → ai_embeddings(entity_id)
- **UNIQUE**: ai_embeddings_entity_type_entity_id_key → ai_embeddings(entity_type)
- **PRIMARY KEY**: ai_embeddings_pkey → ai_embeddings(id)
- **CHECK**: 2200_66151_1_not_null
- **CHECK**: 2200_66151_2_not_null
- **CHECK**: 2200_66151_3_not_null
- **CHECK**: 2200_66151_4_not_null

### Indexes
- ai_embeddings_pkey: CREATE UNIQUE INDEX ai_embeddings_pkey ON public.ai_embeddings USING btree (id)
- ai_embeddings_entity_type_entity_id_key: CREATE UNIQUE INDEX ai_embeddings_entity_type_entity_id_key ON public.ai_embeddings USING btree (entity_type, entity_id)
- idx_ai_embeddings_merchant_id: CREATE INDEX idx_ai_embeddings_merchant_id ON public.ai_embeddings USING btree (merchant_id)
- ai_embeddings_hnsw_idx: CREATE INDEX ai_embeddings_hnsw_idx ON public.ai_embeddings USING hnsw (embedding vector_cosine_ops)
- ai_embeddings_ivf_idx: CREATE INDEX ai_embeddings_ivf_idx ON public.ai_embeddings USING ivfflat (embedding vector_cosine_ops) WITH (lists='100')

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: ai_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **task_id** (uuid) NULLABLE: YES
- **event** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ai_logs_pkey → ai_logs(id)
- **FOREIGN KEY**: fk_ai_logs_task → ai_tasks(id)
- **CHECK**: 2200_66164_1_not_null
- **CHECK**: 2200_66164_2_not_null
- **CHECK**: 2200_66164_4_not_null

### Indexes
- ai_logs_pkey: CREATE UNIQUE INDEX ai_logs_pkey ON public.ai_logs USING btree (id)
- idx_ai_logs_task_id: CREATE INDEX idx_ai_logs_task_id ON public.ai_logs USING btree (task_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: ai_predictions

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **prediction_type** (USER-DEFINED) NULLABLE: NO
- **target_id** (uuid) NULLABLE: YES
- **prediction_value** (numeric) NULLABLE: YES
- **confidence** (numeric) NULLABLE: YES
- **prediction_data** (jsonb) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ai_predictions_pkey → ai_predictions(id)
- **CHECK**: 2200_65813_1_not_null
- **CHECK**: 2200_65813_2_not_null
- **CHECK**: 2200_65813_3_not_null

### Indexes
- ai_predictions_pkey: CREATE UNIQUE INDEX ai_predictions_pkey ON public.ai_predictions USING btree (id)
- idx_ai_predictions_merchant_id: CREATE INDEX idx_ai_predictions_merchant_id ON public.ai_predictions USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: ai_recommendations

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **product_id** (uuid) NULLABLE: YES
- **recommendation_type** (USER-DEFINED) NULLABLE: NO
- **recommended_items** (jsonb) NULLABLE: NO
- **model_version** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ai_recommendations_pkey → ai_recommendations(id)
- **CHECK**: 2200_65791_1_not_null
- **CHECK**: 2200_65791_2_not_null
- **CHECK**: 2200_65791_5_not_null
- **CHECK**: 2200_65791_6_not_null

### Indexes
- ai_recommendations_pkey: CREATE UNIQUE INDEX ai_recommendations_pkey ON public.ai_recommendations USING btree (id)
- idx_ai_recommendations_merchant_id: CREATE INDEX idx_ai_recommendations_merchant_id ON public.ai_recommendations USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: ai_tasks

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **task_type** (USER-DEFINED) NULLABLE: NO
- **input_data** (jsonb) NULLABLE: NO
- **output_data** (jsonb) NULLABLE: YES
- **error_message** (text) NULLABLE: YES
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::ai_task_status
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ai_tasks_pkey → ai_tasks(id)
- **CHECK**: 2200_65765_1_not_null
- **CHECK**: 2200_65765_2_not_null
- **CHECK**: 2200_65765_3_not_null
- **CHECK**: 2200_65765_4_not_null
- **CHECK**: 2200_65765_7_not_null

### Indexes
- ai_tasks_pkey: CREATE UNIQUE INDEX ai_tasks_pkey ON public.ai_tasks USING btree (id)
- idx_ai_tasks_merchant_id: CREATE INDEX idx_ai_tasks_merchant_id ON public.ai_tasks USING btree (merchant_id)
- idx_ai_tasks_status: CREATE INDEX idx_ai_tasks_status ON public.ai_tasks USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: analytics_customer_metrics

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **total_orders** (integer) NULLABLE: YES, DEFAULT: 0
- **total_spent** (numeric) NULLABLE: YES, DEFAULT: 0
- **average_order_value** (numeric) NULLABLE: YES, DEFAULT: 0
- **last_order_at** (timestamp with time zone) NULLABLE: YES
- **first_order_at** (timestamp with time zone) NULLABLE: YES
- **rfm_score** (integer) NULLABLE: YES
- **segment** (text) NULLABLE: YES
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: analytics_customer_metrics_merchant_id_customer_id_key → analytics_customer_metrics(customer_id)
- **UNIQUE**: analytics_customer_metrics_merchant_id_customer_id_key → analytics_customer_metrics(merchant_id)
- **UNIQUE**: analytics_customer_metrics_merchant_id_customer_id_key → analytics_customer_metrics(customer_id)
- **UNIQUE**: analytics_customer_metrics_merchant_id_customer_id_key → analytics_customer_metrics(merchant_id)
- **PRIMARY KEY**: analytics_customer_metrics_pkey → analytics_customer_metrics(id)
- **CHECK**: 2200_65711_1_not_null
- **CHECK**: 2200_65711_2_not_null
- **CHECK**: 2200_65711_3_not_null

### Indexes
- analytics_customer_metrics_pkey: CREATE UNIQUE INDEX analytics_customer_metrics_pkey ON public.analytics_customer_metrics USING btree (id)
- analytics_customer_metrics_merchant_id_customer_id_key: CREATE UNIQUE INDEX analytics_customer_metrics_merchant_id_customer_id_key ON public.analytics_customer_metrics USING btree (merchant_id, customer_id)
- idx_analytics_customer_metrics_merchant_id: CREATE INDEX idx_analytics_customer_metrics_merchant_id ON public.analytics_customer_metrics USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: analytics_customers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **total_orders** (integer) NULLABLE: YES, DEFAULT: 0
- **total_spent** (numeric) NULLABLE: YES, DEFAULT: 0
- **avg_order_value** (numeric) NULLABLE: YES, DEFAULT: 0
- **last_order_at** (timestamp with time zone) NULLABLE: YES
- **first_order_at** (timestamp with time zone) NULLABLE: YES
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: analytics_customers_customer_id_key → analytics_customers(customer_id)
- **PRIMARY KEY**: analytics_customers_pkey → analytics_customers(id)
- **CHECK**: 2200_67183_1_not_null
- **CHECK**: 2200_67183_2_not_null
- **CHECK**: 2200_67183_3_not_null

### Indexes
- analytics_customers_pkey: CREATE UNIQUE INDEX analytics_customers_pkey ON public.analytics_customers USING btree (id)
- analytics_customers_customer_id_key: CREATE UNIQUE INDEX analytics_customers_customer_id_key ON public.analytics_customers USING btree (customer_id)
- idx_analytics_customers_merchant_id: CREATE INDEX idx_analytics_customers_merchant_id ON public.analytics_customers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: analytics_daily

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **date** (date) NULLABLE: NO
- **total_orders** (integer) NULLABLE: YES, DEFAULT: 0
- **total_revenue** (numeric) NULLABLE: YES, DEFAULT: 0
- **total_customers** (integer) NULLABLE: YES, DEFAULT: 0
- **product_views** (integer) NULLABLE: YES, DEFAULT: 0
- **add_to_cart** (integer) NULLABLE: YES, DEFAULT: 0
- **conversions** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: analytics_daily_merchant_id_date_key → analytics_daily(date)
- **UNIQUE**: analytics_daily_merchant_id_date_key → analytics_daily(merchant_id)
- **UNIQUE**: analytics_daily_merchant_id_date_key → analytics_daily(date)
- **UNIQUE**: analytics_daily_merchant_id_date_key → analytics_daily(merchant_id)
- **PRIMARY KEY**: analytics_daily_pkey → analytics_daily(id)
- **CHECK**: 2200_67153_1_not_null
- **CHECK**: 2200_67153_2_not_null
- **CHECK**: 2200_67153_3_not_null

### Indexes
- analytics_daily_pkey: CREATE UNIQUE INDEX analytics_daily_pkey ON public.analytics_daily USING btree (id)
- analytics_daily_merchant_id_date_key: CREATE UNIQUE INDEX analytics_daily_merchant_id_date_key ON public.analytics_daily USING btree (merchant_id, date)
- idx_analytics_daily_merchant_id: CREATE INDEX idx_analytics_daily_merchant_id ON public.analytics_daily USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: analytics_daily_rollups

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **date** (date) NULLABLE: NO
- **total_orders** (integer) NULLABLE: YES, DEFAULT: 0
- **total_sales** (numeric) NULLABLE: YES, DEFAULT: 0
- **total_customers** (integer) NULLABLE: YES, DEFAULT: 0
- **total_products_viewed** (integer) NULLABLE: YES, DEFAULT: 0
- **total_add_to_cart** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: analytics_daily_rollups_merchant_id_date_key → analytics_daily_rollups(date)
- **UNIQUE**: analytics_daily_rollups_merchant_id_date_key → analytics_daily_rollups(merchant_id)
- **UNIQUE**: analytics_daily_rollups_merchant_id_date_key → analytics_daily_rollups(date)
- **UNIQUE**: analytics_daily_rollups_merchant_id_date_key → analytics_daily_rollups(merchant_id)
- **PRIMARY KEY**: analytics_daily_rollups_pkey → analytics_daily_rollups(id)
- **CHECK**: 2200_65696_1_not_null
- **CHECK**: 2200_65696_2_not_null
- **CHECK**: 2200_65696_3_not_null

### Indexes
- analytics_daily_rollups_pkey: CREATE UNIQUE INDEX analytics_daily_rollups_pkey ON public.analytics_daily_rollups USING btree (id)
- analytics_daily_rollups_merchant_id_date_key: CREATE UNIQUE INDEX analytics_daily_rollups_merchant_id_date_key ON public.analytics_daily_rollups USING btree (merchant_id, date)
- idx_analytics_daily_rollups_merchant_id: CREATE INDEX idx_analytics_daily_rollups_merchant_id ON public.analytics_daily_rollups USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: analytics_events

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **session_id** (uuid) NULLABLE: YES
- **order_id** (uuid) NULLABLE: YES
- **product_id** (uuid) NULLABLE: YES
- **variant_id** (uuid) NULLABLE: YES
- **event_name** (text) NULLABLE: NO
- **event_data** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **device** (text) NULLABLE: YES
- **platform** (text) NULLABLE: YES
- **browser** (text) NULLABLE: YES
- **ip_address** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: analytics_events_pkey → analytics_events(id)
- **CHECK**: 2200_65683_1_not_null
- **CHECK**: 2200_65683_2_not_null
- **CHECK**: 2200_65683_8_not_null

### Indexes
- analytics_events_pkey: CREATE UNIQUE INDEX analytics_events_pkey ON public.analytics_events USING btree (id)
- idx_analytics_events_merchant_id: CREATE INDEX idx_analytics_events_merchant_id ON public.analytics_events USING btree (merchant_id)
- idx_analytics_events_event_name: CREATE INDEX idx_analytics_events_event_name ON public.analytics_events USING btree (event_name)
- idx_analytics_events_created_at: CREATE INDEX idx_analytics_events_created_at ON public.analytics_events USING btree (created_at)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: analytics_events_adv

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **event_name** (text) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **product_id** (uuid) NULLABLE: YES
- **order_id** (uuid) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: analytics_events_adv_pkey → analytics_events_adv(id)
- **CHECK**: 2200_67196_1_not_null
- **CHECK**: 2200_67196_2_not_null
- **CHECK**: 2200_67196_3_not_null

### Indexes
- analytics_events_adv_pkey: CREATE UNIQUE INDEX analytics_events_adv_pkey ON public.analytics_events_adv USING btree (id)
- idx_analytics_events_adv_event_name: CREATE INDEX idx_analytics_events_adv_event_name ON public.analytics_events_adv USING btree (event_name)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: analytics_product_metrics

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **views** (integer) NULLABLE: YES, DEFAULT: 0
- **add_to_cart** (integer) NULLABLE: YES, DEFAULT: 0
- **purchases** (integer) NULLABLE: YES, DEFAULT: 0
- **conversion_rate** (numeric) NULLABLE: YES, DEFAULT: 0
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: analytics_product_metrics_merchant_id_product_id_key → analytics_product_metrics(merchant_id)
- **UNIQUE**: analytics_product_metrics_merchant_id_product_id_key → analytics_product_metrics(product_id)
- **UNIQUE**: analytics_product_metrics_merchant_id_product_id_key → analytics_product_metrics(merchant_id)
- **UNIQUE**: analytics_product_metrics_merchant_id_product_id_key → analytics_product_metrics(product_id)
- **PRIMARY KEY**: analytics_product_metrics_pkey → analytics_product_metrics(id)
- **CHECK**: 2200_65726_1_not_null
- **CHECK**: 2200_65726_2_not_null
- **CHECK**: 2200_65726_3_not_null

### Indexes
- analytics_product_metrics_pkey: CREATE UNIQUE INDEX analytics_product_metrics_pkey ON public.analytics_product_metrics USING btree (id)
- analytics_product_metrics_merchant_id_product_id_key: CREATE UNIQUE INDEX analytics_product_metrics_merchant_id_product_id_key ON public.analytics_product_metrics USING btree (merchant_id, product_id)
- idx_analytics_product_metrics_merchant_id: CREATE INDEX idx_analytics_product_metrics_merchant_id ON public.analytics_product_metrics USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: analytics_products

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **views** (integer) NULLABLE: YES, DEFAULT: 0
- **add_to_cart** (integer) NULLABLE: YES, DEFAULT: 0
- **purchases** (integer) NULLABLE: YES, DEFAULT: 0
- **revenue** (numeric) NULLABLE: YES, DEFAULT: 0
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: analytics_products_pkey → analytics_products(id)
- **UNIQUE**: analytics_products_product_id_key → analytics_products(product_id)
- **CHECK**: 2200_67169_1_not_null
- **CHECK**: 2200_67169_2_not_null
- **CHECK**: 2200_67169_3_not_null

### Indexes
- analytics_products_pkey: CREATE UNIQUE INDEX analytics_products_pkey ON public.analytics_products USING btree (id)
- analytics_products_product_id_key: CREATE UNIQUE INDEX analytics_products_product_id_key ON public.analytics_products USING btree (product_id)
- idx_analytics_products_merchant_id: CREATE INDEX idx_analytics_products_merchant_id ON public.analytics_products USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: audit_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: YES
- **user_id** (uuid) NULLABLE: YES
- **customer_id** (uuid) NULLABLE: YES
- **action** (text) NULLABLE: NO
- **entity_type** (text) NULLABLE: YES
- **entity_id** (uuid) NULLABLE: YES
- **old_values** (jsonb) NULLABLE: YES
- **new_values** (jsonb) NULLABLE: YES
- **ip_address** (text) NULLABLE: YES
- **user_agent** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: audit_logs_pkey → audit_logs(id)
- **CHECK**: 2200_67455_1_not_null
- **CHECK**: 2200_67455_5_not_null

### Indexes
- audit_logs_pkey: CREATE UNIQUE INDEX audit_logs_pkey ON public.audit_logs USING btree (id)
- idx_audit_logs_merchant_id: CREATE INDEX idx_audit_logs_merchant_id ON public.audit_logs USING btree (merchant_id)
- idx_audit_logs_user_id: CREATE INDEX idx_audit_logs_user_id ON public.audit_logs USING btree (user_id)
- idx_audit_logs_entity: CREATE INDEX idx_audit_logs_entity ON public.audit_logs USING btree (entity_type, entity_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: blog_categories

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **slug** (text) NULLABLE: YES
- **description** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: blog_categories_pkey → blog_categories(id)
- **UNIQUE**: blog_categories_slug_key → blog_categories(slug)
- **CHECK**: 2200_67329_1_not_null
- **CHECK**: 2200_67329_2_not_null
- **CHECK**: 2200_67329_3_not_null

### Indexes
- blog_categories_pkey: CREATE UNIQUE INDEX blog_categories_pkey ON public.blog_categories USING btree (id)
- blog_categories_slug_key: CREATE UNIQUE INDEX blog_categories_slug_key ON public.blog_categories USING btree (slug)
- idx_blog_categories_merchant_id: CREATE INDEX idx_blog_categories_merchant_id ON public.blog_categories USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: blog_comments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **post_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **comment** (text) NULLABLE: NO
- **is_approved** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: blog_comments_pkey → blog_comments(id)
- **CHECK**: 2200_67382_1_not_null
- **CHECK**: 2200_67382_2_not_null
- **CHECK**: 2200_67382_4_not_null

### Indexes
- blog_comments_pkey: CREATE UNIQUE INDEX blog_comments_pkey ON public.blog_comments USING btree (id)
- idx_blog_comments_post_id: CREATE INDEX idx_blog_comments_post_id ON public.blog_comments USING btree (post_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ## 🗂️ Table: blog_post_tags

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **post_id** (uuid) NULLABLE: NO
- **tag_id** (uuid) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: blog_post_tags_pkey → blog_post_tags(id)
- **CHECK**: 2200_67374_1_not_null
- **CHECK**: 2200_67374_2_not_null
- **CHECK**: 2200_67374_3_not_null

### Indexes
- blog_post_tags_pkey: CREATE UNIQUE INDEX blog_post_tags_pkey ON public.blog_post_tags USING btree (id)
- idx_blog_post_tags_post_id: CREATE INDEX idx_blog_post_tags_post_id ON public.blog_post_tags USING btree (post_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: blog_posts

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **category_id** (uuid) NULLABLE: YES
- **title** (text) NULLABLE: NO
- **slug** (text) NULLABLE: NO
- **content** (text) NULLABLE: NO
- **cover_image** (text) NULLABLE: YES
- **seo** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_published** (boolean) NULLABLE: YES, DEFAULT: true
- **views** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: blog_posts_pkey → blog_posts(id)
- **UNIQUE**: blog_posts_slug_key → blog_posts(slug)
- **FOREIGN KEY**: fk_blog_posts_category → blog_categories(id)
- **CHECK**: 2200_67341_1_not_null
- **CHECK**: 2200_67341_2_not_null
- **CHECK**: 2200_67341_4_not_null
- **CHECK**: 2200_67341_5_not_null
- **CHECK**: 2200_67341_6_not_null

### Indexes
- blog_posts_pkey: CREATE UNIQUE INDEX blog_posts_pkey ON public.blog_posts USING btree (id)
- blog_posts_slug_key: CREATE UNIQUE INDEX blog_posts_slug_key ON public.blog_posts USING btree (slug)
- idx_blog_posts_category_id: CREATE INDEX idx_blog_posts_category_id ON public.blog_posts USING btree (category_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: blog_tags

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **slug** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: blog_tags_pkey → blog_tags(id)
- **UNIQUE**: blog_tags_slug_key → blog_tags(slug)
- **CHECK**: 2200_67362_1_not_null
- **CHECK**: 2200_67362_2_not_null
- **CHECK**: 2200_67362_3_not_null
- **CHECK**: 2200_67362_4_not_null

### Indexes
- blog_tags_pkey: CREATE UNIQUE INDEX blog_tags_pkey ON public.blog_tags USING btree (id)
- blog_tags_slug_key: CREATE UNIQUE INDEX blog_tags_slug_key ON public.blog_tags USING btree (slug)
- idx_blog_tags_merchant_id: CREATE INDEX idx_blog_tags_merchant_id ON public.blog_tags USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: bundle_analytics

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **bundle_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **views** (integer) NULLABLE: YES, DEFAULT: 0
- **add_to_cart** (integer) NULLABLE: YES, DEFAULT: 0
- **purchases** (integer) NULLABLE: YES, DEFAULT: 0
- **revenue** (numeric) NULLABLE: YES, DEFAULT: 0
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: bundle_analytics_bundle_id_key → bundle_analytics(bundle_id)
- **PRIMARY KEY**: bundle_analytics_pkey → bundle_analytics(id)
- **CHECK**: 2200_66509_1_not_null
- **CHECK**: 2200_66509_2_not_null
- **CHECK**: 2200_66509_3_not_null

### Indexes
- bundle_analytics_pkey: CREATE UNIQUE INDEX bundle_analytics_pkey ON public.bundle_analytics USING btree (id)
- bundle_analytics_bundle_id_key: CREATE UNIQUE INDEX bundle_analytics_bundle_id_key ON public.bundle_analytics USING btree (bundle_id)
- idx_bundle_analytics_merchant_id: CREATE INDEX idx_bundle_analytics_merchant_id ON public.bundle_analytics USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: bundle_items

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **bundle_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **quantity** (integer) NULLABLE: NO, DEFAULT: 1
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: bundle_items_pkey → bundle_items(id)
- **FOREIGN KEY**: fk_bundle_items_bundle → bundles(id)
- **CHECK**: 2200_66479_1_not_null
- **CHECK**: 2200_66479_2_not_null
- **CHECK**: 2200_66479_3_not_null
- **CHECK**: 2200_66479_5_not_null

### Indexes
- bundle_items_pkey: CREATE UNIQUE INDEX bundle_items_pkey ON public.bundle_items USING btree (id)
- idx_bundle_items_bundle_id: CREATE INDEX idx_bundle_items_bundle_id ON public.bundle_items USING btree (bundle_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: bundle_pricing_rules

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **bundle_id** (uuid) NULLABLE: NO
- **rule_type** (text) NULLABLE: NO
- **rule_value** (jsonb) NULLABLE: NO
- **discount_type** (text) NULLABLE: YES
- **discount_value** (numeric) NULLABLE: YES
- **starts_at** (timestamp with time zone) NULLABLE: YES
- **ends_at** (timestamp with time zone) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: bundle_pricing_rules_pkey → bundle_pricing_rules(id)
- **FOREIGN KEY**: fk_bundle_pricing_rules_bundle → bundles(id)
- **CHECK**: 2200_66493_1_not_null
- **CHECK**: 2200_66493_2_not_null
- **CHECK**: 2200_66493_3_not_null
- **CHECK**: 2200_66493_4_not_null

### Indexes
- bundle_pricing_rules_pkey: CREATE UNIQUE INDEX bundle_pricing_rules_pkey ON public.bundle_pricing_rules USING btree (id)
- idx_bundle_pricing_rules_bundle_id: CREATE INDEX idx_bundle_pricing_rules_bundle_id ON public.bundle_pricing_rules USING btree (bundle_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: bundles

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **slug** (text) NULLABLE: YES
- **description** (text) NULLABLE: YES
- **image_url** (text) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **is_featured** (boolean) NULLABLE: YES, DEFAULT: false
- **base_price** (numeric) NULLABLE: YES
- **discount_type** (text) NULLABLE: YES
- **discount_value** (numeric) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: bundles_pkey → bundles(id)
- **UNIQUE**: bundles_slug_key → bundles(slug)
- **CHECK**: 2200_66463_1_not_null
- **CHECK**: 2200_66463_2_not_null
- **CHECK**: 2200_66463_3_not_null

### Indexes
- idx_bundles_merchant_id: CREATE INDEX idx_bundles_merchant_id ON public.bundles USING btree (merchant_id)
- bundles_pkey: CREATE UNIQUE INDEX bundles_pkey ON public.bundles USING btree (id)
- bundles_slug_key: CREATE UNIQUE INDEX bundles_slug_key ON public.bundles USING btree (slug)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: chat_messages

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **thread_id** (uuid) NULLABLE: NO
- **sender_type** (text) NULLABLE: NO
- **sender_id** (uuid) NULLABLE: NO
- **message** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: chat_messages_pkey → chat_messages(id)
- **CHECK**: 2200_67659_1_not_null
- **CHECK**: 2200_67659_2_not_null
- **CHECK**: 2200_67659_3_not_null
- **CHECK**: 2200_67659_4_not_null
- **CHECK**: 2200_67659_5_not_null

### Indexes
- chat_messages_pkey: CREATE UNIQUE INDEX chat_messages_pkey ON public.chat_messages USING btree (id)
- idx_chat_messages_thread_id: CREATE INDEX idx_chat_messages_thread_id ON public.chat_messages USING btree (thread_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: chat_threads

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **last_message_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: chat_threads_pkey → chat_threads(id)
- **CHECK**: 2200_67650_1_not_null
- **CHECK**: 2200_67650_2_not_null
- **CHECK**: 2200_67650_3_not_null

### Indexes
- chat_threads_pkey: CREATE UNIQUE INDEX chat_threads_pkey ON public.chat_threads USING btree (id)
- idx_chat_threads_merchant_id: CREATE INDEX idx_chat_threads_merchant_id ON public.chat_threads USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: coupon_uses

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **coupon_id** (uuid) NULLABLE: NO
- **order_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **discount_amount** (numeric) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **CHECK**: coupon_uses_discount_amount_check → coupon_uses(discount_amount)
- **PRIMARY KEY**: coupon_uses_pkey → coupon_uses(id)
- **FOREIGN KEY**: fk_coupon_uses_coupon → coupons(id)
- **CHECK**: 2200_65668_1_not_null
- **CHECK**: 2200_65668_2_not_null
- **CHECK**: 2200_65668_3_not_null
- **CHECK**: 2200_65668_5_not_null
- **CHECK**: 2200_65668_6_not_null

### Indexes
- coupon_uses_pkey: CREATE UNIQUE INDEX coupon_uses_pkey ON public.coupon_uses USING btree (id)
- idx_coupon_uses_coupon_id: CREATE INDEX idx_coupon_uses_coupon_id ON public.coupon_uses USING btree (coupon_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: coupons

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **type** (USER-DEFINED) NULLABLE: NO
- **value** (numeric) NULLABLE: NO
- **max_discount** (numeric) NULLABLE: YES
- **min_order_amount** (numeric) NULLABLE: YES, DEFAULT: 0
- **usage_limit** (integer) NULLABLE: YES
- **usage_limit_per_customer** (integer) NULLABLE: YES
- **starts_at** (timestamp with time zone) NULLABLE: YES
- **ends_at** (timestamp with time zone) NULLABLE: YES
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'active'::coupon_status
- **applies_to_products** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **applies_to_categories** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: coupons_code_key → coupons(code)
- **CHECK**: coupons_max_discount_check → coupons(max_discount)
- **CHECK**: coupons_min_order_amount_check → coupons(min_order_amount)
- **PRIMARY KEY**: coupons_pkey → coupons(id)
- **CHECK**: coupons_value_check → coupons(value)
- **CHECK**: 2200_65647_1_not_null
- **CHECK**: 2200_65647_2_not_null
- **CHECK**: 2200_65647_3_not_null
- **CHECK**: 2200_65647_4_not_null
- **CHECK**: 2200_65647_5_not_null
- **CHECK**: 2200_65647_12_not_null

### Indexes
- coupons_pkey: CREATE UNIQUE INDEX coupons_pkey ON public.coupons USING btree (id)
- coupons_code_key: CREATE UNIQUE INDEX coupons_code_key ON public.coupons USING btree (code)
- idx_coupons_merchant_id: CREATE INDEX idx_coupons_merchant_id ON public.coupons USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: course_certificates

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **course_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **certificate_url** (text) NULLABLE: YES
- **issued_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: course_certificates_course_id_customer_id_key → course_certificates(course_id)
- **UNIQUE**: course_certificates_course_id_customer_id_key → course_certificates(customer_id)
- **UNIQUE**: course_certificates_course_id_customer_id_key → course_certificates(course_id)
- **UNIQUE**: course_certificates_course_id_customer_id_key → course_certificates(customer_id)
- **PRIMARY KEY**: course_certificates_pkey → course_certificates(id)
- **CHECK**: 2200_66450_1_not_null
- **CHECK**: 2200_66450_2_not_null
- **CHECK**: 2200_66450_3_not_null

### Indexes
- course_certificates_pkey: CREATE UNIQUE INDEX course_certificates_pkey ON public.course_certificates USING btree (id)
- course_certificates_course_id_customer_id_key: CREATE UNIQUE INDEX course_certificates_course_id_customer_id_key ON public.course_certificates USING btree (course_id, customer_id)
- idx_course_certificates_course_id: CREATE INDEX idx_course_certificates_course_id ON public.course_certificates USING btree (course_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: course_enrollments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **course_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **enrolled_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **completed_at** (timestamp with time zone) NULLABLE: YES

### Constraints
- **UNIQUE**: course_enrollments_course_id_customer_id_key → course_enrollments(course_id)
- **UNIQUE**: course_enrollments_course_id_customer_id_key → course_enrollments(customer_id)
- **UNIQUE**: course_enrollments_course_id_customer_id_key → course_enrollments(course_id)
- **UNIQUE**: course_enrollments_course_id_customer_id_key → course_enrollments(customer_id)
- **PRIMARY KEY**: course_enrollments_pkey → course_enrollments(id)
- **CHECK**: 2200_66429_1_not_null
- **CHECK**: 2200_66429_2_not_null
- **CHECK**: 2200_66429_3_not_null
- **CHECK**: 2200_66429_4_not_null

### Indexes
- course_enrollments_pkey: CREATE UNIQUE INDEX course_enrollments_pkey ON public.course_enrollments USING btree (id)
- course_enrollments_course_id_customer_id_key: CREATE UNIQUE INDEX course_enrollments_course_id_customer_id_key ON public.course_enrollments USING btree (course_id, customer_id)
- idx_course_enrollments_course_id: CREATE INDEX idx_course_enrollments_course_id ON public.course_enrollments USING btree (course_id)
- idx_course_enrollments_customer_id: CREATE INDEX idx_course_enrollments_customer_id ON public.course_enrollments USING btree (customer_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: course_lessons

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **course_id** (uuid) NULLABLE: NO
- **section_id** (uuid) NULLABLE: NO
- **title** (text) NULLABLE: NO
- **type** (USER-DEFINED) NULLABLE: NO
- **content** (text) NULLABLE: YES
- **video_url** (text) NULLABLE: YES
- **file_url** (text) NULLABLE: YES
- **duration_seconds** (integer) NULLABLE: YES
- **sort_order** (integer) NULLABLE: YES, DEFAULT: 0
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: course_lessons_pkey → course_lessons(id)
- **FOREIGN KEY**: fk_course_lessons_course → courses(id)
- **FOREIGN KEY**: fk_course_lessons_section → course_sections(id)
- **CHECK**: 2200_66407_1_not_null
- **CHECK**: 2200_66407_2_not_null
- **CHECK**: 2200_66407_3_not_null
- **CHECK**: 2200_66407_4_not_null
- **CHECK**: 2200_66407_5_not_null

### Indexes
- course_lessons_pkey: CREATE UNIQUE INDEX course_lessons_pkey ON public.course_lessons USING btree (id)
- idx_course_lessons_course_id: CREATE INDEX idx_course_lessons_course_id ON public.course_lessons USING btree (course_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: course_progress

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **course_id** (uuid) NULLABLE: NO
- **lesson_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **is_completed** (boolean) NULLABLE: YES, DEFAULT: false
- **completed_at** (timestamp with time zone) NULLABLE: YES

### Constraints
- **UNIQUE**: course_progress_lesson_id_customer_id_key → course_progress(customer_id)
- **UNIQUE**: course_progress_lesson_id_customer_id_key → course_progress(lesson_id)
- **UNIQUE**: course_progress_lesson_id_customer_id_key → course_progress(customer_id)
- **UNIQUE**: course_progress_lesson_id_customer_id_key → course_progress(lesson_id)
- **PRIMARY KEY**: course_progress_pkey → course_progress(id)
- **CHECK**: 2200_66440_1_not_null
- **CHECK**: 2200_66440_2_not_null
- **CHECK**: 2200_66440_3_not_null
- **CHECK**: 2200_66440_4_not_null

### Indexes
- course_progress_pkey: CREATE UNIQUE INDEX course_progress_pkey ON public.course_progress USING btree (id)
- course_progress_lesson_id_customer_id_key: CREATE UNIQUE INDEX course_progress_lesson_id_customer_id_key ON public.course_progress USING btree (lesson_id, customer_id)
- idx_course_progress_customer_id: CREATE INDEX idx_course_progress_customer_id ON public.course_progress USING btree (customer_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: course_sections

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **course_id** (uuid) NULLABLE: NO
- **title** (text) NULLABLE: NO
- **sort_order** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: course_sections_pkey → course_sections(id)
- **FOREIGN KEY**: fk_course_sections_course → courses(id)
- **CHECK**: 2200_66381_1_not_null
- **CHECK**: 2200_66381_2_not_null
- **CHECK**: 2200_66381_3_not_null

### Indexes
- course_sections_pkey: CREATE UNIQUE INDEX course_sections_pkey ON public.course_sections USING btree (id)
- idx_course_sections_course_id: CREATE INDEX idx_course_sections_course_id ON public.course_sections USING btree (course_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: courses

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **title** (text) NULLABLE: NO
- **slug** (text) NULLABLE: YES
- **description** (text) NULLABLE: YES
- **thumbnail_url** (text) NULLABLE: YES
- **price** (numeric) NULLABLE: YES, DEFAULT: 0
- **is_free** (boolean) NULLABLE: YES, DEFAULT: false
- **is_published** (boolean) NULLABLE: YES, DEFAULT: false
- **published_at** (timestamp with time zone) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: courses_pkey → courses(id)
- **UNIQUE**: courses_slug_key → courses(slug)
- **CHECK**: 2200_66364_1_not_null
- **CHECK**: 2200_66364_2_not_null
- **CHECK**: 2200_66364_3_not_null

### Indexes
- courses_pkey: CREATE UNIQUE INDEX courses_pkey ON public.courses USING btree (id)
- courses_slug_key: CREATE UNIQUE INDEX courses_slug_key ON public.courses USING btree (slug)
- idx_courses_merchant_id: CREATE INDEX idx_courses_merchant_id ON public.courses USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: customer_addresses

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **customer_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **type** (USER-DEFINED) NULLABLE: NO
- **name** (text) NULLABLE: YES
- **phone** (text) NULLABLE: YES
- **email** (text) NULLABLE: YES
- **country** (text) NULLABLE: YES
- **city** (text) NULLABLE: YES
- **district** (text) NULLABLE: YES
- **street** (text) NULLABLE: YES
- **building_number** (text) NULLABLE: YES
- **apartment_number** (text) NULLABLE: YES
- **postal_code** (text) NULLABLE: YES
- **latitude** (numeric) NULLABLE: YES
- **longitude** (numeric) NULLABLE: YES
- **is_default** (boolean) NULLABLE: YES, DEFAULT: false
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: customer_addresses_pkey → customer_addresses(id)
- **FOREIGN KEY**: fk_customer_addresses_customer → customers(id)
- **CHECK**: 2200_65509_1_not_null
- **CHECK**: 2200_65509_2_not_null
- **CHECK**: 2200_65509_3_not_null
- **CHECK**: 2200_65509_4_not_null

### Indexes
- customer_addresses_pkey: CREATE UNIQUE INDEX customer_addresses_pkey ON public.customer_addresses USING btree (id)
- idx_customer_addresses_customer_id: CREATE INDEX idx_customer_addresses_customer_id ON public.customer_addresses USING btree (customer_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: customer_segments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **rules** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_dynamic** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: customer_segments_pkey → customer_segments(id)
- **CHECK**: 2200_65526_1_not_null
- **CHECK**: 2200_65526_2_not_null
- **CHECK**: 2200_65526_3_not_null

### Indexes
- customer_segments_pkey: CREATE UNIQUE INDEX customer_segments_pkey ON public.customer_segments USING btree (id)
- idx_customer_segments_merchant_id: CREATE INDEX idx_customer_segments_merchant_id ON public.customer_segments USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: customer_tag_assignments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **customer_id** (uuid) NULLABLE: NO
- **tag_id** (uuid) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: customer_tag_assignments_customer_id_tag_id_key → customer_tag_assignments(customer_id)
- **UNIQUE**: customer_tag_assignments_customer_id_tag_id_key → customer_tag_assignments(tag_id)
- **UNIQUE**: customer_tag_assignments_customer_id_tag_id_key → customer_tag_assignments(customer_id)
- **UNIQUE**: customer_tag_assignments_customer_id_tag_id_key → customer_tag_assignments(tag_id)
- **PRIMARY KEY**: customer_tag_assignments_pkey → customer_tag_assignments(id)
- **FOREIGN KEY**: fk_customer_tag_assignments_customer → customers(id)
- **FOREIGN KEY**: fk_customer_tag_assignments_tag → customer_tags(id)
- **CHECK**: 2200_65550_1_not_null
- **CHECK**: 2200_65550_2_not_null
- **CHECK**: 2200_65550_3_not_null

### Indexes
- customer_tag_assignments_pkey: CREATE UNIQUE INDEX customer_tag_assignments_pkey ON public.customer_tag_assignments USING btree (id)
- customer_tag_assignments_customer_id_tag_id_key: CREATE UNIQUE INDEX customer_tag_assignments_customer_id_tag_id_key ON public.customer_tag_assignments USING btree (customer_id, tag_id)
- idx_customer_tag_assignments_customer_id: CREATE INDEX idx_customer_tag_assignments_customer_id ON public.customer_tag_assignments USING btree (customer_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: customer_tags

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **color** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: customer_tags_merchant_id_name_key → customer_tags(merchant_id)
- **UNIQUE**: customer_tags_merchant_id_name_key → customer_tags(name)
- **UNIQUE**: customer_tags_merchant_id_name_key → customer_tags(merchant_id)
- **UNIQUE**: customer_tags_merchant_id_name_key → customer_tags(name)
- **PRIMARY KEY**: customer_tags_pkey → customer_tags(id)
- **CHECK**: 2200_65538_1_not_null
- **CHECK**: 2200_65538_2_not_null
- **CHECK**: 2200_65538_3_not_null

### Indexes
- customer_tags_pkey: CREATE UNIQUE INDEX customer_tags_pkey ON public.customer_tags USING btree (id)
- customer_tags_merchant_id_name_key: CREATE UNIQUE INDEX customer_tags_merchant_id_name_key ON public.customer_tags USING btree (merchant_id, name)
- idx_customer_tags_merchant_id: CREATE INDEX idx_customer_tags_merchant_id ON public.customer_tags USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: customers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **first_name** (text) NULLABLE: YES
- **last_name** (text) NULLABLE: YES
- **full_name** (text) NULLABLE: YES
- **email** (text) NULLABLE: YES
- **phone** (text) NULLABLE: YES
- **email_verified** (boolean) NULLABLE: YES, DEFAULT: false
- **phone_verified** (boolean) NULLABLE: YES, DEFAULT: false
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'active'::customer_status
- **date_of_birth** (date) NULLABLE: YES
- **gender** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **password_hash** (text) NULLABLE: YES

### Constraints
- **UNIQUE**: customers_email_unique → customers(email)
- **PRIMARY KEY**: customers_pkey → customers(id)
- **CHECK**: 2200_65483_1_not_null
- **CHECK**: 2200_65483_10_not_null

### Indexes
- customers_pkey: CREATE UNIQUE INDEX customers_pkey ON public.customers USING btree (id)
- idx_customers_status: CREATE INDEX idx_customers_status ON public.customers USING btree (status)
- customers_email_unique: CREATE UNIQUE INDEX customers_email_unique ON public.customers USING btree (email)
- idx_customers_email: CREATE INDEX idx_customers_email ON public.customers USING btree (email)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: delivery_providers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **api_credentials** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **settings** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: delivery_providers_pkey → delivery_providers(id)
- **CHECK**: 2200_66523_1_not_null
- **CHECK**: 2200_66523_2_not_null
- **CHECK**: 2200_66523_3_not_null
- **CHECK**: 2200_66523_4_not_null

### Indexes
- delivery_providers_pkey: CREATE UNIQUE INDEX delivery_providers_pkey ON public.delivery_providers USING btree (id)
- idx_delivery_providers_merchant_id: CREATE INDEX idx_delivery_providers_merchant_id ON public.delivery_providers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: delivery_rates

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **provider_id** (uuid) NULLABLE: NO
- **zone_id** (uuid) NULLABLE: NO
- **min_weight** (numeric) NULLABLE: YES, DEFAULT: 0
- **max_weight** (numeric) NULLABLE: YES, DEFAULT: 100
- **base_price** (numeric) NULLABLE: NO
- **price_per_kg** (numeric) NULLABLE: YES, DEFAULT: 0
- **estimated_days** (integer) NULLABLE: YES, DEFAULT: 3
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: delivery_rates_pkey → delivery_rates(id)
- **FOREIGN KEY**: fk_delivery_rates_provider → delivery_providers(id)
- **FOREIGN KEY**: fk_delivery_rates_zone → delivery_zones(id)
- **CHECK**: 2200_66549_1_not_null
- **CHECK**: 2200_66549_2_not_null
- **CHECK**: 2200_66549_3_not_null
- **CHECK**: 2200_66549_4_not_null
- **CHECK**: 2200_66549_7_not_null

### Indexes
- delivery_rates_pkey: CREATE UNIQUE INDEX delivery_rates_pkey ON public.delivery_rates USING btree (id)
- idx_delivery_rates_merchant_id: CREATE INDEX idx_delivery_rates_merchant_id ON public.delivery_rates USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: delivery_webhooks

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **provider_id** (uuid) NULLABLE: NO
- **event_name** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: delivery_webhooks_pkey → delivery_webhooks(id)
- **CHECK**: 2200_66571_1_not_null
- **CHECK**: 2200_66571_2_not_null
- **CHECK**: 2200_66571_3_not_null
- **CHECK**: 2200_66571_4_not_null

### Indexes
- delivery_webhooks_pkey: CREATE UNIQUE INDEX delivery_webhooks_pkey ON public.delivery_webhooks USING btree (id)
- idx_delivery_webhooks_provider_id: CREATE INDEX idx_delivery_webhooks_provider_id ON public.delivery_webhooks USING btree (provider_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: delivery_zones

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **countries** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **cities** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: delivery_zones_pkey → delivery_zones(id)
- **CHECK**: 2200_66537_1_not_null
- **CHECK**: 2200_66537_2_not_null
- **CHECK**: 2200_66537_3_not_null

### Indexes
- delivery_zones_pkey: CREATE UNIQUE INDEX delivery_zones_pkey ON public.delivery_zones USING btree (id)
- idx_delivery_zones_merchant_id: CREATE INDEX idx_delivery_zones_merchant_id ON public.delivery_zones USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: ds_order_items

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **ds_order_id** (uuid) NULLABLE: NO
- **ds_variant_id** (uuid) NULLABLE: NO
- **quantity** (integer) NULLABLE: NO
- **cost** (numeric) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ds_order_items_pkey → ds_order_items(id)
- **FOREIGN KEY**: fk_ds_order_items_order → ds_orders(id)
- **CHECK**: 2200_66650_1_not_null
- **CHECK**: 2200_66650_2_not_null
- **CHECK**: 2200_66650_3_not_null
- **CHECK**: 2200_66650_4_not_null

### Indexes
- ds_order_items_pkey: CREATE UNIQUE INDEX ds_order_items_pkey ON public.ds_order_items USING btree (id)
- idx_ds_order_items_order_id: CREATE INDEX idx_ds_order_items_order_id ON public.ds_order_items USING btree (ds_order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ## 🗂️ Table: ds_orders

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **supplier_id** (uuid) NULLABLE: NO
- **order_id** (uuid) NULLABLE: NO
- **external_order_id** (text) NULLABLE: YES
- **status** (text) NULLABLE: NO, DEFAULT: 'pending'::text
- **tracking_number** (text) NULLABLE: YES
- **tracking_url** (text) NULLABLE: YES
- **cost** (numeric) NULLABLE: YES
- **currency** (text) NULLABLE: YES, DEFAULT: 'USD'::text
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ds_orders_pkey → ds_orders(id)
- **CHECK**: 2200_66636_1_not_null
- **CHECK**: 2200_66636_2_not_null
- **CHECK**: 2200_66636_3_not_null
- **CHECK**: 2200_66636_4_not_null
- **CHECK**: 2200_66636_6_not_null

### Indexes
- ds_orders_pkey: CREATE UNIQUE INDEX ds_orders_pkey ON public.ds_orders USING btree (id)
- idx_ds_orders_order_id: CREATE INDEX idx_ds_orders_order_id ON public.ds_orders USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: ds_products

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **supplier_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **external_id** (text) NULLABLE: NO
- **title** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **image_url** (text) NULLABLE: YES
- **price** (numeric) NULLABLE: YES
- **cost** (numeric) NULLABLE: YES
- **currency** (text) NULLABLE: YES, DEFAULT: 'USD'::text
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ds_products_pkey → ds_products(id)
- **CHECK**: 2200_66595_1_not_null
- **CHECK**: 2200_66595_2_not_null
- **CHECK**: 2200_66595_3_not_null
- **CHECK**: 2200_66595_4_not_null
- **CHECK**: 2200_66595_5_not_null

### Indexes
- ds_products_pkey: CREATE UNIQUE INDEX ds_products_pkey ON public.ds_products USING btree (id)
- idx_ds_products_supplier_id: CREATE INDEX idx_ds_products_supplier_id ON public.ds_products USING btree (supplier_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: ds_suppliers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **api_credentials** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **settings** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ds_suppliers_pkey → ds_suppliers(id)
- **CHECK**: 2200_66581_1_not_null
- **CHECK**: 2200_66581_2_not_null
- **CHECK**: 2200_66581_3_not_null
- **CHECK**: 2200_66581_4_not_null

### Indexes
- ds_suppliers_pkey: CREATE UNIQUE INDEX ds_suppliers_pkey ON public.ds_suppliers USING btree (id)
- idx_ds_suppliers_merchant_id: CREATE INDEX idx_ds_suppliers_merchant_id ON public.ds_suppliers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ## 🗂️ Table: ds_sync_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **supplier_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **sync_type** (text) NULLABLE: NO
- **status** (text) NULLABLE: NO
- **details** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **error_message** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ds_sync_logs_pkey → ds_sync_logs(id)
- **CHECK**: 2200_66625_1_not_null
- **CHECK**: 2200_66625_2_not_null
- **CHECK**: 2200_66625_3_not_null
- **CHECK**: 2200_66625_4_not_null
- **CHECK**: 2200_66625_5_not_null

### Indexes
- ds_sync_logs_pkey: CREATE UNIQUE INDEX ds_sync_logs_pkey ON public.ds_sync_logs USING btree (id)
- idx_ds_sync_logs_supplier_id: CREATE INDEX idx_ds_sync_logs_supplier_id ON public.ds_sync_logs USING btree (supplier_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: ds_variants

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **ds_product_id** (uuid) NULLABLE: NO
- **external_id** (text) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **price** (numeric) NULLABLE: YES
- **cost** (numeric) NULLABLE: YES
- **stock** (integer) NULLABLE: YES
- **image_url** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: ds_variants_pkey → ds_variants(id)
- **FOREIGN KEY**: fk_ds_variants_product → ds_products(id)
- **CHECK**: 2200_66609_1_not_null
- **CHECK**: 2200_66609_2_not_null
- **CHECK**: 2200_66609_3_not_null
- **CHECK**: 2200_66609_4_not_null

### Indexes
- ds_variants_pkey: CREATE UNIQUE INDEX ds_variants_pkey ON public.ds_variants USING btree (id)
- idx_ds_variants_product_id: CREATE INDEX idx_ds_variants_product_id ON public.ds_variants USING btree (ds_product_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: files_storage

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **file_url** (text) NULLABLE: NO
- **file_name** (text) NULLABLE: YES
- **file_type** (text) NULLABLE: YES
- **file_size** (integer) NULLABLE: YES
- **folder** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: files_storage_pkey → files_storage(id)
- **CHECK**: 2200_67393_1_not_null
- **CHECK**: 2200_67393_2_not_null
- **CHECK**: 2200_67393_3_not_null

### Indexes
- files_storage_pkey: CREATE UNIQUE INDEX files_storage_pkey ON public.files_storage USING btree (id)
- idx_files_storage_merchant_id: CREATE INDEX idx_files_storage_merchant_id ON public.files_storage USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ## 🗂️ Table: files_usage

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **file_id** (uuid) NULLABLE: NO
- **entity_type** (text) NULLABLE: NO
- **entity_id** (uuid) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: files_usage_pkey → files_usage(id)
- **CHECK**: 2200_67404_1_not_null
- **CHECK**: 2200_67404_2_not_null
- **CHECK**: 2200_67404_3_not_null
- **CHECK**: 2200_67404_4_not_null

### Indexes
- files_usage_pkey: CREATE UNIQUE INDEX files_usage_pkey ON public.files_usage USING btree (id)
- idx_files_usage_file_id: CREATE INDEX idx_files_usage_file_id ON public.files_usage USING btree (file_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: inventory_adjustments_adv

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **warehouse_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **old_quantity** (integer) NULLABLE: NO
- **new_quantity** (integer) NULLABLE: NO
- **reason** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: inventory_adjustments_adv_pkey → inventory_adjustments_adv(id)
- **CHECK**: 2200_66887_1_not_null
- **CHECK**: 2200_66887_2_not_null
- **CHECK**: 2200_66887_3_not_null
- **CHECK**: 2200_66887_4_not_null
- **CHECK**: 2200_66887_6_not_null
- **CHECK**: 2200_66887_7_not_null

### Indexes
- inventory_adjustments_adv_pkey: CREATE UNIQUE INDEX inventory_adjustments_adv_pkey ON public.inventory_adjustments_adv USING btree (id)
- idx_inventory_adjustments_adv_merchant_id: CREATE INDEX idx_inventory_adjustments_adv_merchant_id ON public.inventory_adjustments_adv USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: inventory_batches

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **inventory_item_id** (uuid) NULLABLE: NO
- **batch_code** (text) NULLABLE: YES
- **expiry_date** (date) NULLABLE: YES
- **quantity** (integer) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_inventory_batches_item → inventory_items(id)
- **PRIMARY KEY**: inventory_batches_pkey → inventory_batches(id)
- **CHECK**: inventory_batches_quantity_check → inventory_batches(quantity)
- **CHECK**: 2200_65276_1_not_null
- **CHECK**: 2200_65276_2_not_null
- **CHECK**: 2200_65276_5_not_null

### Indexes
- inventory_batches_pkey: CREATE UNIQUE INDEX inventory_batches_pkey ON public.inventory_batches USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ## 🗂️ Table: inventory_forecasting_adv

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **forecast_days** (integer) NULLABLE: NO
- **forecast_quantity** (integer) NULLABLE: NO
- **confidence** (numeric) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: inventory_forecasting_adv_pkey → inventory_forecasting_adv(id)
- **CHECK**: 2200_66898_1_not_null
- **CHECK**: 2200_66898_2_not_null
- **CHECK**: 2200_66898_3_not_null
- **CHECK**: 2200_66898_5_not_null
- **CHECK**: 2200_66898_6_not_null

### Indexes
- inventory_forecasting_adv_pkey: CREATE UNIQUE INDEX inventory_forecasting_adv_pkey ON public.inventory_forecasting_adv USING btree (id)
- idx_inventory_forecasting_adv_product_id: CREATE INDEX idx_inventory_forecasting_adv_product_id ON public.inventory_forecasting_adv USING btree (product_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: inventory_items

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **quantity** (integer) NULLABLE: NO, DEFAULT: 0
- **reserved** (integer) NULLABLE: NO, DEFAULT: 0
- **available** (integer) NULLABLE: YES
- **low_stock_threshold** (integer) NULLABLE: YES, DEFAULT: 5
- **warehouse_location** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_inventory_product → products(id)
- **CHECK**: inventory_items_low_stock_threshold_check → inventory_items(low_stock_threshold)
- **PRIMARY KEY**: inventory_items_pkey → inventory_items(id)
- **CHECK**: inventory_items_quantity_check → inventory_items(quantity)
- **CHECK**: inventory_items_reserved_check → inventory_items(reserved)
- **CHECK**: 2200_65203_1_not_null
- **CHECK**: 2200_65203_2_not_null
- **CHECK**: 2200_65203_4_not_null
- **CHECK**: 2200_65203_5_not_null
- **CHECK**: 2200_65203_6_not_null

### Indexes
- inventory_items_pkey: CREATE UNIQUE INDEX inventory_items_pkey ON public.inventory_items USING btree (id)
- idx_inventory_product_id: CREATE INDEX idx_inventory_product_id ON public.inventory_items USING btree (product_id)
- idx_inventory_variant_id: CREATE INDEX idx_inventory_variant_id ON public.inventory_items USING btree (variant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: inventory_items_advanced

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **warehouse_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **quantity** (integer) NULLABLE: NO, DEFAULT: 0
- **reserved** (integer) NULLABLE: NO, DEFAULT: 0
- **available** (integer) NULLABLE: YES
- **location_id** (uuid) NULLABLE: YES
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: inventory_items_advanced_pkey → inventory_items_advanced(id)
- **CHECK**: 2200_66852_1_not_null
- **CHECK**: 2200_66852_2_not_null
- **CHECK**: 2200_66852_3_not_null
- **CHECK**: 2200_66852_4_not_null
- **CHECK**: 2200_66852_6_not_null
- **CHECK**: 2200_66852_7_not_null

### Indexes
- inventory_items_advanced_pkey: CREATE UNIQUE INDEX inventory_items_advanced_pkey ON public.inventory_items_advanced USING btree (id)
- idx_inventory_items_adv_merchant_id: CREATE INDEX idx_inventory_items_adv_merchant_id ON public.inventory_items_advanced USING btree (merchant_id)
- idx_inventory_items_adv_product_id: CREATE INDEX idx_inventory_items_adv_product_id ON public.inventory_items_advanced USING btree (product_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: inventory_movements

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **inventory_item_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **movement** (USER-DEFINED) NULLABLE: NO
- **quantity** (integer) NULLABLE: NO
- **reference_type** (text) NULLABLE: YES
- **reference_id** (uuid) NULLABLE: YES
- **note** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_inventory_movements_item → inventory_items(id)
- **PRIMARY KEY**: inventory_movements_pkey → inventory_movements(id)
- **CHECK**: inventory_movements_quantity_check → inventory_movements(quantity)
- **CHECK**: 2200_65241_1_not_null
- **CHECK**: 2200_65241_2_not_null
- **CHECK**: 2200_65241_3_not_null
- **CHECK**: 2200_65241_5_not_null
- **CHECK**: 2200_65241_6_not_null
- **CHECK**: 2200_65241_7_not_null

### Indexes
- inventory_movements_pkey: CREATE UNIQUE INDEX inventory_movements_pkey ON public.inventory_movements USING btree (id)
- idx_inventory_movements_item_id: CREATE INDEX idx_inventory_movements_item_id ON public.inventory_movements USING btree (inventory_item_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: inventory_reservations

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **inventory_item_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **order_id** (uuid) NULLABLE: YES
- **cart_id** (uuid) NULLABLE: YES
- **quantity** (integer) NULLABLE: NO
- **expires_at** (timestamp with time zone) NULLABLE: YES
- **released_at** (timestamp with time zone) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_inventory_reservations_item → inventory_items(id)
- **PRIMARY KEY**: inventory_reservations_pkey → inventory_reservations(id)
- **CHECK**: inventory_reservations_quantity_check → inventory_reservations(quantity)
- **CHECK**: 2200_65259_1_not_null
- **CHECK**: 2200_65259_2_not_null
- **CHECK**: 2200_65259_3_not_null
- **CHECK**: 2200_65259_5_not_null
- **CHECK**: 2200_65259_8_not_null

### Indexes
- inventory_reservations_pkey: CREATE UNIQUE INDEX inventory_reservations_pkey ON public.inventory_reservations USING btree (id)
- idx_inventory_reservations_item_id: CREATE INDEX idx_inventory_reservations_item_id ON public.inventory_reservations USING btree (inventory_item_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: inventory_reservations_adv

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **warehouse_id** (uuid) NULLABLE: NO
- **order_id** (uuid) NULLABLE: YES
- **quantity** (integer) NULLABLE: NO
- **expires_at** (timestamp with time zone) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: inventory_reservations_adv_pkey → inventory_reservations_adv(id)
- **CHECK**: 2200_66879_1_not_null
- **CHECK**: 2200_66879_2_not_null
- **CHECK**: 2200_66879_3_not_null
- **CHECK**: 2200_66879_5_not_null
- **CHECK**: 2200_66879_7_not_null

### Indexes
- inventory_reservations_adv_pkey: CREATE UNIQUE INDEX inventory_reservations_adv_pkey ON public.inventory_reservations_adv USING btree (id)
- idx_inventory_reservations_adv_order_id: CREATE INDEX idx_inventory_reservations_adv_order_id ON public.inventory_reservations_adv USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: loyalty_points

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **point_type** (USER-DEFINED) NULLABLE: NO
- **points** (integer) NULLABLE: NO
- **order_id** (uuid) NULLABLE: YES
- **reason** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: loyalty_points_pkey → loyalty_points(id)
- **CHECK**: 2200_66317_1_not_null
- **CHECK**: 2200_66317_2_not_null
- **CHECK**: 2200_66317_3_not_null
- **CHECK**: 2200_66317_4_not_null
- **CHECK**: 2200_66317_5_not_null

### Indexes
- loyalty_points_pkey: CREATE UNIQUE INDEX loyalty_points_pkey ON public.loyalty_points USING btree (id)
- idx_loyalty_points_customer_id: CREATE INDEX idx_loyalty_points_customer_id ON public.loyalty_points USING btree (customer_id)
- idx_loyalty_points_merchant_id: CREATE INDEX idx_loyalty_points_merchant_id ON public.loyalty_points USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: loyalty_programs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **is_enabled** (boolean) NULLABLE: YES, DEFAULT: true
- **earn_rate** (numeric) NULLABLE: YES, DEFAULT: 1
- **burn_rate** (numeric) NULLABLE: YES, DEFAULT: 0.05
- **min_points_to_redeem** (integer) NULLABLE: YES, DEFAULT: 100
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: loyalty_programs_merchant_id_key → loyalty_programs(merchant_id)
- **PRIMARY KEY**: loyalty_programs_pkey → loyalty_programs(id)
- **CHECK**: 2200_66291_1_not_null
- **CHECK**: 2200_66291_2_not_null

### Indexes
- loyalty_programs_pkey: CREATE UNIQUE INDEX loyalty_programs_pkey ON public.loyalty_programs USING btree (id)
- loyalty_programs_merchant_id_key: CREATE UNIQUE INDEX loyalty_programs_merchant_id_key ON public.loyalty_programs USING btree (merchant_id)
- idx_loyalty_programs_merchant_id: CREATE INDEX idx_loyalty_programs_merchant_id ON public.loyalty_programs USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: loyalty_redemptions

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **reward_id** (uuid) NULLABLE: NO
- **points_spent** (integer) NULLABLE: NO
- **order_id** (uuid) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: loyalty_redemptions_pkey → loyalty_redemptions(id)
- **CHECK**: 2200_66352_1_not_null
- **CHECK**: 2200_66352_2_not_null
- **CHECK**: 2200_66352_3_not_null
- **CHECK**: 2200_66352_4_not_null
- **CHECK**: 2200_66352_5_not_null

### Indexes
- loyalty_redemptions_pkey: CREATE UNIQUE INDEX loyalty_redemptions_pkey ON public.loyalty_redemptions USING btree (id)
- idx_loyalty_redemptions_customer_id: CREATE INDEX idx_loyalty_redemptions_customer_id ON public.loyalty_redemptions USING btree (customer_id)
- idx_loyalty_redemptions_merchant_id: CREATE INDEX idx_loyalty_redemptions_merchant_id ON public.loyalty_redemptions USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: loyalty_rewards

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **points_required** (integer) NULLABLE: NO
- **reward_type** (text) NULLABLE: NO
- **reward_value** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: loyalty_rewards_pkey → loyalty_rewards(id)
- **CHECK**: 2200_66339_1_not_null
- **CHECK**: 2200_66339_2_not_null
- **CHECK**: 2200_66339_3_not_null
- **CHECK**: 2200_66339_5_not_null
- **CHECK**: 2200_66339_6_not_null

### Indexes
- loyalty_rewards_pkey: CREATE UNIQUE INDEX loyalty_rewards_pkey ON public.loyalty_rewards USING btree (id)
- idx_loyalty_rewards_merchant_id: CREATE INDEX idx_loyalty_rewards_merchant_id ON public.loyalty_rewards USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: loyalty_tiers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **min_points** (integer) NULLABLE: NO
- **benefits** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: loyalty_tiers_pkey → loyalty_tiers(id)
- **CHECK**: 2200_66328_1_not_null
- **CHECK**: 2200_66328_2_not_null
- **CHECK**: 2200_66328_3_not_null
- **CHECK**: 2200_66328_4_not_null

### Indexes
- loyalty_tiers_pkey: CREATE UNIQUE INDEX loyalty_tiers_pkey ON public.loyalty_tiers USING btree (id)
- idx_loyalty_tiers_merchant_id: CREATE INDEX idx_loyalty_tiers_merchant_id ON public.loyalty_tiers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: marketing_ab_tests

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **test_name** (text) NULLABLE: NO
- **variant_a** (jsonb) NULLABLE: NO
- **variant_b** (jsonb) NULLABLE: NO
- **conversions_a** (integer) NULLABLE: YES, DEFAULT: 0
- **conversions_b** (integer) NULLABLE: YES, DEFAULT: 0
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketing_ab_tests_pkey → marketing_ab_tests(id)
- **CHECK**: 2200_67289_1_not_null
- **CHECK**: 2200_67289_2_not_null
- **CHECK**: 2200_67289_3_not_null
- **CHECK**: 2200_67289_4_not_null
- **CHECK**: 2200_67289_5_not_null

### Indexes
- marketing_ab_tests_pkey: CREATE UNIQUE INDEX marketing_ab_tests_pkey ON public.marketing_ab_tests USING btree (id)
- idx_marketing_ab_tests_merchant_id: CREATE INDEX idx_marketing_ab_tests_merchant_id ON public.marketing_ab_tests USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: marketing_campaigns

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **budget** (numeric) NULLABLE: YES
- **spent** (numeric) NULLABLE: YES, DEFAULT: 0
- **starts_at** (timestamp with time zone) NULLABLE: YES
- **ends_at** (timestamp with time zone) NULLABLE: YES
- **status** (text) NULLABLE: YES, DEFAULT: 'draft'::text
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketing_campaigns_pkey → marketing_campaigns(id)
- **CHECK**: 2200_67276_1_not_null
- **CHECK**: 2200_67276_2_not_null
- **CHECK**: 2200_67276_3_not_null

### Indexes
- marketing_campaigns_pkey: CREATE UNIQUE INDEX marketing_campaigns_pkey ON public.marketing_campaigns USING btree (id)
- idx_marketing_campaigns_merchant_id: CREATE INDEX idx_marketing_campaigns_merchant_id ON public.marketing_campaigns USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ## 🗂️ Table: marketing_coupons

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **type** (USER-DEFINED) NULLABLE: NO
- **value** (numeric) NULLABLE: NO
- **min_order_value** (numeric) NULLABLE: YES
- **max_discount** (numeric) NULLABLE: YES
- **usage_limit** (integer) NULLABLE: YES
- **usage_per_customer** (integer) NULLABLE: YES
- **starts_at** (timestamp with time zone) NULLABLE: YES
- **ends_at** (timestamp with time zone) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: marketing_coupons_code_key → marketing_coupons(code)
- **PRIMARY KEY**: marketing_coupons_pkey → marketing_coupons(id)
- **CHECK**: 2200_67249_1_not_null
- **CHECK**: 2200_67249_2_not_null
- **CHECK**: 2200_67249_3_not_null
- **CHECK**: 2200_67249_4_not_null
- **CHECK**: 2200_67249_5_not_null

### Indexes
- marketing_coupons_pkey: CREATE UNIQUE INDEX marketing_coupons_pkey ON public.marketing_coupons USING btree (id)
- marketing_coupons_code_key: CREATE UNIQUE INDEX marketing_coupons_code_key ON public.marketing_coupons USING btree (code)
- idx_marketing_coupons_merchant_id: CREATE INDEX idx_marketing_coupons_merchant_id ON public.marketing_coupons USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: marketing_discounts

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **discount_type** (text) NULLABLE: NO
- **discount_value** (numeric) NULLABLE: NO
- **applies_to** (text) NULLABLE: NO
- **target_ids** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::uuid[]
- **starts_at** (timestamp with time zone) NULLABLE: YES
- **ends_at** (timestamp with time zone) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketing_discounts_pkey → marketing_discounts(id)
- **CHECK**: 2200_67263_1_not_null
- **CHECK**: 2200_67263_2_not_null
- **CHECK**: 2200_67263_3_not_null
- **CHECK**: 2200_67263_5_not_null
- **CHECK**: 2200_67263_6_not_null
- **CHECK**: 2200_67263_7_not_null

### Indexes
- marketing_discounts_pkey: CREATE UNIQUE INDEX marketing_discounts_pkey ON public.marketing_discounts USING btree (id)
- idx_marketing_discounts_merchant_id: CREATE INDEX idx_marketing_discounts_merchant_id ON public.marketing_discounts USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: marketing_landing_pages

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **title** (text) NULLABLE: NO
- **slug** (text) NULLABLE: NO
- **content** (jsonb) NULLABLE: NO
- **seo** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_published** (boolean) NULLABLE: YES, DEFAULT: false
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketing_landing_pages_pkey → marketing_landing_pages(id)
- **UNIQUE**: marketing_landing_pages_slug_key → marketing_landing_pages(slug)
- **CHECK**: 2200_67314_1_not_null
- **CHECK**: 2200_67314_2_not_null
- **CHECK**: 2200_67314_3_not_null
- **CHECK**: 2200_67314_4_not_null
- **CHECK**: 2200_67314_5_not_null

### Indexes
- marketing_landing_pages_pkey: CREATE UNIQUE INDEX marketing_landing_pages_pkey ON public.marketing_landing_pages USING btree (id)
- marketing_landing_pages_slug_key: CREATE UNIQUE INDEX marketing_landing_pages_slug_key ON public.marketing_landing_pages USING btree (slug)
- idx_marketing_landing_pages_merchant_id: CREATE INDEX idx_marketing_landing_pages_merchant_id ON public.marketing_landing_pages USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: marketing_popups

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **title** (text) NULLABLE: NO
- **content** (text) NULLABLE: NO
- **display_rules** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketing_popups_pkey → marketing_popups(id)
- **CHECK**: 2200_67302_1_not_null
- **CHECK**: 2200_67302_2_not_null
- **CHECK**: 2200_67302_3_not_null
- **CHECK**: 2200_67302_4_not_null

### Indexes
- marketing_popups_pkey: CREATE UNIQUE INDEX marketing_popups_pkey ON public.marketing_popups USING btree (id)
- idx_marketing_popups_merchant_id: CREATE INDEX idx_marketing_popups_merchant_id ON public.marketing_popups USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: marketplace_owners

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **owner_staff_id** (uuid) NULLABLE: NO
- **marketplace_role** (text) NULLABLE: YES, DEFAULT: 'super_owner'::text
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketplace_owners_pkey → marketplace_owners(id)
- **CHECK**: 2200_67629_1_not_null
- **CHECK**: 2200_67629_2_not_null

### Indexes
- marketplace_owners_pkey: CREATE UNIQUE INDEX marketplace_owners_pkey ON public.marketplace_owners USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: marketplace_settings

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **platform_role** (text) NULLABLE: YES, DEFAULT: 'technical_intermediary'::text
- **terms** (text) NULLABLE: YES
- **privacy** (text) NULLABLE: YES
- **dispute_policy** (text) NULLABLE: YES
- **refund_policy** (text) NULLABLE: YES
- **allow_multi_merchant** (boolean) NULLABLE: YES, DEFAULT: true
- **allow_direct_payouts** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: marketplace_settings_pkey → marketplace_settings(id)
- **CHECK**: 2200_67599_1_not_null

### Indexes
- marketplace_settings_pkey: CREATE UNIQUE INDEX marketplace_settings_pkey ON public.marketplace_settings USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: merchant_badges

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **badge_name** (text) NULLABLE: NO
- **badge_icon** (text) NULLABLE: YES
- **badge_description** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: merchant_badges_pkey → merchant_badges(id)
- **CHECK**: 2200_67612_1_not_null
- **CHECK**: 2200_67612_2_not_null

### Indexes
- merchant_badges_pkey: CREATE UNIQUE INDEX merchant_badges_pkey ON public.merchant_badges USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: merchant_badges_assignments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **badge_id** (uuid) NULLABLE: NO
- **assigned_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: merchant_badges_assignments_pkey → merchant_badges_assignments(id)
- **CHECK**: 2200_67621_1_not_null
- **CHECK**: 2200_67621_2_not_null
- **CHECK**: 2200_67621_3_not_null

### Indexes
- merchant_badges_assignments_pkey: CREATE UNIQUE INDEX merchant_badges_assignments_pkey ON public.merchant_badges_assignments USING btree (id)
- idx_merchant_badges_assignments_merchant_id: CREATE INDEX idx_merchant_badges_assignments_merchant_id ON public.merchant_badges_assignments USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ## 🗂️ Table: merchant_billing

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **plan** (text) NULLABLE: NO
- **cycle** (text) NULLABLE: NO, DEFAULT: 'monthly'::text
- **amount** (numeric) NULLABLE: NO, DEFAULT: 0
- **currency** (character varying) NULLABLE: NO, DEFAULT: 'SAR'::character varying
- **renews_at** (timestamp with time zone) NULLABLE: YES
- **expires_at** (timestamp with time zone) NULLABLE: YES
- **status** (text) NULLABLE: NO, DEFAULT: 'active'::text
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_merchant_billing_merchant → merchants(id)
- **PRIMARY KEY**: merchant_billing_pkey → merchant_billing(id)
- **CHECK**: 2200_65610_1_not_null
- **CHECK**: 2200_65610_2_not_null
- **CHECK**: 2200_65610_3_not_null
- **CHECK**: 2200_65610_4_not_null
- **CHECK**: 2200_65610_5_not_null
- **CHECK**: 2200_65610_6_not_null
- **CHECK**: 2200_65610_9_not_null

### Indexes
- merchant_billing_pkey: CREATE UNIQUE INDEX merchant_billing_pkey ON public.merchant_billing USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: merchant_feature_activations

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **feature_name** (text) NULLABLE: NO
- **is_enabled** (boolean) NULLABLE: NO, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_feature_activations_merchant → merchants(id)
- **UNIQUE**: merchant_feature_activations_merchant_id_feature_name_key → merchant_feature_activations(feature_name)
- **UNIQUE**: merchant_feature_activations_merchant_id_feature_name_key → merchant_feature_activations(merchant_id)
- **UNIQUE**: merchant_feature_activations_merchant_id_feature_name_key → merchant_feature_activations(feature_name)
- **UNIQUE**: merchant_feature_activations_merchant_id_feature_name_key → merchant_feature_activations(merchant_id)
- **PRIMARY KEY**: merchant_feature_activations_pkey → merchant_feature_activations(id)
- **CHECK**: 2200_64710_1_not_null
- **CHECK**: 2200_64710_2_not_null
- **CHECK**: 2200_64710_3_not_null
- **CHECK**: 2200_64710_4_not_null

### Indexes
- merchant_feature_activations_pkey: CREATE UNIQUE INDEX merchant_feature_activations_pkey ON public.merchant_feature_activations USING btree (id)
- merchant_feature_activations_merchant_id_feature_name_key: CREATE UNIQUE INDEX merchant_feature_activations_merchant_id_feature_name_key ON public.merchant_feature_activations USING btree (merchant_id, feature_name)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: merchant_followers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **followed_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: merchant_followers_pkey → merchant_followers(id)
- **CHECK**: 2200_67669_1_not_null
- **CHECK**: 2200_67669_2_not_null
- **CHECK**: 2200_67669_3_not_null

### Indexes
- merchant_followers_pkey: CREATE UNIQUE INDEX merchant_followers_pkey ON public.merchant_followers USING btree (id)
- idx_merchant_followers_merchant_id: CREATE INDEX idx_merchant_followers_merchant_id ON public.merchant_followers USING btree (merchant_id)
- idx_merchant_followers_customer_id: CREATE INDEX idx_merchant_followers_customer_id ON public.merchant_followers USING btree (customer_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: merchant_payment_accounts

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **provider** (text) NULLABLE: NO
- **merchant_key** (text) NULLABLE: NO
- **merchant_secret** (text) NULLABLE: NO
- **merchant_profile_id** (text) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: merchant_payment_accounts_pkey → merchant_payment_accounts(id)
- **CHECK**: 2200_67639_1_not_null
- **CHECK**: 2200_67639_2_not_null
- **CHECK**: 2200_67639_3_not_null
- **CHECK**: 2200_67639_4_not_null
- **CHECK**: 2200_67639_5_not_null

### Indexes
- merchant_payment_accounts_pkey: CREATE UNIQUE INDEX merchant_payment_accounts_pkey ON public.merchant_payment_accounts USING btree (id)
- idx_merchant_payment_accounts_merchant_id: CREATE INDEX idx_merchant_payment_accounts_merchant_id ON public.merchant_payment_accounts USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: merchant_reviews

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **rating** (integer) NULLABLE: NO
- **title** (text) NULLABLE: YES
- **review** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: merchant_reviews_pkey → merchant_reviews(id)
- **CHECK**: merchant_reviews_rating_check → merchant_reviews(rating)
- **CHECK**: 2200_67588_1_not_null
- **CHECK**: 2200_67588_2_not_null
- **CHECK**: 2200_67588_3_not_null
- **CHECK**: 2200_67588_4_not_null

### Indexes
- merchant_reviews_pkey: CREATE UNIQUE INDEX merchant_reviews_pkey ON public.merchant_reviews USING btree (id)
- idx_merchant_reviews_merchant_id: CREATE INDEX idx_merchant_reviews_merchant_id ON public.merchant_reviews USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: merchant_settings

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **key** (text) NULLABLE: NO
- **value** (jsonb) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_merchant_settings_merchant → merchants(id)
- **UNIQUE**: merchant_settings_merchant_id_key_key → merchant_settings(key)
- **UNIQUE**: merchant_settings_merchant_id_key_key → merchant_settings(merchant_id)
- **UNIQUE**: merchant_settings_merchant_id_key_key → merchant_settings(key)
- **UNIQUE**: merchant_settings_merchant_id_key_key → merchant_settings(merchant_id)
- **PRIMARY KEY**: merchant_settings_pkey → merchant_settings(id)
- **CHECK**: 2200_64694_1_not_null
- **CHECK**: 2200_64694_2_not_null
- **CHECK**: 2200_64694_3_not_null
- **CHECK**: 2200_64694_4_not_null

### Indexes
- merchant_settings_pkey: CREATE UNIQUE INDEX merchant_settings_pkey ON public.merchant_settings USING btree (id)
- merchant_settings_merchant_id_key_key: CREATE UNIQUE INDEX merchant_settings_merchant_id_key_key ON public.merchant_settings USING btree (merchant_id, key)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: merchant_users

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **role** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'staff'::merchant_user_role
- **permissions** (jsonb) NULLABLE: YES, DEFAULT: '[]'::jsonb
- **invited_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **accepted_at** (timestamp with time zone) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **email** (text) NULLABLE: YES
- **password_hash** (text) NULLABLE: YES
- **name** (text) NULLABLE: YES
- **phone** (text) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true

### Constraints
- **FOREIGN KEY**: fk_merchant_users_merchant → merchants(id)
- **UNIQUE**: merchant_users_email_unique → merchant_users(email)
- **PRIMARY KEY**: merchant_users_pkey → merchant_users(id)
- **CHECK**: 2200_65591_1_not_null
- **CHECK**: 2200_65591_2_not_null
- **CHECK**: 2200_65591_4_not_null

### Indexes
- merchant_users_pkey: CREATE UNIQUE INDEX merchant_users_pkey ON public.merchant_users USING btree (id)
- merchant_users_email_unique: CREATE UNIQUE INDEX merchant_users_email_unique ON public.merchant_users USING btree (email)
- idx_merchant_users_email: CREATE INDEX idx_merchant_users_email ON public.merchant_users USING btree (email)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: merchants

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **name** (text) NULLABLE: NO
- **email** (text) NULLABLE: YES
- **phone** (text) NULLABLE: YES
- **logo_url** (text) NULLABLE: YES
- **status** (text) NULLABLE: NO, DEFAULT: 'active'::text
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **password_hash** (text) NULLABLE: YES

### Constraints
- **UNIQUE**: merchants_email_key → merchants(email)
- **UNIQUE**: merchants_email_unique → merchants(email)
- **PRIMARY KEY**: merchants_pkey → merchants(id)
- **CHECK**: 2200_64681_1_not_null
- **CHECK**: 2200_64681_2_not_null
- **CHECK**: 2200_64681_6_not_null

### Indexes
- merchants_pkey: CREATE UNIQUE INDEX merchants_pkey ON public.merchants USING btree (id)
- merchants_email_key: CREATE UNIQUE INDEX merchants_email_key ON public.merchants USING btree (email)
- merchants_email_unique: CREATE UNIQUE INDEX merchants_email_unique ON public.merchants USING btree (email)
- idx_merchants_email: CREATE INDEX idx_merchants_email ON public.merchants USING btree (email)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: messaging_automations

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **trigger** (USER-DEFINED) NULLABLE: NO
- **template_id** (uuid) NULLABLE: NO
- **conditions** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **actions** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: messaging_automations_pkey → messaging_automations(id)
- **CHECK**: 2200_66265_1_not_null
- **CHECK**: 2200_66265_2_not_null
- **CHECK**: 2200_66265_3_not_null
- **CHECK**: 2200_66265_4_not_null
- **CHECK**: 2200_66265_5_not_null

### Indexes
- messaging_automations_pkey: CREATE UNIQUE INDEX messaging_automations_pkey ON public.messaging_automations USING btree (id)
- idx_messaging_automations_merchant_id: CREATE INDEX idx_messaging_automations_merchant_id ON public.messaging_automations USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: messaging_events

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **event_name** (text) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **order_id** (uuid) NULLABLE: YES
- **product_id** (uuid) NULLABLE: YES
- **payload** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: messaging_events_pkey → messaging_events(id)
- **CHECK**: 2200_66279_1_not_null
- **CHECK**: 2200_66279_2_not_null
- **CHECK**: 2200_66279_3_not_null

### Indexes
- messaging_events_pkey: CREATE UNIQUE INDEX messaging_events_pkey ON public.messaging_events USING btree (id)
- idx_messaging_events_merchant_id: CREATE INDEX idx_messaging_events_merchant_id ON public.messaging_events USING btree (merchant_id)
- idx_messaging_events_event_name: CREATE INDEX idx_messaging_events_event_name ON public.messaging_events USING btree (event_name)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: messaging_messages

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **provider_id** (uuid) NULLABLE: YES
- **template_id** (uuid) NULLABLE: YES
- **channel** (USER-DEFINED) NULLABLE: NO
- **to_customer_id** (uuid) NULLABLE: YES
- **to_phone** (text) NULLABLE: YES
- **to_email** (text) NULLABLE: YES
- **to_device_token** (text) NULLABLE: YES
- **subject** (text) NULLABLE: YES
- **body** (text) NULLABLE: NO
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'queued'::message_status
- **error_message** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **sent_at** (timestamp with time zone) NULLABLE: YES
- **delivered_at** (timestamp with time zone) NULLABLE: YES

### Constraints
- **PRIMARY KEY**: messaging_messages_pkey → messaging_messages(id)
- **CHECK**: 2200_66237_1_not_null
- **CHECK**: 2200_66237_2_not_null
- **CHECK**: 2200_66237_5_not_null
- **CHECK**: 2200_66237_11_not_null
- **CHECK**: 2200_66237_12_not_null

### Indexes
- messaging_messages_pkey: CREATE UNIQUE INDEX messaging_messages_pkey ON public.messaging_messages USING btree (id)
- idx_messaging_messages_merchant_id: CREATE INDEX idx_messaging_messages_merchant_id ON public.messaging_messages USING btree (merchant_id)
- idx_messaging_messages_status: CREATE INDEX idx_messaging_messages_status ON public.messaging_messages USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: messaging_providers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **provider_type** (USER-DEFINED) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **api_credentials** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **settings** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: messaging_providers_pkey → messaging_providers(id)
- **CHECK**: 2200_66191_1_not_null
- **CHECK**: 2200_66191_2_not_null
- **CHECK**: 2200_66191_3_not_null
- **CHECK**: 2200_66191_4_not_null
- **CHECK**: 2200_66191_5_not_null

### Indexes
- messaging_providers_pkey: CREATE UNIQUE INDEX messaging_providers_pkey ON public.messaging_providers USING btree (id)
- idx_messaging_providers_merchant_id: CREATE INDEX idx_messaging_providers_merchant_id ON public.messaging_providers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: messaging_templates

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **type** (USER-DEFINED) NULLABLE: NO
- **subject** (text) NULLABLE: YES
- **body** (text) NULLABLE: NO
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: messaging_templates_pkey → messaging_templates(id)
- **CHECK**: 2200_66215_1_not_null
- **CHECK**: 2200_66215_2_not_null
- **CHECK**: 2200_66215_3_not_null
- **CHECK**: 2200_66215_4_not_null
- **CHECK**: 2200_66215_6_not_null

### Indexes
- messaging_templates_pkey: CREATE UNIQUE INDEX messaging_templates_pkey ON public.messaging_templates USING btree (id)
- idx_messaging_templates_merchant_id: CREATE INDEX idx_messaging_templates_merchant_id ON public.messaging_templates USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: order_addresses

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **type** (USER-DEFINED) NULLABLE: NO
- **name** (text) NULLABLE: YES
- **phone** (text) NULLABLE: YES
- **email** (text) NULLABLE: YES
- **country** (text) NULLABLE: YES
- **city** (text) NULLABLE: YES
- **district** (text) NULLABLE: YES
- **street** (text) NULLABLE: YES
- **building_number** (text) NULLABLE: YES
- **apartment_number** (text) NULLABLE: YES
- **postal_code** (text) NULLABLE: YES
- **latitude** (numeric) NULLABLE: YES
- **longitude** (numeric) NULLABLE: YES
- **notes** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_order_addresses_order → orders(id)
- **PRIMARY KEY**: order_addresses_pkey → order_addresses(id)
- **CHECK**: 2200_65049_1_not_null
- **CHECK**: 2200_65049_2_not_null
- **CHECK**: 2200_65049_3_not_null

### Indexes
- order_addresses_pkey: CREATE UNIQUE INDEX order_addresses_pkey ON public.order_addresses USING btree (id)
- idx_order_addresses_order_id: CREATE INDEX idx_order_addresses_order_id ON public.order_addresses USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: order_items

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **product_id** (uuid) NULLABLE: YES
- **variant_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **item_type** (USER-DEFINED) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **quantity** (integer) NULLABLE: NO
- **unit_price** (numeric) NULLABLE: NO
- **total** (numeric) NULLABLE: NO
- **product_data** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_order_items_order → orders(id)
- **PRIMARY KEY**: order_items_pkey → order_items(id)
- **CHECK**: order_items_quantity_check → order_items(quantity)
- **CHECK**: order_items_total_check → order_items(total)
- **CHECK**: order_items_unit_price_check → order_items(unit_price)
- **CHECK**: 2200_65021_1_not_null
- **CHECK**: 2200_65021_2_not_null
- **CHECK**: 2200_65021_5_not_null
- **CHECK**: 2200_65021_6_not_null
- **CHECK**: 2200_65021_7_not_null
- **CHECK**: 2200_65021_8_not_null
- **CHECK**: 2200_65021_9_not_null
- **CHECK**: 2200_65021_10_not_null

### Indexes
- order_items_pkey: CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (id)
- idx_order_items_order_id: CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ## 🗂️ Table: order_payments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **payment_method** (text) NULLABLE: NO
- **provider** (text) NULLABLE: YES
- **transaction_id** (text) NULLABLE: YES
- **amount** (numeric) NULLABLE: NO
- **fee_amount** (numeric) NULLABLE: YES, DEFAULT: 0
- **collected_amount** (numeric) NULLABLE: YES, DEFAULT: 0
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::payment_status
- **paid_at** (timestamp with time zone) NULLABLE: YES
- **refunded_at** (timestamp with time zone) NULLABLE: YES
- **failure_reason** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_order_payments_order → orders(id)
- **CHECK**: order_payments_amount_check → order_payments(amount)
- **CHECK**: order_payments_collected_amount_check → order_payments(collected_amount)
- **CHECK**: order_payments_fee_amount_check → order_payments(fee_amount)
- **PRIMARY KEY**: order_payments_pkey → order_payments(id)
- **CHECK**: 2200_65077_1_not_null
- **CHECK**: 2200_65077_2_not_null
- **CHECK**: 2200_65077_3_not_null
- **CHECK**: 2200_65077_4_not_null
- **CHECK**: 2200_65077_7_not_null
- **CHECK**: 2200_65077_10_not_null

### Indexes
- order_payments_pkey: CREATE UNIQUE INDEX order_payments_pkey ON public.order_payments USING btree (id)
- idx_order_payments_order_id: CREATE INDEX idx_order_payments_order_id ON public.order_payments USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: order_refunds

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **refund_type** (USER-DEFINED) NULLABLE: NO
- **reason** (text) NULLABLE: YES
- **notes** (text) NULLABLE: YES
- **amount** (numeric) NULLABLE: NO
- **currency** (character varying) NULLABLE: NO, DEFAULT: 'SAR'::character varying
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::refund_status
- **processed_by** (uuid) NULLABLE: YES
- **processed_by_type** (USER-DEFINED) NULLABLE: YES
- **refunded_at** (timestamp with time zone) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_order_refunds_order → orders(id)
- **CHECK**: order_refunds_amount_check → order_refunds(amount)
- **PRIMARY KEY**: order_refunds_pkey → order_refunds(id)
- **CHECK**: 2200_65183_1_not_null
- **CHECK**: 2200_65183_2_not_null
- **CHECK**: 2200_65183_3_not_null
- **CHECK**: 2200_65183_4_not_null
- **CHECK**: 2200_65183_7_not_null
- **CHECK**: 2200_65183_8_not_null
- **CHECK**: 2200_65183_9_not_null

### Indexes
- order_refunds_pkey: CREATE UNIQUE INDEX order_refunds_pkey ON public.order_refunds USING btree (id)
- idx_order_refunds_order_id: CREATE INDEX idx_order_refunds_order_id ON public.order_refunds USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: order_shipments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **carrier** (text) NULLABLE: YES
- **carrier_service** (text) NULLABLE: YES
- **tracking_number** (text) NULLABLE: YES
- **tracking_url** (text) NULLABLE: YES
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::shipment_status
- **label_url** (text) NULLABLE: YES
- **awb_pdf_url** (text) NULLABLE: YES
- **pickup_date** (timestamp with time zone) NULLABLE: YES
- **shipped_at** (timestamp with time zone) NULLABLE: YES
- **delivered_at** (timestamp with time zone) NULLABLE: YES
- **failed_at** (timestamp with time zone) NULLABLE: YES
- **returned_at** (timestamp with time zone) NULLABLE: YES
- **weight** (numeric) NULLABLE: YES
- **dimensions** (jsonb) NULLABLE: YES
- **cost** (numeric) NULLABLE: YES
- **cod_amount** (numeric) NULLABLE: YES
- **driver_name** (text) NULLABLE: YES
- **driver_phone** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_order_shipments_order → orders(id)
- **PRIMARY KEY**: order_shipments_pkey → order_shipments(id)
- **CHECK**: 2200_65121_1_not_null
- **CHECK**: 2200_65121_2_not_null
- **CHECK**: 2200_65121_3_not_null
- **CHECK**: 2200_65121_8_not_null

### Indexes
- order_shipments_pkey: CREATE UNIQUE INDEX order_shipments_pkey ON public.order_shipments USING btree (id)
- idx_order_shipments_order_id: CREATE INDEX idx_order_shipments_order_id ON public.order_shipments USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: order_status_history

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **old_status** (USER-DEFINED) NULLABLE: YES
- **new_status** (USER-DEFINED) NULLABLE: NO
- **changed_by** (uuid) NULLABLE: YES
- **changed_by_type** (USER-DEFINED) NULLABLE: NO
- **note** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_order_status_history_order → orders(id)
- **PRIMARY KEY**: order_status_history_pkey → order_status_history(id)
- **CHECK**: 2200_65149_1_not_null
- **CHECK**: 2200_65149_2_not_null
- **CHECK**: 2200_65149_3_not_null
- **CHECK**: 2200_65149_5_not_null
- **CHECK**: 2200_65149_7_not_null

### Indexes
- order_status_history_pkey: CREATE UNIQUE INDEX order_status_history_pkey ON public.order_status_history USING btree (id)
- idx_order_status_history_order_id: CREATE INDEX idx_order_status_history_order_id ON public.order_status_history USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: orders

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **store_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::order_status
- **source** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'web'::order_source
- **subtotal** (numeric) NULLABLE: NO
- **shipping_total** (numeric) NULLABLE: NO, DEFAULT: 0
- **tax_total** (numeric) NULLABLE: NO, DEFAULT: 0
- **discount_total** (numeric) NULLABLE: NO, DEFAULT: 0
- **grand_total** (numeric) NULLABLE: NO
- **currency** (character varying) NULLABLE: NO, DEFAULT: 'SAR'::character varying
- **notes** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_orders_merchant → merchants(id)
- **CHECK**: orders_discount_total_check → orders(discount_total)
- **CHECK**: orders_grand_total_check → orders(grand_total)
- **PRIMARY KEY**: orders_pkey → orders(id)
- **CHECK**: orders_shipping_total_check → orders(shipping_total)
- **CHECK**: orders_subtotal_check → orders(subtotal)
- **CHECK**: orders_tax_total_check → orders(tax_total)
- **CHECK**: 2200_64979_1_not_null
- **CHECK**: 2200_64979_2_not_null
- **CHECK**: 2200_64979_4_not_null
- **CHECK**: 2200_64979_5_not_null
- **CHECK**: 2200_64979_6_not_null
- **CHECK**: 2200_64979_7_not_null
- **CHECK**: 2200_64979_8_not_null
- **CHECK**: 2200_64979_9_not_null
- **CHECK**: 2200_64979_10_not_null
- **CHECK**: 2200_64979_11_not_null
- **CHECK**: 2200_64979_12_not_null

### Indexes
- orders_pkey: CREATE UNIQUE INDEX orders_pkey ON public.orders USING btree (id)
- idx_orders_store_id: CREATE INDEX idx_orders_store_id ON public.orders USING btree (store_id)
- idx_orders_customer_id: CREATE INDEX idx_orders_customer_id ON public.orders USING btree (customer_id)
- idx_orders_status: CREATE INDEX idx_orders_status ON public.orders USING btree (status)
- idx_orders_created_at: CREATE INDEX idx_orders_created_at ON public.orders USING btree (created_at)

---
                                                                    |
| ## 🗂️ Table: payment_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **transaction_id** (uuid) NULLABLE: YES
- **provider_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **event** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_payment_logs_transaction → payment_transactions(id)
- **PRIMARY KEY**: payment_logs_pkey → payment_logs(id)
- **CHECK**: 2200_65448_1_not_null
- **CHECK**: 2200_65448_4_not_null
- **CHECK**: 2200_65448_5_not_null
- **CHECK**: 2200_65448_6_not_null

### Indexes
- payment_logs_pkey: CREATE UNIQUE INDEX payment_logs_pkey ON public.payment_logs USING btree (id)
- idx_payment_logs_transaction_id: CREATE INDEX idx_payment_logs_transaction_id ON public.payment_logs USING btree (transaction_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: payment_methods

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **provider_id** (uuid) NULLABLE: YES
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **is_cod** (boolean) NULLABLE: YES, DEFAULT: false
- **settings** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_payment_methods_provider → payment_providers(id)
- **PRIMARY KEY**: payment_methods_pkey → payment_methods(id)
- **CHECK**: 2200_65396_1_not_null
- **CHECK**: 2200_65396_2_not_null
- **CHECK**: 2200_65396_4_not_null
- **CHECK**: 2200_65396_5_not_null

### Indexes
- payment_methods_pkey: CREATE UNIQUE INDEX payment_methods_pkey ON public.payment_methods USING btree (id)
- idx_payment_methods_merchant_id: CREATE INDEX idx_payment_methods_merchant_id ON public.payment_methods USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: payment_providers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **api_credentials** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **settings** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: payment_providers_code_key → payment_providers(code)
- **PRIMARY KEY**: payment_providers_pkey → payment_providers(id)
- **CHECK**: 2200_65378_1_not_null
- **CHECK**: 2200_65378_2_not_null
- **CHECK**: 2200_65378_3_not_null
- **CHECK**: 2200_65378_4_not_null

### Indexes
- payment_providers_pkey: CREATE UNIQUE INDEX payment_providers_pkey ON public.payment_providers USING btree (id)
- payment_providers_code_key: CREATE UNIQUE INDEX payment_providers_code_key ON public.payment_providers USING btree (code)
- idx_payment_providers_merchant_id: CREATE INDEX idx_payment_providers_merchant_id ON public.payment_providers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ## 🗂️ Table: payment_transactions

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **provider_id** (uuid) NULLABLE: YES
- **method_id** (uuid) NULLABLE: YES
- **amount** (numeric) NULLABLE: NO
- **currency** (character varying) NULLABLE: NO, DEFAULT: 'SAR'::character varying
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::transaction_status
- **provider_transaction_id** (text) NULLABLE: YES
- **provider_reference** (text) NULLABLE: YES
- **provider_response** (jsonb) NULLABLE: YES
- **authorized_at** (timestamp with time zone) NULLABLE: YES
- **captured_at** (timestamp with time zone) NULLABLE: YES
- **refunded_at** (timestamp with time zone) NULLABLE: YES
- **failed_at** (timestamp with time zone) NULLABLE: YES
- **failure_reason** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_payment_transactions_order → orders(id)
- **CHECK**: payment_transactions_amount_check → payment_transactions(amount)
- **PRIMARY KEY**: payment_transactions_pkey → payment_transactions(id)
- **CHECK**: 2200_65427_1_not_null
- **CHECK**: 2200_65427_2_not_null
- **CHECK**: 2200_65427_3_not_null
- **CHECK**: 2200_65427_6_not_null
- **CHECK**: 2200_65427_7_not_null
- **CHECK**: 2200_65427_8_not_null

### Indexes
- payment_transactions_pkey: CREATE UNIQUE INDEX payment_transactions_pkey ON public.payment_transactions USING btree (id)
- idx_payment_transactions_order_id: CREATE INDEX idx_payment_transactions_order_id ON public.payment_transactions USING btree (order_id)
- idx_payment_transactions_status: CREATE INDEX idx_payment_transactions_status ON public.payment_transactions USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: product_attribute_values

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **attribute_id** (uuid) NULLABLE: NO
- **value** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_attribute_values_attribute → product_attributes(id)
- **FOREIGN KEY**: fk_attribute_values_product → products(id)
- **PRIMARY KEY**: product_attribute_values_pkey → product_attribute_values(id)
- **CHECK**: 2200_64872_1_not_null
- **CHECK**: 2200_64872_2_not_null
- **CHECK**: 2200_64872_3_not_null
- **CHECK**: 2200_64872_4_not_null

### Indexes
- product_attribute_values_pkey: CREATE UNIQUE INDEX product_attribute_values_pkey ON public.product_attribute_values USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: product_attributes

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **store_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **type** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: product_attributes_pkey → product_attributes(id)
- **CHECK**: 2200_64863_1_not_null
- **CHECK**: 2200_64863_2_not_null
- **CHECK**: 2200_64863_3_not_null
- **CHECK**: 2200_64863_4_not_null

### Indexes
- product_attributes_pkey: CREATE UNIQUE INDEX product_attributes_pkey ON public.product_attributes USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: product_categories

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **store_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **slug** (text) NULLABLE: YES
- **parent_id** (uuid) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: product_categories_pkey → product_categories(id)
- **UNIQUE**: product_categories_slug_key → product_categories(slug)
- **CHECK**: 2200_64833_1_not_null
- **CHECK**: 2200_64833_2_not_null
- **CHECK**: 2200_64833_3_not_null

### Indexes
- product_categories_pkey: CREATE UNIQUE INDEX product_categories_pkey ON public.product_categories USING btree (id)
- product_categories_slug_key: CREATE UNIQUE INDEX product_categories_slug_key ON public.product_categories USING btree (slug)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: product_category_assignments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **category_id** (uuid) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_category_assignments_category → product_categories(id)
- **FOREIGN KEY**: fk_category_assignments_product → products(id)
- **PRIMARY KEY**: product_category_assignments_pkey → product_category_assignments(id)
- **CHECK**: 2200_64845_1_not_null
- **CHECK**: 2200_64845_2_not_null
- **CHECK**: 2200_64845_3_not_null

### Indexes
- product_category_assignments_pkey: CREATE UNIQUE INDEX product_category_assignments_pkey ON public.product_category_assignments USING btree (id)
- idx_category_assignments_product_id: CREATE INDEX idx_category_assignments_product_id ON public.product_category_assignments USING btree (product_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: product_inventory_settings

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **track_inventory** (boolean) NULLABLE: YES, DEFAULT: true
- **allow_backorder** (boolean) NULLABLE: YES, DEFAULT: false
- **low_stock_threshold** (integer) NULLABLE: YES, DEFAULT: 5
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_inventory_settings_product → products(id)
- **CHECK**: product_inventory_settings_low_stock_threshold_check → product_inventory_settings(low_stock_threshold)
- **PRIMARY KEY**: product_inventory_settings_pkey → product_inventory_settings(id)
- **CHECK**: 2200_64920_1_not_null
- **CHECK**: 2200_64920_2_not_null

### Indexes
- product_inventory_settings_pkey: CREATE UNIQUE INDEX product_inventory_settings_pkey ON public.product_inventory_settings USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: product_media

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **variant_id** (uuid) NULLABLE: YES
- **type** (USER-DEFINED) NULLABLE: NO
- **url** (text) NULLABLE: NO
- **alt** (text) NULLABLE: YES
- **position** (integer) NULLABLE: YES, DEFAULT: 0
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_product_media_product → products(id)
- **PRIMARY KEY**: product_media_pkey → product_media(id)
- **CHECK**: product_media_position_check → product_media(position)
- **CHECK**: 2200_64815_1_not_null
- **CHECK**: 2200_64815_2_not_null
- **CHECK**: 2200_64815_4_not_null
- **CHECK**: 2200_64815_5_not_null

### Indexes
- product_media_pkey: CREATE UNIQUE INDEX product_media_pkey ON public.product_media USING btree (id)
- idx_product_media_product_id: CREATE INDEX idx_product_media_product_id ON public.product_media USING btree (product_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ## 🗂️ Table: product_option_values

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **option_id** (uuid) NULLABLE: NO
- **value** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_option_values_option → product_options(id)
- **PRIMARY KEY**: product_option_values_pkey → product_option_values(id)
- **CHECK**: 2200_64901_1_not_null
- **CHECK**: 2200_64901_2_not_null
- **CHECK**: 2200_64901_3_not_null

### Indexes
- product_option_values_pkey: CREATE UNIQUE INDEX product_option_values_pkey ON public.product_option_values USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: product_options

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_product_options_product → products(id)
- **PRIMARY KEY**: product_options_pkey → product_options(id)
- **CHECK**: 2200_64892_1_not_null
- **CHECK**: 2200_64892_2_not_null
- **CHECK**: 2200_64892_3_not_null

### Indexes
- product_options_pkey: CREATE UNIQUE INDEX product_options_pkey ON public.product_options USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: product_pricing

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **base_price** (numeric) NULLABLE: NO
- **compare_at_price** (numeric) NULLABLE: YES
- **currency** (character varying) NULLABLE: NO, DEFAULT: 'SAR'::character varying
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_product_pricing_product → products(id)
- **CHECK**: product_pricing_base_price_check → product_pricing(base_price)
- **CHECK**: product_pricing_compare_at_price_check → product_pricing(compare_at_price)
- **PRIMARY KEY**: product_pricing_pkey → product_pricing(id)
- **CHECK**: 2200_64936_1_not_null
- **CHECK**: 2200_64936_2_not_null
- **CHECK**: 2200_64936_3_not_null
- **CHECK**: 2200_64936_5_not_null

### Indexes
- product_pricing_pkey: CREATE UNIQUE INDEX product_pricing_pkey ON public.product_pricing USING btree (id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: product_variants

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **product_id** (uuid) NULLABLE: NO
- **store_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **sku** (text) NULLABLE: YES
- **barcode** (text) NULLABLE: YES
- **price** (numeric) NULLABLE: NO
- **compare_at_price** (numeric) NULLABLE: YES
- **weight** (numeric) NULLABLE: YES
- **dimensions** (jsonb) NULLABLE: YES
- **options** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_default** (boolean) NULLABLE: YES, DEFAULT: false
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_product_variants_product → products(id)
- **CHECK**: product_variants_compare_at_price_check → product_variants(compare_at_price)
- **PRIMARY KEY**: product_variants_pkey → product_variants(id)
- **CHECK**: product_variants_price_check → product_variants(price)
- **UNIQUE**: product_variants_sku_key → product_variants(sku)
- **CHECK**: product_variants_weight_check → product_variants(weight)
- **CHECK**: 2200_64784_1_not_null
- **CHECK**: 2200_64784_2_not_null
- **CHECK**: 2200_64784_3_not_null
- **CHECK**: 2200_64784_4_not_null
- **CHECK**: 2200_64784_7_not_null

### Indexes
- product_variants_pkey: CREATE UNIQUE INDEX product_variants_pkey ON public.product_variants USING btree (id)
- product_variants_sku_key: CREATE UNIQUE INDEX product_variants_sku_key ON public.product_variants USING btree (sku)
- idx_product_variants_product_id: CREATE INDEX idx_product_variants_product_id ON public.product_variants USING btree (product_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: products

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **store_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **slug** (text) NULLABLE: YES
- **description** (text) NULLABLE: YES
- **short_description** (text) NULLABLE: YES
- **type** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'simple'::product_type
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'draft'::product_status
- **sku** (text) NULLABLE: YES
- **barcode** (text) NULLABLE: YES
- **brand** (text) NULLABLE: YES
- **tags** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **weight** (numeric) NULLABLE: YES
- **dimensions** (jsonb) NULLABLE: YES
- **is_featured** (boolean) NULLABLE: YES, DEFAULT: false
- **is_published** (boolean) NULLABLE: YES, DEFAULT: false
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_products_store → merchants(id)
- **PRIMARY KEY**: products_pkey → products(id)
- **UNIQUE**: products_sku_key → products(sku)
- **UNIQUE**: products_slug_key → products(slug)
- **CHECK**: products_weight_check → products(weight)
- **CHECK**: 2200_64751_1_not_null
- **CHECK**: 2200_64751_2_not_null
- **CHECK**: 2200_64751_3_not_null
- **CHECK**: 2200_64751_4_not_null
- **CHECK**: 2200_64751_8_not_null
- **CHECK**: 2200_64751_9_not_null

### Indexes
- products_pkey: CREATE UNIQUE INDEX products_pkey ON public.products USING btree (id)
- products_slug_key: CREATE UNIQUE INDEX products_slug_key ON public.products USING btree (slug)
- products_sku_key: CREATE UNIQUE INDEX products_sku_key ON public.products USING btree (sku)
- idx_products_store_id: CREATE INDEX idx_products_store_id ON public.products USING btree (store_id)
- idx_products_merchant_id: CREATE INDEX idx_products_merchant_id ON public.products USING btree (merchant_id)
- idx_products_status: CREATE INDEX idx_products_status ON public.products USING btree (status)
- idx_products_type: CREATE INDEX idx_products_type ON public.products USING btree (type)
- idx_products_slug: CREATE INDEX idx_products_slug ON public.products USING btree (slug)

---
 |
| ## 🗂️ Table: review_media

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **review_id** (uuid) NULLABLE: NO
- **file_url** (text) NULLABLE: NO
- **file_type** (text) NULLABLE: YES
- **file_size** (integer) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: review_media_pkey → review_media(id)
- **CHECK**: 2200_67133_1_not_null
- **CHECK**: 2200_67133_2_not_null
- **CHECK**: 2200_67133_3_not_null

### Indexes
- review_media_pkey: CREATE UNIQUE INDEX review_media_pkey ON public.review_media USING btree (id)
- idx_review_media_review_id: CREATE INDEX idx_review_media_review_id ON public.review_media USING btree (review_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: review_replies

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **review_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **user_id** (uuid) NULLABLE: YES
- **reply** (text) NULLABLE: NO
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: review_replies_pkey → review_replies(id)
- **CHECK**: 2200_67143_1_not_null
- **CHECK**: 2200_67143_2_not_null
- **CHECK**: 2200_67143_3_not_null
- **CHECK**: 2200_67143_5_not_null

### Indexes
- review_replies_pkey: CREATE UNIQUE INDEX review_replies_pkey ON public.review_replies USING btree (id)
- idx_review_replies_review_id: CREATE INDEX idx_review_replies_review_id ON public.review_replies USING btree (review_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ## 🗂️ Table: reviews

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **product_id** (uuid) NULLABLE: NO
- **order_id** (uuid) NULLABLE: YES
- **rating** (integer) NULLABLE: NO
- **title** (text) NULLABLE: YES
- **body** (text) NULLABLE: YES
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'approved'::review_status_adv
- **has_images** (boolean) NULLABLE: YES, DEFAULT: false
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: reviews_pkey → reviews(id)
- **CHECK**: reviews_rating_check → reviews(rating)
- **CHECK**: 2200_67117_1_not_null
- **CHECK**: 2200_67117_2_not_null
- **CHECK**: 2200_67117_4_not_null
- **CHECK**: 2200_67117_6_not_null
- **CHECK**: 2200_67117_9_not_null

### Indexes
- reviews_pkey: CREATE UNIQUE INDEX reviews_pkey ON public.reviews USING btree (id)
- idx_reviews_product_id: CREATE INDEX idx_reviews_product_id ON public.reviews USING btree (product_id)
- idx_reviews_merchant_id: CREATE INDEX idx_reviews_merchant_id ON public.reviews USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: search_filters

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **filter_name** (text) NULLABLE: NO
- **filter_type** (text) NULLABLE: NO
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: search_filters_pkey → search_filters(id)
- **CHECK**: 2200_67219_1_not_null
- **CHECK**: 2200_67219_2_not_null
- **CHECK**: 2200_67219_3_not_null
- **CHECK**: 2200_67219_4_not_null

### Indexes
- search_filters_pkey: CREATE UNIQUE INDEX search_filters_pkey ON public.search_filters USING btree (id)
- idx_search_filters_merchant_id: CREATE INDEX idx_search_filters_merchant_id ON public.search_filters USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: search_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **query** (text) NULLABLE: NO
- **results_count** (integer) NULLABLE: YES, DEFAULT: 0
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: search_logs_pkey → search_logs(id)
- **CHECK**: 2200_67207_1_not_null
- **CHECK**: 2200_67207_2_not_null
- **CHECK**: 2200_67207_4_not_null

### Indexes
- search_logs_pkey: CREATE UNIQUE INDEX search_logs_pkey ON public.search_logs USING btree (id)
- idx_search_logs_merchant_id: CREATE INDEX idx_search_logs_merchant_id ON public.search_logs USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: search_ranking_rules

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **rule_name** (text) NULLABLE: NO
- **weight** (integer) NULLABLE: NO, DEFAULT: 1
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: search_ranking_rules_pkey → search_ranking_rules(id)
- **CHECK**: 2200_67230_1_not_null
- **CHECK**: 2200_67230_2_not_null
- **CHECK**: 2200_67230_3_not_null
- **CHECK**: 2200_67230_4_not_null

### Indexes
- search_ranking_rules_pkey: CREATE UNIQUE INDEX search_ranking_rules_pkey ON public.search_ranking_rules USING btree (id)
- idx_search_ranking_rules_merchant_id: CREATE INDEX idx_search_ranking_rules_merchant_id ON public.search_ranking_rules USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ## 🗂️ Table: settings_checkout

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **guest_checkout_enabled** (boolean) NULLABLE: YES, DEFAULT: true
- **require_phone** (boolean) NULLABLE: YES, DEFAULT: true
- **require_address** (boolean) NULLABLE: YES, DEFAULT: true
- **allowed_payment_methods** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **allowed_shipping_methods** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: settings_checkout_pkey → settings_checkout(id)
- **CHECK**: 2200_67507_1_not_null
- **CHECK**: 2200_67507_2_not_null

### Indexes
- settings_checkout_pkey: CREATE UNIQUE INDEX settings_checkout_pkey ON public.settings_checkout USING btree (id)
- idx_settings_checkout_merchant_id: CREATE INDEX idx_settings_checkout_merchant_id ON public.settings_checkout USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: settings_currency

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **default_currency** (text) NULLABLE: NO
- **supported_currencies** (ARRAY) NULLABLE: YES, DEFAULT: '{SAR}'::text[]
- **exchange_rates** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: settings_currency_pkey → settings_currency(id)
- **CHECK**: 2200_67480_1_not_null
- **CHECK**: 2200_67480_2_not_null
- **CHECK**: 2200_67480_3_not_null

### Indexes
- settings_currency_pkey: CREATE UNIQUE INDEX settings_currency_pkey ON public.settings_currency USING btree (id)
- idx_settings_currency_merchant_id: CREATE INDEX idx_settings_currency_merchant_id ON public.settings_currency USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: settings_localization

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **default_language** (text) NULLABLE: NO
- **supported_languages** (ARRAY) NULLABLE: YES, DEFAULT: '{ar}'::text[]
- **timezone** (text) NULLABLE: YES, DEFAULT: 'Asia/Riyadh'::text
- **date_format** (text) NULLABLE: YES, DEFAULT: 'dd/MM/yyyy'::text
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: settings_localization_pkey → settings_localization(id)
- **CHECK**: 2200_67493_1_not_null
- **CHECK**: 2200_67493_2_not_null
- **CHECK**: 2200_67493_3_not_null

### Indexes
- settings_localization_pkey: CREATE UNIQUE INDEX settings_localization_pkey ON public.settings_localization USING btree (id)
- idx_settings_localization_merchant_id: CREATE INDEX idx_settings_localization_merchant_id ON public.settings_localization USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: settings_taxes

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **country_code** (text) NULLABLE: YES
- **region** (text) NULLABLE: YES
- **tax_rate** (numeric) NULLABLE: YES
- **is_inclusive** (boolean) NULLABLE: YES, DEFAULT: true
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: settings_taxes_pkey → settings_taxes(id)
- **CHECK**: 2200_67467_1_not_null
- **CHECK**: 2200_67467_2_not_null

### Indexes
- settings_taxes_pkey: CREATE UNIQUE INDEX settings_taxes_pkey ON public.settings_taxes USING btree (id)
- idx_settings_taxes_merchant_id: CREATE INDEX idx_settings_taxes_merchant_id ON public.settings_taxes USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: shipping_labels

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **order_id** (uuid) NULLABLE: NO
- **provider_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **awb_number** (text) NULLABLE: NO
- **label_url** (text) NULLABLE: YES
- **raw_response** (jsonb) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_shipping_labels_provider → shipping_providers(id)
- **PRIMARY KEY**: shipping_labels_pkey → shipping_labels(id)
- **CHECK**: 2200_65346_1_not_null
- **CHECK**: 2200_65346_2_not_null
- **CHECK**: 2200_65346_3_not_null
- **CHECK**: 2200_65346_4_not_null
- **CHECK**: 2200_65346_5_not_null

### Indexes
- shipping_labels_pkey: CREATE UNIQUE INDEX shipping_labels_pkey ON public.shipping_labels USING btree (id)
- idx_shipping_labels_order_id: CREATE INDEX idx_shipping_labels_order_id ON public.shipping_labels USING btree (order_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ## 🗂️ Table: shipping_pickups

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **provider_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **pickup_date** (timestamp with time zone) NULLABLE: NO
- **status** (text) NULLABLE: NO, DEFAULT: 'scheduled'::text
- **tracking_number** (text) NULLABLE: YES
- **driver_name** (text) NULLABLE: YES
- **driver_phone** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_shipping_pickups_provider → shipping_providers(id)
- **PRIMARY KEY**: shipping_pickups_pkey → shipping_pickups(id)
- **CHECK**: 2200_65361_1_not_null
- **CHECK**: 2200_65361_2_not_null
- **CHECK**: 2200_65361_3_not_null
- **CHECK**: 2200_65361_4_not_null
- **CHECK**: 2200_65361_5_not_null

### Indexes
- shipping_pickups_pkey: CREATE UNIQUE INDEX shipping_pickups_pkey ON public.shipping_pickups USING btree (id)
- idx_shipping_pickups_provider_id: CREATE INDEX idx_shipping_pickups_provider_id ON public.shipping_pickups USING btree (provider_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: shipping_providers

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: NO
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **api_credentials** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **settings** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: shipping_providers_code_key → shipping_providers(code)
- **PRIMARY KEY**: shipping_providers_pkey → shipping_providers(id)
- **CHECK**: 2200_65291_1_not_null
- **CHECK**: 2200_65291_2_not_null
- **CHECK**: 2200_65291_3_not_null
- **CHECK**: 2200_65291_4_not_null

### Indexes
- shipping_providers_pkey: CREATE UNIQUE INDEX shipping_providers_pkey ON public.shipping_providers USING btree (id)
- shipping_providers_code_key: CREATE UNIQUE INDEX shipping_providers_code_key ON public.shipping_providers USING btree (code)
- idx_shipping_providers_merchant_id: CREATE INDEX idx_shipping_providers_merchant_id ON public.shipping_providers USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: shipping_rates

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **provider_id** (uuid) NULLABLE: NO
- **zone_id** (uuid) NULLABLE: NO
- **min_weight** (numeric) NULLABLE: NO
- **max_weight** (numeric) NULLABLE: NO
- **base_price** (numeric) NULLABLE: NO
- **additional_kg_price** (numeric) NULLABLE: YES, DEFAULT: 0
- **cod_fee** (numeric) NULLABLE: YES, DEFAULT: 0
- **currency** (character varying) NULLABLE: NO, DEFAULT: 'SAR'::character varying
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_shipping_rates_provider → shipping_providers(id)
- **FOREIGN KEY**: fk_shipping_rates_zone → shipping_zones(id)
- **CHECK**: shipping_rates_additional_kg_price_check → shipping_rates(additional_kg_price)
- **CHECK**: shipping_rates_base_price_check → shipping_rates(base_price)
- **CHECK**: shipping_rates_cod_fee_check → shipping_rates(cod_fee)
- **CHECK**: shipping_rates_max_weight_check → shipping_rates(max_weight)
- **CHECK**: shipping_rates_min_weight_check → shipping_rates(min_weight)
- **PRIMARY KEY**: shipping_rates_pkey → shipping_rates(id)
- **CHECK**: 2200_65319_1_not_null
- **CHECK**: 2200_65319_2_not_null
- **CHECK**: 2200_65319_3_not_null
- **CHECK**: 2200_65319_4_not_null
- **CHECK**: 2200_65319_5_not_null
- **CHECK**: 2200_65319_6_not_null
- **CHECK**: 2200_65319_7_not_null
- **CHECK**: 2200_65319_10_not_null

### Indexes
- shipping_rates_pkey: CREATE UNIQUE INDEX shipping_rates_pkey ON public.shipping_rates USING btree (id)
- idx_shipping_rates_provider_id: CREATE INDEX idx_shipping_rates_provider_id ON public.shipping_rates USING btree (provider_id)
- idx_shipping_rates_zone_id: CREATE INDEX idx_shipping_rates_zone_id ON public.shipping_rates USING btree (zone_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: shipping_zones

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **countries** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **cities** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: shipping_zones_pkey → shipping_zones(id)
- **CHECK**: 2200_65307_1_not_null
- **CHECK**: 2200_65307_2_not_null
- **CHECK**: 2200_65307_3_not_null

### Indexes
- shipping_zones_pkey: CREATE UNIQUE INDEX shipping_zones_pkey ON public.shipping_zones USING btree (id)
- idx_shipping_zones_merchant_id: CREATE INDEX idx_shipping_zones_merchant_id ON public.shipping_zones USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ## 🗂️ Table: subscription_events

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **subscription_id** (uuid) NULLABLE: YES
- **invoice_id** (uuid) NULLABLE: YES
- **customer_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **event_name** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: subscription_events_pkey → subscription_events(id)
- **CHECK**: 2200_66738_1_not_null
- **CHECK**: 2200_66738_5_not_null
- **CHECK**: 2200_66738_6_not_null

### Indexes
- subscription_events_pkey: CREATE UNIQUE INDEX subscription_events_pkey ON public.subscription_events USING btree (id)
- idx_subscription_events_subscription_id: CREATE INDEX idx_subscription_events_subscription_id ON public.subscription_events USING btree (subscription_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: subscription_invoices

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **subscription_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **amount** (numeric) NULLABLE: NO
- **currency** (text) NULLABLE: YES, DEFAULT: 'SAR'::text
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'pending'::invoice_status
- **due_date** (timestamp with time zone) NULLABLE: NO
- **paid_at** (timestamp with time zone) NULLABLE: YES
- **failed_at** (timestamp with time zone) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: subscription_invoices_pkey → subscription_invoices(id)
- **CHECK**: 2200_66713_1_not_null
- **CHECK**: 2200_66713_2_not_null
- **CHECK**: 2200_66713_3_not_null
- **CHECK**: 2200_66713_4_not_null
- **CHECK**: 2200_66713_5_not_null
- **CHECK**: 2200_66713_7_not_null
- **CHECK**: 2200_66713_8_not_null

### Indexes
- subscription_invoices_pkey: CREATE UNIQUE INDEX subscription_invoices_pkey ON public.subscription_invoices USING btree (id)
- idx_subscription_invoices_subscription_id: CREATE INDEX idx_subscription_invoices_subscription_id ON public.subscription_invoices USING btree (subscription_id)
- idx_subscription_invoices_status: CREATE INDEX idx_subscription_invoices_status ON public.subscription_invoices USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: subscription_payments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **invoice_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **provider** (text) NULLABLE: YES
- **transaction_id** (text) NULLABLE: YES
- **amount** (numeric) NULLABLE: NO
- **status** (text) NULLABLE: NO
- **error_message** (text) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: subscription_payments_pkey → subscription_payments(id)
- **CHECK**: 2200_66727_1_not_null
- **CHECK**: 2200_66727_2_not_null
- **CHECK**: 2200_66727_3_not_null
- **CHECK**: 2200_66727_4_not_null
- **CHECK**: 2200_66727_7_not_null
- **CHECK**: 2200_66727_8_not_null

### Indexes
- subscription_payments_pkey: CREATE UNIQUE INDEX subscription_payments_pkey ON public.subscription_payments USING btree (id)
- idx_subscription_payments_invoice_id: CREATE INDEX idx_subscription_payments_invoice_id ON public.subscription_payments USING btree (invoice_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: subscription_plans

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **features** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **price** (numeric) NULLABLE: NO
- **interval** (text) NULLABLE: NO
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: subscription_plans_pkey → subscription_plans(id)
- **CHECK**: 2200_66663_1_not_null
- **CHECK**: 2200_66663_2_not_null
- **CHECK**: 2200_66663_3_not_null
- **CHECK**: 2200_66663_6_not_null
- **CHECK**: 2200_66663_7_not_null

### Indexes
- subscription_plans_pkey: CREATE UNIQUE INDEX subscription_plans_pkey ON public.subscription_plans USING btree (id)
- idx_subscription_plans_merchant_id: CREATE INDEX idx_subscription_plans_merchant_id ON public.subscription_plans USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ## 🗂️ Table: subscriptions

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: NO
- **plan_id** (uuid) NULLABLE: NO
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'active'::subscription_status
- **start_date** (timestamp with time zone) NULLABLE: NO, DEFAULT: now()
- **end_date** (timestamp with time zone) NULLABLE: YES
- **trial_end** (timestamp with time zone) NULLABLE: YES
- **cancel_at** (timestamp with time zone) NULLABLE: YES
- **canceled_at** (timestamp with time zone) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: subscriptions_pkey → subscriptions(id)
- **CHECK**: 2200_66689_1_not_null
- **CHECK**: 2200_66689_2_not_null
- **CHECK**: 2200_66689_3_not_null
- **CHECK**: 2200_66689_4_not_null
- **CHECK**: 2200_66689_5_not_null
- **CHECK**: 2200_66689_6_not_null

### Indexes
- subscriptions_pkey: CREATE UNIQUE INDEX subscriptions_pkey ON public.subscriptions USING btree (id)
- idx_subscriptions_customer_id: CREATE INDEX idx_subscriptions_customer_id ON public.subscriptions USING btree (customer_id)
- idx_subscriptions_status: CREATE INDEX idx_subscriptions_status ON public.subscriptions USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: support_articles

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **category_id** (uuid) NULLABLE: YES
- **title** (text) NULLABLE: NO
- **slug** (text) NULLABLE: YES
- **content** (text) NULLABLE: NO
- **is_published** (boolean) NULLABLE: YES, DEFAULT: true
- **views** (integer) NULLABLE: YES, DEFAULT: 0
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_support_articles_category → support_categories(id)
- **PRIMARY KEY**: support_articles_pkey → support_articles(id)
- **UNIQUE**: support_articles_slug_key → support_articles(slug)
- **CHECK**: 2200_66982_1_not_null
- **CHECK**: 2200_66982_2_not_null
- **CHECK**: 2200_66982_4_not_null
- **CHECK**: 2200_66982_6_not_null

### Indexes
- support_articles_pkey: CREATE UNIQUE INDEX support_articles_pkey ON public.support_articles USING btree (id)
- support_articles_slug_key: CREATE UNIQUE INDEX support_articles_slug_key ON public.support_articles USING btree (slug)
- idx_support_articles_category_id: CREATE INDEX idx_support_articles_category_id ON public.support_articles USING btree (category_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ## 🗂️ Table: support_attachments

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **ticket_id** (uuid) NULLABLE: NO
- **message_id** (uuid) NULLABLE: YES
- **file_url** (text) NULLABLE: NO
- **file_type** (text) NULLABLE: YES
- **file_size** (integer) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: support_attachments_pkey → support_attachments(id)
- **CHECK**: 2200_67003_1_not_null
- **CHECK**: 2200_67003_2_not_null
- **CHECK**: 2200_67003_4_not_null

### Indexes
- support_attachments_pkey: CREATE UNIQUE INDEX support_attachments_pkey ON public.support_attachments USING btree (id)
- idx_support_attachments_ticket_id: CREATE INDEX idx_support_attachments_ticket_id ON public.support_attachments USING btree (ticket_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ## 🗂️ Table: support_categories

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **sort_order** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: support_categories_pkey → support_categories(id)
- **CHECK**: 2200_66971_1_not_null
- **CHECK**: 2200_66971_2_not_null
- **CHECK**: 2200_66971_3_not_null

### Indexes
- support_categories_pkey: CREATE UNIQUE INDEX support_categories_pkey ON public.support_categories USING btree (id)
- idx_support_categories_merchant_id: CREATE INDEX idx_support_categories_merchant_id ON public.support_categories USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ## 🗂️ Table: support_events

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **ticket_id** (uuid) NULLABLE: YES
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **event_name** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: support_events_pkey → support_events(id)
- **CHECK**: 2200_67013_1_not_null
- **CHECK**: 2200_67013_3_not_null
- **CHECK**: 2200_67013_5_not_null

### Indexes
- support_events_pkey: CREATE UNIQUE INDEX support_events_pkey ON public.support_events USING btree (id)
- idx_support_events_ticket_id: CREATE INDEX idx_support_events_ticket_id ON public.support_events USING btree (ticket_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ## 🗂️ Table: support_messages

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **ticket_id** (uuid) NULLABLE: NO
- **sender** (USER-DEFINED) NULLABLE: NO
- **message** (text) NULLABLE: NO
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_support_messages_ticket → support_tickets(id)
- **PRIMARY KEY**: support_messages_pkey → support_messages(id)
- **CHECK**: 2200_66955_1_not_null
- **CHECK**: 2200_66955_2_not_null
- **CHECK**: 2200_66955_3_not_null
- **CHECK**: 2200_66955_4_not_null

### Indexes
- support_messages_pkey: CREATE UNIQUE INDEX support_messages_pkey ON public.support_messages USING btree (id)
- idx_support_messages_ticket_id: CREATE INDEX idx_support_messages_ticket_id ON public.support_messages USING btree (ticket_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: support_tickets

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **customer_id** (uuid) NULLABLE: YES
- **assigned_to** (uuid) NULLABLE: YES
- **subject** (text) NULLABLE: NO
- **status** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'open'::support_ticket_status
- **priority** (USER-DEFINED) NULLABLE: NO, DEFAULT: 'medium'::support_ticket_priority
- **category_id** (uuid) NULLABLE: YES
- **order_id** (uuid) NULLABLE: YES
- **metadata** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **resolved_at** (timestamp with time zone) NULLABLE: YES

### Constraints
- **PRIMARY KEY**: support_tickets_pkey → support_tickets(id)
- **CHECK**: 2200_66933_1_not_null
- **CHECK**: 2200_66933_2_not_null
- **CHECK**: 2200_66933_5_not_null
- **CHECK**: 2200_66933_6_not_null
- **CHECK**: 2200_66933_7_not_null

### Indexes
- support_tickets_pkey: CREATE UNIQUE INDEX support_tickets_pkey ON public.support_tickets USING btree (id)
- idx_support_tickets_merchant_id: CREATE INDEX idx_support_tickets_merchant_id ON public.support_tickets USING btree (merchant_id)
- idx_support_tickets_status: CREATE INDEX idx_support_tickets_status ON public.support_tickets USING btree (status)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ## 🗂️ Table: warehouse_locations

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **warehouse_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **description** (text) NULLABLE: YES
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **FOREIGN KEY**: fk_warehouse_locations_warehouse → warehouses(id)
- **PRIMARY KEY**: warehouse_locations_pkey → warehouse_locations(id)
- **CHECK**: 2200_66837_1_not_null
- **CHECK**: 2200_66837_2_not_null
- **CHECK**: 2200_66837_3_not_null

### Indexes
- warehouse_locations_pkey: CREATE UNIQUE INDEX warehouse_locations_pkey ON public.warehouse_locations USING btree (id)
- idx_warehouse_locations_warehouse_id: CREATE INDEX idx_warehouse_locations_warehouse_id ON public.warehouse_locations USING btree (warehouse_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ## 🗂️ Table: warehouses

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **code** (text) NULLABLE: YES
- **address** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **UNIQUE**: warehouses_code_key → warehouses(code)
- **PRIMARY KEY**: warehouses_pkey → warehouses(id)
- **CHECK**: 2200_66822_1_not_null
- **CHECK**: 2200_66822_2_not_null
- **CHECK**: 2200_66822_3_not_null

### Indexes
- warehouses_pkey: CREATE UNIQUE INDEX warehouses_pkey ON public.warehouses USING btree (id)
- warehouses_code_key: CREATE UNIQUE INDEX warehouses_code_key ON public.warehouses USING btree (code)
- idx_warehouses_merchant_id: CREATE INDEX idx_warehouses_merchant_id ON public.warehouses USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ## 🗂️ Table: webhooks_endpoints

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **merchant_id** (uuid) NULLABLE: NO
- **name** (text) NULLABLE: NO
- **url** (text) NULLABLE: NO
- **secret** (text) NULLABLE: YES
- **is_active** (boolean) NULLABLE: YES, DEFAULT: true
- **events** (ARRAY) NULLABLE: YES, DEFAULT: '{}'::text[]
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()
- **updated_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: webhooks_endpoints_pkey → webhooks_endpoints(id)
- **CHECK**: 2200_67417_1_not_null
- **CHECK**: 2200_67417_2_not_null
- **CHECK**: 2200_67417_3_not_null
- **CHECK**: 2200_67417_4_not_null

### Indexes
- webhooks_endpoints_pkey: CREATE UNIQUE INDEX webhooks_endpoints_pkey ON public.webhooks_endpoints USING btree (id)
- idx_webhooks_endpoints_merchant_id: CREATE INDEX idx_webhooks_endpoints_merchant_id ON public.webhooks_endpoints USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ## 🗂️ Table: webhooks_logs

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **endpoint_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **event_name** (text) NULLABLE: NO
- **payload** (jsonb) NULLABLE: YES, DEFAULT: '{}'::jsonb
- **response_status** (integer) NULLABLE: YES
- **response_body** (text) NULLABLE: YES
- **attempt_number** (integer) NULLABLE: YES, DEFAULT: 1
- **success** (boolean) NULLABLE: YES, DEFAULT: false
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: webhooks_logs_pkey → webhooks_logs(id)
- **CHECK**: 2200_67430_1_not_null
- **CHECK**: 2200_67430_2_not_null
- **CHECK**: 2200_67430_3_not_null
- **CHECK**: 2200_67430_4_not_null

### Indexes
- webhooks_logs_pkey: CREATE UNIQUE INDEX webhooks_logs_pkey ON public.webhooks_logs USING btree (id)
- idx_webhooks_logs_endpoint_id: CREATE INDEX idx_webhooks_logs_endpoint_id ON public.webhooks_logs USING btree (endpoint_id)
- idx_webhooks_logs_merchant_id: CREATE INDEX idx_webhooks_logs_merchant_id ON public.webhooks_logs USING btree (merchant_id)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ## 🗂️ Table: webhooks_retry_queue

### Columns
- **id** (uuid) NULLABLE: NO, DEFAULT: gen_random_uuid()
- **log_id** (uuid) NULLABLE: NO
- **merchant_id** (uuid) NULLABLE: NO
- **next_attempt_at** (timestamp with time zone) NULLABLE: NO
- **max_attempts** (integer) NULLABLE: YES, DEFAULT: 5
- **current_attempt** (integer) NULLABLE: YES, DEFAULT: 0
- **created_at** (timestamp with time zone) NULLABLE: YES, DEFAULT: now()

### Constraints
- **PRIMARY KEY**: webhooks_retry_queue_pkey → webhooks_retry_queue(id)
- **CHECK**: 2200_67444_1_not_null
- **CHECK**: 2200_67444_2_not_null
- **CHECK**: 2200_67444_3_not_null
- **CHECK**: 2200_67444_4_not_null

### Indexes
- webhooks_retry_queue_pkey: CREATE UNIQUE INDEX webhooks_retry_queue_pkey ON public.webhooks_retry_queue USING btree (id)
- idx_webhooks_retry_queue_log_id: CREATE INDEX idx_webhooks_retry_queue_log_id ON public.webhooks_retry_queue USING btree (log_id)
- idx_webhooks_retry_queue_next_attempt_at: CREATE INDEX idx_webhooks_retry_queue_next_attempt_at ON public.webhooks_retry_queue USING btree (next_attempt_at)

---
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |