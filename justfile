# Variables
CWD := `docker compose exec infinite pwd`
EXEC := "docker compose exec infinite"
COMPOSER := EXEC + " composer"
SYMFONY := EXEC + " symfony"
NPM := EXEC + " npm"

composer +arguments:
    COMPOSER_ALLOW_SUPERUSER=1 {{COMPOSER}} {{arguments}}

console +arguments:
    {{SYMFONY}} console {{arguments}}

npm +arguments:
    {{NPM}} {{arguments}}

add_doctrine_maker:
    {{COMPOSER}} require symfony/orm-pack
    {{COMPOSER}} require --dev symfony/maker-bundle

# Aliases
migration *arguments:
    {{SYMFONY}} console make:migration {{arguments}}

migrate:
    {{SYMFONY}} console doctrine:migrations:migrate --no-interaction

flush:
    {{SYMFONY}} console doctrine:database:drop --force
    {{SYMFONY}} console doctrine:database:create

reset: flush migrate

cc env='dev':
    {{SYMFONY}} console cache:clear --env={{env}}

webpack:
    {{NPM}} run watch

webpack_build:
    {{NPM}} run build

install:
    {{COMPOSER}} install
    {{NPM}} install

new-app:
    {{SYMFONY}} new temp_dir
    {{EXEC}} rm -rf ./temp_dir/.git && cp -R ./temp_dir/. . && sudo rm -rf ./temp_dir