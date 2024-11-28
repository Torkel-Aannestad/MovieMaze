BEGIN;
\echo ''
\echo '030_add_created_at_column'

ALTER TABLE movies             
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE people
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE people_aliases 
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();    
ALTER TABLE categories         
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE image_ids          
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE image_licenses    
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE jobs               
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE movie_categories   
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE movie_keywords     
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE movie_links        
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE movie_references   
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE people_links       
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE trailers           
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE casts    
    ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW();          
COMMIT;