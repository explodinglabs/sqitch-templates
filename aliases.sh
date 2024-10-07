function show-files {
    local change_name=$1
    for i in deploy verify revert; do cat $i/${change_name}.sql; done
}

# Schema

function create-schema {
    local name=$1
    local change_name=${2:-create_schema_$name}
    ./sqitch add $change_name \
        --template create_schema \
        --set name=$name \
        --note \'"Create $name schema"\' \
    && show-files create_schema_$name
}

function drop-schema {
    local name=$1
    local change_name=${2:-drop_schema_$name}
    ./sqitch add $change_name \
        --template drop_schema \
        --set name=$name \
        --note \'"Drop $name schema"\' \
    && show-files drop_schema_$name
}

# Tables

function create-table {
    local schema_name=$1
    local table_name=$2
    local change_name=${3:-create_table_${schema_name}_${table_name}}
    ./sqitch add $change_name \
        --template create_table \
        --set schema=$schema_name \
        --set name=$table_name \
        --note \'"Create ${schema_name}.${table_name} table"\' \
    && show-files create_table_${schema_name}_${table_name}
}

function drop-table {
    local schema_name=$1
    local table_name=$2
    local change_name=${3:-drop_table_${schema_name}_${table_name}}
    ./sqitch add drop_table_${schema_name}_${table_name} \
        --template drop_table \
        --set schema_name=$schema_name \
        --set table_name=$table_name \
        --note \'"Drop ${schema_name}.${table_name} table"\' \
    && show-files drop_table_${schema_name}_${table_name}
}
