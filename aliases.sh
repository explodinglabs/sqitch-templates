#!/bin/bash
shopt -s expand_aliases
alias sqitch='./sqitch'

function show-files {
    local change=$1
    cat deploy/${change}.sql
    # for i in deploy verify revert; do cat $i/${change}.sql; done
}

# Schema

function create-schema {
    local schema=$1
    local change=${2:-create_schema_$schema}
    sqitch add $change \
        --template create_schema \
        --set schema=$schema \
        --note \'"Create $schema schema"\' \
    && show-files $change
}

function drop-schema {
    local schema=$1
    local change=${2:-drop_schema_$schema}
    sqitch add $change \
        --template drop_schema \
        --set schema=$schema \
        --note \'"Drop $schema schema"\' \
    && show-files $change
}

# Tables

function create-table {
    local schema=$1
    local table=$2
    local change=${3:-create_table_${schema}_${table}}
    sqitch add $change \
        --template create_table \
        --set schema=$schema \
        --set table=$table \
        --note \'"Create ${schema}.${table} table"\' \
    && show-files $change
}

function add-column {
    :
    # sqitch add alter_table_foo_bar_add_baz --template alter_table_add_column --set schema=foo --set table=bar --set column_name=baz --set column_type=integer --note 'Add foo.bar column baz'
}

function drop-table {
    local schema=$1
    local table=$2
    local change=${3:-drop_table_${schema}_${table}}
    sqitch add $change \
        --template drop_table \
        --set schema=$schema \
        --set table=$table \
        --note \'"Drop ${schema}.${table} table"\' \
    && show-files $change \
    && echo "TODO: Recreate the table in revert/${change}.sql" >&2
}

function create-table-users {
    local change=${1:-create_table_users}
    sqitch add $change \
        --template create_table_users \
        --note \'"Create function create_table_users"\' \
    && show-files $change
}

# Roles

function create-role-authenticator {
    local change=${1:-create_role_authenticator}
    sqitch add $change \
        --template create_role_authenticator \
        --note \'"Create role authenticator"\' \
    && show-files $change
}

function create-role {
    local role=$1
    local change=${2:-create_role_${role}}
    sqitch add $change \
        --template create_role \
        --set role=$role \
        --note \'"Create ${role} role"\' \
    && show-files $change
}

function grant-role-membership {
    local role=$1
    local role_specification=$2
    local change=${3:-grant_role_membership_${role}_to_${role_specification}}
    sqitch add $change \
        --template grant_role_membership \
        --set role=$role \
        --set role_specification=$role_specification \
        --note \'"Grant ${role} to ${role_specification}"\' \
    && show-files $change
}

function grant-schema-usage {
    local schema=$1
    local role=$2
    local change=${3:-grant_schema_usage_${schema}_to_${role}}
    sqitch add $change \
        --template grant_schema_usage \
        --set role=$role \
        --set schema=$schema \
        --note \'"Grant ${schema} to ${role}"\' \
    && show-files $change
}

function grant-table-privilege {
    local type=$1
    local schema=$2
    local table=$3
    local role=$4
    local change=${5:-grant_table_privilege_${type}_on_${schema}_${table}_to_${role}}
    sqitch add $change \
        --template grant_table_privilege \
        --set role=$role \
        --set type=$type \
        --set schema=$schema \
        --set table=$table \
        --note \'"Grant ${type} on ${schema}.${table} to ${role}"\' \
    && show-files $change
}

function grant-execute {
    local schema=$1
    local function=$2
    local role=$3
    local change=${4:-grant_execute_${schema}_${function}_to_${role}}
    sqitch add $change \
        --template grant_execute \
        --set schema=$schema \
        --set function=$function \
        --set role=$role \
        --note \'"Grant execute on ${schema}.${function} to ${role}"\' \
    && show-files $change
}

# Functions

function create-function {
    local schema=$1
    local function=$2
    local change=${3:-create_function_${schema}_${function}}
    sqitch add $change \
        --template create_function \
        --set schema=$schema \
        --set function=$function \
        --note \'"Add ${schema}.${function} function"\' \
    && show-files $change
}

function create-function-check-role-exists {
    local change=${1:-create_function_check_role_exists}
    sqitch add $change \
        --template create_function_check_role_exists \
        --note \'"Create function check_role_exists"\' \
    && show-files $change
}

function create-function-encrypt-pass {
    local change=${1:-create_function_encrypt_pass}
    sqitch add $change \
        --template create_function_encrypt_pass \
        --note \'"Create function encrypt_pass"\' \
    && show-files $change
}

# Triggers

function create-trigger {
    local schema=$1
    local table=$2
    local function=$3
    local trigger=$4
    local change=${5:-create_trigger_${schema}_${table}_${trigger}}
    sqitch add $change \
         --template create_trigger \
         --set schema=$schema \
         --set table=$table \
         --set function=$function \
         --set trigger=$trigger \
         --note \'"Add trigger $trigger on ${schema}.${table}"\' \
    && show-files $change
}

function create-trigger-ensure-user-role-exists {
    local change=${1:-create_trigger_ensure_user_role_exists}
    sqitch add $change \
        --template create_trigger_ensure_user_role_exists \
        --note \'"Create trigger ensure_user_role_exists"\' \
    && show-files $change
}

function create-trigger-encrypt-pass {
    local change=${1:-create_trigger_encrypt_pass}
    sqitch add $change \
        --template create_trigger_encrypt_pass \
        --note \'"Create trigger encrypt_pass"\' \
    && show-files $change
}

# Extensions

function create-extension {
    local extension=$1
    local change=${2:-create_extension_$extension}
    sqitch add $change \
        --template create_extension \
        --set extension=$extension \
        --note \'"Create $extension extension"\' \
    && show-files $change
}
