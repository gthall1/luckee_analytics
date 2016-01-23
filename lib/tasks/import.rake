namespace :db do
  desc "Restore latest Heroku db backup locally"
  task restore: :environment do
    # Get the current db config
    config = Rails.configuration.database_configuration[Rails.env]
    # Get around an issue with the Heroku Toolbelt https://github.com/sstephenson/rbenv/issues/400#issuecomment-18742700
    Bundler.with_clean_env do
       # Download the latest backup to a file called latest.dump in tmp folder
      `curl -o tmp/latest.dump \`heroku pg:backups  postgres://rhzsjhdkexfstm:pkBvaR0jRycUaAlrtPBDp2EYeg@ec2-107-22-161-155.compute-1.amazonaws.com:5432/dd7514pc7ca93 -q --remote production\``
       # Restore the backup to the current database
      `export PGPASSWORD=#{config["password"]} && pg_restore --verbose  --clean  --no-acl --no-owner --host=#{config["host"]} --port=#{config["port"]} --username=#{config["username"]} --dbname=#{config["database"]} tmp/latest.dump`
    end
  end
end